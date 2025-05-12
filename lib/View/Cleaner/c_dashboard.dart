import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Component/Cleaner/today_inspections_view.dart';
import '../../Controller/Cleaner/today_inspections_controller.dart';
import 'cleaner_bottom_nevigation.dart';

class CleanerDashboardView extends StatefulWidget {
  const CleanerDashboardView({Key? key}) : super(key: key);

  @override
  State<CleanerDashboardView> createState() => _CleanerDashboardViewState();
}

class _CleanerDashboardViewState extends State<CleanerDashboardView> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const CleanerHomeTab(),
    const CleanerProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          _pages[_currentIndex],

          // Floating bottom navigation
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CleanerBottomNavigation(
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
    );
  }
}

// Example tab widgets
class CleanerHomeTab extends StatelessWidget {
  const CleanerHomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final TodayInspectionsController controller = Get.put(TodayInspectionsController());

    return Scaffold(
      body: TodayInspectionsView(),
    );
  }
}

class CleanerProfileTab extends StatelessWidget {
  const CleanerProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text(
          'Cleaner Profile Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}