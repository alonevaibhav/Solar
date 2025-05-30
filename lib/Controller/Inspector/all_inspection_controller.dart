import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../API Service/api_service.dart';
import '../../Model/Inspector/all_inspection_model.dart';

class AllInspectionsController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();
  final allInspection = <Map<String, dynamic>>[].obs;
  final selectedWeekFilter = Rxn<String>();

  // Keep original data for filtering
  final List<Map<String, dynamic>> _originalInspections = [];

  @override
  void onInit() {
    super.onInit();
    print('📱 AllInspectionsController initialized');
    fetchAllInspections();
  }

  Future<void> fetchAllInspections() async {
    print('🔄 Starting fetchAllInspections...');

    try {
      isLoading.value = true;
      errorMessage.value = null;

      final storedUid = await ApiService.getUid();
      print('👤 Retrieved UID: $storedUid');

      if (storedUid == null) {
        throw Exception('User ID not found');
      }

      print('🌐 Making API call...');
      final response = await ApiService.get<InspectionResponse>(
        endpoint: '/schedules/inspector-schedules/inspector/$storedUid/weekly',
        fromJson: (json) {
          print('📥 Raw JSON received: ${json.toString().substring(0, 200)}...');
          return InspectionResponse.fromJson(json);
        },
      );

      print('✅ API Response received');
      print('📊 Response success: ${response.success}');
      print('📊 Response data null check: ${response.data == null}');

      if (response.success && response.data != null) {
        final data = response.data!.data;
        print('📦 Data keys: ${data.keys.toList()}');

        List<Map<String, dynamic>> flattenedInspections = [];

        if (data.isNotEmpty) {
          data.forEach((weekKey, weekInspections) {
            print('📅 Processing $weekKey with ${weekInspections.length} inspections');

            if (weekInspections.isNotEmpty) {
              try {
                final weekMaps = weekInspections.map((inspection) {
                  final jsonMap = inspection.toJson();
                  print('🔍 Inspection ${inspection.id} toJson keys: ${jsonMap.keys.toList()}');
                  return jsonMap;
                }).toList();

                flattenedInspections.addAll(weekMaps);
                print('✅ Added ${weekMaps.length} inspections from $weekKey');
              } catch (e) {
                print('❌ Error processing $weekKey: $e');
              }
            }
          });
        }

        print('📊 Total flattened inspections: ${flattenedInspections.length}');

        // Clear and update safely
        _originalInspections.clear();
        _originalInspections.addAll(flattenedInspections);

        // Update reactive list
        allInspection.clear();
        allInspection.addAll(flattenedInspections);

        print('🎯 Controller state updated:');
        print('   - Original inspections: ${_originalInspections.length}');
        print('   - All inspections (reactive): ${allInspection.length}');

        // Log first few inspections for debugging
        if (allInspection.isNotEmpty) {
          print('🔍 First inspection sample:');
          final firstInspection = allInspection.first;
          print('   - Keys: ${firstInspection.keys.toList()}');
          print('   - ID: ${firstInspection['id']}');
          print('   - Plant ID: ${firstInspection['plant_id']}');
          print('   - Week: ${firstInspection['week']}');
        }

      } else {
        final errorMsg = response.errorMessage ?? 'Failed to load inspection items';
        print('❌ API Error: $errorMsg');
        throw Exception(errorMsg);
      }
    } catch (e) {
      print('💥 Exception in fetchAllInspections: $e');
      print('📚 Stack trace: ${StackTrace.current}');

      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to load inspection items: ${e.toString()}');

      // Clear all data safely
      _originalInspections.clear();
      allInspection.clear();
    } finally {
      isLoading.value = false;
      print('🏁 fetchAllInspections completed. Loading: ${isLoading.value}');
    }
  }

  void filterByWeek(String? week) {
    print('🔽 Filtering by week: $week');
    print('📊 Original inspections count: ${_originalInspections.length}');

    selectedWeekFilter.value = week;

    try {
      if (week == null) {
        // Show all inspections
        print('📂 Showing all inspections');
        allInspection.clear();
        allInspection.addAll(_originalInspections);
      } else {
        // Filter by specific week
        print('🔍 Filtering for week: $week');
        final filtered = _originalInspections.where((inspection) {
          final inspectionWeek = inspection['week'];
          final match = inspectionWeek != null && inspectionWeek.toString() == week;
          if (match) {
            print('✅ Match found: Inspection ${inspection['id']} week ${inspectionWeek}');
          }
          return match;
        }).toList();

        print('📊 Filtered results: ${filtered.length} inspections');
        allInspection.clear();
        allInspection.addAll(filtered);
      }

      print('🎯 Final allInspection count: ${allInspection.length}');
    } catch (e) {
      print('💥 Error in filterByWeek: $e');
      // Fallback to showing all
      allInspection.clear();
      allInspection.addAll(_originalInspections);
    }
  }

  String get currentFilterText {
    return selectedWeekFilter.value == null ? 'All Weeks' : 'Week ${selectedWeekFilter.value}';
  }

  bool isWeekFilterActive(String week) {
    return selectedWeekFilter.value == week;
  }

  bool get isAllFilterActive {
    return selectedWeekFilter.value == null;
  }

  Future<void> refreshInspections() async {
    print('🔄 Manual refresh triggered');
    await fetchAllInspections();
  }
}