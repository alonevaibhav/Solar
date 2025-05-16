import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solar_app/View/Inspector/user_profile.dart';

import '../../Controller/user_profile_controller.dart';
import '../../utils/exit.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text('Inspector Reports Screen', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class InspectorTasksTab extends StatelessWidget {
  const InspectorTasksTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text('Inspector Tasks Screen', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class InspectorHomeTab extends StatelessWidget {
  const InspectorHomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inspector Dashboard'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text('Inspector Home Screen', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class InspectorAlertsTab extends StatelessWidget {
  const InspectorAlertsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alerts'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text('Inspector Alerts Screen', style: TextStyle(fontSize: 24)),
      ),
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
