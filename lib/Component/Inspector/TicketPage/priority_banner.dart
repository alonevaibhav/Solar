import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PriorityBanner extends StatelessWidget {
  final String priority;
  final String status;

  const PriorityBanner({
    Key? key,
    required this.priority,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      decoration: BoxDecoration(
        color: priority.toLowerCase() == 'high' ? Colors.red : Colors.amber,
        borderRadius: BorderRadius.circular(8.r),
      ),
      alignment: Alignment.center,
      child: Text(
        'Priority ${priority.capitalizeFirst}',
        style: TextStyle(
          color: Colors.white,
          fontSize: 13.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String get capitalizeFirst => isEmpty ? '' : this[0].toUpperCase() + substring(1);
}