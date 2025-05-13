import 'package:get/get.dart';
import '../Component/Cleaner/assigned_plants_view.dart';
import '../Component/Cleaner/cleanup_history_list.dart';
import '../Component/Cleaner/help_support_view.dart';
import '../Component/Cleaner/update_view.dart';
import '../View/Auth/login_page.dart';
import '../View/Cleaner/c_dashboard.dart';
import '../View/Inspector/in_dashboard.dart';
import '../View/User/u_dashboard.dart';
import 'app_bindings.dart';

class AppRoutes {
  // Route names
  static const login = '/login';
  static const user = '/user/home';
  static const cleaner = '/cleaner/dashboard';
  static const cleanerView = '/cleaner/view';
  static const cleanerUpdateProfile = '/cleaner/cleanerUpdateProfile';
  static const cleanerAssignPlant = '/cleaner/cleanerAssignPlant';
  static const cleanerHelp = '/cleaner/cleanerHelp';
  static const cleanerCleanupHistory = '/cleaner/cleanerCleanupHistory';
  static const inspector = '/inspector/dashboard';

  // All of your pages
  static final routes = <GetPage>[
    GetPage(
      name: login,
      page: () => const LoginView(),
      binding: AppBindings(),
    ),
    GetPage(
      name: user,
      page: () => const UDashboard(),
      binding: AppBindings(),
    ),
    GetPage(
      name: cleaner,
      page: () => const CleanerDashboardView(),
      binding: AppBindings(),
    ),
    GetPage(
      name: cleanerView,
      page: () => const CleanerDashboardView(),
      binding: AppBindings(),
    ),
    GetPage(
      name: cleanerUpdateProfile,
      page: () =>  UpdateProfileView(),
      binding: AppBindings(),
    ),
    GetPage(
      name: cleanerAssignPlant,
      page: () =>  AssignedPlantsView(),
      binding: AppBindings(),
    ),
    GetPage(
      name: cleanerHelp,
      page: () =>  HelpSupportView(),
      binding: AppBindings(),
    ),
    GetPage(
      name: cleanerCleanupHistory,
      page: () =>  CleanUpHistoryView(),
      binding: AppBindings(),
    ),
  ];
}
