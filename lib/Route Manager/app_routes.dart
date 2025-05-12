import 'package:get/get.dart';
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
      name: inspector,
      page: () => const InDashboard(),
      binding: AppBindings(),
    ),
  ];
}
