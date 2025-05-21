import 'package:get/get.dart';
import '../Component/Cleaner/assigned_plants_view.dart';
import '../Component/Cleaner/cleanup_history_list.dart';
import '../Component/Cleaner/help_support_view.dart';
import '../Component/Cleaner/task_detail_view.dart';
import '../Component/Cleaner/update_view.dart';
import '../Component/Inspector/AlertsView/alerts_view.dart';
import '../Component/Inspector/AreaInspectionView/area_history.dart';
import '../Component/Inspector/TicketPage/ticket_detail_view.dart';
import '../Component/Inspector/TicketPage/ticket_view.dart';
import '../Component/Inspector/plant_details_view.dart';
import '../View/Auth/login_page.dart';
import '../View/Cleaner/c_dashboard.dart';
import '../View/Inspector/assigned_plant_view.dart';
import '../View/Inspector/in_dashboard.dart';
import '../View/Inspector/user_profile.dart';
import '../View/User/u_dashboard.dart';
import 'app_bindings.dart';

class AppRoutes {
  // Route names
  static const login = '/login';
  static const user = '/user/home';

  //Cleaner routes

  static const cleaner = '/cleaner/dashboard';
  static const cleanerView = '/cleaner/view';
  static const cleanerTaskDetailView = '/cleaner/cleanerTaskDetailView';
  static const cleanerUpdateProfile = '/cleaner/cleanerUpdateProfile';
  static const cleanerAssignPlant = '/cleaner/cleanerAssignPlant';
  static const cleanerHelp = '/cleaner/cleanerHelp';
  static const cleanerCleanupHistory = '/cleaner/cleanerCleanupHistory';

  // Inspector routes

  static const inspector = '/inspector/dashboard';
  static const inspectorUserProfileView = '/inspector/UserProfileView';
  static const inspectorAssignedPlants = '/inspector/inspectorAssignedPlants';
  static const inspectorPlantDetails = '/inspector/inspectorPlantDetails';
  static const inspectorPlantCard = '/inspector/inspectorPlantCard';
  static const inspectorHistoryPage = '/inspector/inspectorHistoryPage';
  static const inspectorTicketView = '/inspector/inspectorTicketView';
  static const inspectorTicketDetailView = '/inspector/inspectorTicketDetailView';
  static const inspectorAlertView = '/inspector/inspectorAlertView';

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

    //Cleaner routes
    GetPage(
      name: cleaner,
      page: () => const CleanerDashboardView(),
      binding: AppBindings(),
    ),
    GetPage(
      name: cleanerTaskDetailView,
      page: () => const TaskDetailView(),
      binding: AppBindings(),
    ),
    GetPage(
      name: cleanerUpdateProfile,
      page: () => UpdateProfileView(),
      binding: AppBindings(),
    ),
    GetPage(
      name: cleanerAssignPlant,
      page: () => AssignedPlantsView(),
      binding: AppBindings(),
    ),
    GetPage(
      name: cleanerHelp,
      page: () => HelpSupportView(),
      binding: AppBindings(),
    ),
    GetPage(
      name: cleanerCleanupHistory,
      page: () => CleanUpHistoryView(),
      binding: AppBindings(),
    ),

    // Inspector routes
    GetPage(
      name: inspector,
      page: () => InDashboard(),
      binding: AppBindings(),
    ),

    GetPage(
      name: inspectorUserProfileView,
      page: () => UserProfile(),
      binding: AppBindings(),
    ),
    GetPage(
      name: inspectorAssignedPlants,
      page: () => InspectorAssignedPlantsView(),
      binding: AppBindings(),
    ),
    GetPage(
      name: inspectorPlantDetails,
      page: () => PlantDetailsView(),
      binding: AppBindings(),
    ),
    GetPage(
      name: inspectorHistoryPage,
      page: () => AreaHistoryView(),
      binding: AppBindings(),
    ),
    GetPage(
      name: inspectorTicketView,
      page: () => TicketView(),
      binding: AppBindings(),
    ),
    GetPage(
      name: inspectorTicketDetailView,
      page: () => TicketDetailView(),
      binding: AppBindings(),
    ),
    GetPage(
      name: inspectorAlertView,
      page: () => AlertsView(),
      binding: AppBindings(),
    ),
  ];
}
