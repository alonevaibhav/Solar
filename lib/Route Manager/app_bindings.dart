import 'package:get/get.dart';

import '../Controller/Cleaner/cleanup_controller.dart';
import '../Controller/Cleaner/general_information_controller.dart';
import '../Controller/Cleaner/profile_controller.dart';
import '../Controller/Cleaner/today_inspections_controller.dart';
import '../Controller/Inspector/plant_managment_controller.dart';
import '../Controller/login_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {

    // Register all controllers here
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<TodayInspectionsController>(() => TodayInspectionsController(),);
    Get.lazyPut<CleanUpHistoryController>(() => CleanUpHistoryController(),);
    Get.lazyPut<ProfileController>(() => ProfileController(),);
    Get.lazyPut<GeneralInformationController>(() => GeneralInformationController(),);
    Get.lazyPut<PlantManagementController>(() => PlantManagementController(),);
  }
  // Get.lazyPut<SidebarController>(() => SidebarController(), fenix: true);
  // Get.lazyPut<TableController>(() => TableController(), fenix: true);
  // Get.lazyPut<ChefController>(() => ChefController(), fenix: true);
  // Get.lazyPut<OrderTimerController>(() => OrderTimerController(), fenix: true);
}
