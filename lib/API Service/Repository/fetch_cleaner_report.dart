import 'dart:developer'; // Add this
import '../../utils/constants.dart';
import '../Model/Request/cleaner_report.dart';
import '../api_service.dart';

Future<void> fetchCleanerReport() async {
  log('🔍 Starting fetchCleanerReport...', name: 'CleanerReport');

  try {
    log('📦 Retrieving inspector ID...', name: 'CleanerReport');
    String? inspectorIdString = await ApiService.getUid();

    if (inspectorIdString == null) {
      log('❌ Inspector ID not found in SharedPreferences.', name: 'CleanerReport');
      return;
    }

    log('✅ Inspector ID found: $inspectorIdString', name: 'CleanerReport');
    int inspectorId = int.parse(inspectorIdString);
    String url = getCleanerReport(inspectorId);
    log('🌐 Constructed endpoint: $url', name: 'CleanerReport');

    log('📡 Sending GET request to API...', name: 'CleanerReport');
    ApiResponse<ApiResponseModel> response = await ApiService.get<ApiResponseModel>(
      endpoint: url,
      includeToken: true,
      fromJson: (json) => ApiResponseModel.fromJson(json),
    );

    log('📬 Response received. Success: ${response.success}', name: 'CleanerReport');

    if (response.success) {
      log('✅ Report fetched: ${response.data?.message}', name: 'CleanerReport');
      CleanerReport report = response.data!.data;
      log('📝 Report ID: ${report.id}', name: 'CleanerReport');
      log('📝 Report Status: ${report.status}', name: 'CleanerReport');
    } else {
      log('⚠️ Failed to fetch report: ${response.errorMessage}', name: 'CleanerReport');
    }
  } catch (e, stack) {
    log('🔥 Exception occurred: $e', name: 'CleanerReport', error: e, stackTrace: stack);
  }
}
