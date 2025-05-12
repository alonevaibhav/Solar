import 'package:get/get.dart';
import '../View/Auth/login_page.dart';
import 'app_bindings.dart';

class AppRoutes {
  // Route names
  static const login = '/login';
  static const waiter = '/waiter';
  static const chef = '/chef';
  static const homepage = '/homepage';
  static const notification = '/notification';
  static const history = '/history';
  static const settings = '/settings';
  static const addCustomer = '/addCustomer';
  static const addDish = '/addDish';
  static const readyOrder = '/add_dish';

  // All of your pages
  static final routes = <GetPage>[
    GetPage(
      name: login,
      page: () => const LoginPage(),
      binding: AppBindings(),
    ),

  ];
}
