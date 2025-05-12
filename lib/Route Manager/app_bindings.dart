import 'package:get/get.dart';

import '../Controller/Cleaner/today_inspections_controller.dart';
import '../Controller/login_controller.dart';



class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Register all controllers here
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<TodayInspectionsController>(() => TodayInspectionsController(),);
    // Get.lazyPut<SidebarController>(() => SidebarController(), fenix: true);
    // Get.lazyPut<TableController>(() => TableController(), fenix: true);
    // Get.lazyPut<ChefController>(() => ChefController(), fenix: true);
    // Get.lazyPut<OrderTimerController>(() => OrderTimerController(), fenix: true);
  }
}
