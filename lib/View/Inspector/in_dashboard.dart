import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solar_app/View/Inspector/plant_inspection_view.dart';
import 'package:solar_app/View/Inspector/user_profile.dart';

import '../../Component/Inspector/AlertsView/alerts_view.dart';
import '../../Component/Inspector/TicketPage/ticket_view.dart';
import '../../Controller/AlertView/alerts_controller.dart';
import '../../Controller/Inspector/area_inspection_controller.dart';
import '../../Controller/Inspector/plant_inspection_controller.dart';
import '../../Controller/Inspector/ticket_controller.dart';
import '../../Controller/Inspector/user_profile_controller.dart';
import '../../utils/exit.dart';
import 'area_inspection_view.dart';
import 'bottom_nevigation.dart';

class InDashboard extends StatefulWidget {
  const InDashboard({Key? key}) : super(key: key);

  @override
  State<InDashboard> createState() => _InDashboardState();
}

class _InDashboardState extends State<InDashboard> {
  int _currentIndex = 2; // Start at Home (index 2)

  final List<Widget> _pages = [
    const InspectorReportsTab(),
    const InspectorTasksTab(),
    const InspectorHomeTab(),
    const InspectorAlertsTab(),
    const InspectorProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return DoubleBackToExit(
      child: Scaffold(
        body: Stack(
          children: [
            // Main content
            _pages[_currentIndex],

            // Floating bottom navigation
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: InspectorBottomNavigation(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Example tab widgets
class InspectorReportsTab extends StatelessWidget {
  const InspectorReportsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AreaInspectionController controller =
        Get.put(AreaInspectionController());

    return Scaffold(
      body: AreaInspectionView(),
    );
  }
}

class InspectorTasksTab extends StatelessWidget {
  const InspectorTasksTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final TicketController controller = Get.put(TicketController());

    return Scaffold(
      body: TicketView(),
    );
  }
}

class InspectorHomeTab extends StatelessWidget {
  const InspectorHomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlantInspectionController controller = Get.put(PlantInspectionController());
    return Scaffold(
      body: PlantInspectionView(),
    );
  }
}

class InspectorAlertsTab extends StatelessWidget {
  const InspectorAlertsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final AlertsController controller = Get.put(AlertsController());


    return Scaffold(
      body: AlertsView()
    );
  }
}

class InspectorProfileTab extends StatelessWidget {
  const InspectorProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final IUserProfile controller = Get.put(IUserProfile());

    return Scaffold(
      body: UserProfile(),
    );
  }
}
