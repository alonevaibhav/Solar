// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class TicketCardWidget extends StatelessWidget {
//   final Map<String, dynamic> ticket;
//   final Function(String) onCallPressed;
//   final Function(String) onNavigatePressed;
//
//   const TicketCardWidget({
//     Key? key,
//     required this.ticket,
//     required this.onCallPressed,
//     required this.onNavigatePressed,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//
//     final bool isClosed = ticket['status'] == 'closed';
//     final String priority = ticket['priority'] ?? 'low'; // Default to 'low' if not specified
//
//
//     return Container(
//       margin: EdgeInsets.only(bottom: 12.8.h),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.8.r),
//         border: Border.all(
//           color: isClosed ? Colors.green : Colors.orange,
//           width: 0.8.w,
//         ),
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(12.8.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Title and Status Row
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   ticket['title'] ?? '',
//                   style: TextStyle(
//                     fontSize: 12.8.sp,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//
//                 SizedBox(width: 8.w), // Add some space between title and priority
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
//                   decoration: BoxDecoration(
//                     color: priority == 'high' ? Colors.red : Colors.blue,
//                     borderRadius: BorderRadius.circular(4.r),
//                   ),
//                   child: Text(
//                     priority.toUpperCase(),
//                     style: TextStyle(
//                       fontSize: 9.6.sp,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 _buildStatusIndicator(isClosed),
//               ],
//             ),
//             SizedBox(height: 3.2.h),
//
//             // Description
//             Text(
//               ticket['description'] ?? '',
//               style: TextStyle(
//                 fontSize: 11.2.sp,
//                 color: Colors.grey[700],
//               ),
//             ),
//             SizedBox(height: 3.2.h),
//
//             // Assigned To
//             Text(
//               'Assigned To',
//               style: TextStyle(
//                 fontSize: 11.2.sp,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             SizedBox(height: 3.2.h),
//
//             // Remark
//             Text(
//               'Remark',
//               style: TextStyle(
//                 fontSize: 11.2.sp,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             SizedBox(height: 6.4.h),
//
//             // Contact Info Section
//             _buildContactInfoSection(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatusIndicator(bool isClosed) {
//     return Row(
//       children: [
//         Container(
//           width: 8.w,
//           height: 8.h,
//           decoration: BoxDecoration(
//             color: isClosed ? Colors.green : Colors.orange,
//             shape: BoxShape.circle,
//           ),
//         ),
//         SizedBox(width: 3.2.w),
//         Text(
//           isClosed ? 'Closed' : 'Open',
//           style: TextStyle(
//             fontSize: 11.2.sp,
//             fontWeight: FontWeight.w500,
//             color: isClosed ? Colors.green : Colors.orange,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildContactInfoSection() {
//     return Row(
//       children: [
//         // Left side: Name, Phone, Opened, Closed
//         Expanded(
//           flex: 1,
//           child: Container(
//             padding: EdgeInsets.all(9.6.w),
//             decoration: BoxDecoration(
//               color: Colors.grey[100],
//               borderRadius: BorderRadius.circular(6.4.r),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       'Name: ',
//                       style: TextStyle(
//                         fontSize: 9.6.sp,
//                         color: Colors.grey[700],
//                       ),
//                     ),
//                     Text(
//                       '${ticket['name'] ?? ''}',
//                       style: TextStyle(
//                         fontSize: 9.6.sp,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 3.2.h),
//                 Row(
//                   children: [
//                     Text(
//                       'Phone: ',
//                       style: TextStyle(
//                         fontSize: 9.6.sp,
//                         color: Colors.grey[700],
//                       ),
//                     ),
//                     Text(
//                       '${ticket['phone'] ?? ''}',
//                       style: TextStyle(
//                         fontSize: 9.6.sp,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 3.2.h),
//                 Row(
//                   children: [
//                     Text(
//                       'Opened: ',
//                       style: TextStyle(
//                         fontSize: 9.6.sp,
//                         color: Colors.grey[700],
//                       ),
//                     ),
//                     Text(
//                       '${ticket['opened'] ?? ''}',
//                       style: TextStyle(
//                         fontSize: 9.6.sp,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 3.2.h),
//                 Row(
//                   children: [
//                     Text(
//                       'Closed: ',
//                       style: TextStyle(
//                         fontSize: 9.6.sp,
//                         color: Colors.grey[700],
//                       ),
//                     ),
//                     Text(
//                       '${ticket['closed'] ?? ''}',
//                       style: TextStyle(
//                         fontSize: 9.6.sp,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//
//         SizedBox(width: 6.4.w),
//
//         // Right side: Location and action buttons
//         Expanded(
//           flex: 1,
//           child: Container(
//             padding: EdgeInsets.all(9.6.w),
//             decoration: BoxDecoration(
//               color: Colors.grey[100],
//               borderRadius: BorderRadius.circular(6.4.r),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Location',
//                   style: TextStyle(
//                     fontSize: 9.6.sp,
//                     color: Colors.grey[700],
//                   ),
//                 ),
//                 SizedBox(height: 6.4.h),
//                 Text(
//                   '${ticket['location'] ?? ''}',
//                   style: TextStyle(
//                     fontSize: 9.6.sp,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 SizedBox(height: 6.4.h),
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //   children: [
//                 //     InkWell(
//                 //       onTap: () => onCallPressed(ticket['phone'] ?? ''),
//                 //       child: Container(
//                 //         padding: EdgeInsets.all(4.8.w),
//                 //         decoration: BoxDecoration(
//                 //           color: Colors.blue,
//                 //           shape: BoxShape.circle,
//                 //         ),
//                 //         child: Icon(
//                 //           Icons.phone,
//                 //           color: Colors.white,
//                 //           size: 14.4.sp,
//                 //         ),
//                 //       ),
//                 //     ),
//                 //     InkWell(
//                 //       onTap: () => onNavigatePressed(ticket['location'] ?? ''),
//                 //       child: Container(
//                 //         padding: EdgeInsets.all(4.8.w),
//                 //         decoration: BoxDecoration(
//                 //           color: Colors.blue,
//                 //           shape: BoxShape.circle,
//                 //         ),
//                 //         child: Icon(
//                 //           Icons.navigation,
//                 //           color: Colors.white,
//                 //           size: 14.4.sp,
//                 //         ),
//                 //       ),
//                 //     ),
//                 //   ],
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TicketCardWidget extends StatelessWidget {
  final Map<String, dynamic> ticket;
  final Function(String) onCallPressed;
  final Function(String) onNavigatePressed;
  final Function(Map<String, dynamic>) onTap; // New onTap callback

  const TicketCardWidget({
    Key? key,
    required this.ticket,
    required this.onCallPressed,
    required this.onNavigatePressed,
    required this.onTap, // Add onTap to the constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isClosed = ticket['status'] == 'closed';
    final String priority = ticket['priority'] ?? 'low'; // Default to 'low' if not specified

    return GestureDetector(
      onTap: () => onTap(ticket), // Call onTap when the card is tapped
      child: Container(
        margin: EdgeInsets.only(bottom: 12.8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.8.r),
          border: Border.all(
            color: isClosed ? Colors.green : Colors.orange,
            width: 0.8.w,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Status Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ticket['title'] ?? '',
                    style: TextStyle(
                      fontSize: 12.8.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 8.w), // Add some space between title and priority
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: priority == 'high' ? Colors.red : Colors.blue,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      priority.toUpperCase(),
                      style: TextStyle(
                        fontSize: 9.6.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildStatusIndicator(isClosed),
                ],
              ),
              SizedBox(height: 3.2.h),

              // Description
              Text(
                ticket['description'] ?? '',
                style: TextStyle(
                  fontSize: 11.2.sp,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 3.2.h),

              // Assigned To
              Text(
                'Assigned To',
                style: TextStyle(
                  fontSize: 11.2.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 3.2.h),

              // Remark
              Text(
                'Remark',
                style: TextStyle(
                  fontSize: 11.2.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 6.4.h),

              // Contact Info Section
              _buildContactInfoSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(bool isClosed) {
    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: isClosed ? Colors.green : Colors.orange,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 3.2.w),
        Text(
          isClosed ? 'Closed' : 'Open',
          style: TextStyle(
            fontSize: 11.2.sp,
            fontWeight: FontWeight.w500,
            color: isClosed ? Colors.green : Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfoSection() {
    return Row(
      children: [
        // Left side: Name, Phone, Opened, Closed
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(9.6.w),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(6.4.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Name: ',
                      style: TextStyle(
                        fontSize: 9.6.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      '${ticket['name'] ?? ''}',
                      style: TextStyle(
                        fontSize: 9.6.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.2.h),
                Row(
                  children: [
                    Text(
                      'Phone: ',
                      style: TextStyle(
                        fontSize: 9.6.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      '${ticket['phone'] ?? ''}',
                      style: TextStyle(
                        fontSize: 9.6.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.2.h),
                Row(
                  children: [
                    Text(
                      'Opened: ',
                      style: TextStyle(
                        fontSize: 9.6.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      '${ticket['opened'] ?? ''}',
                      style: TextStyle(
                        fontSize: 9.6.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.2.h),
                Row(
                  children: [
                    Text(
                      'Closed: ',
                      style: TextStyle(
                        fontSize: 9.6.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      '${ticket['closed'] ?? ''}',
                      style: TextStyle(
                        fontSize: 9.6.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        SizedBox(width: 6.4.w),

        // Right side: Location and action buttons
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(9.6.w),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(6.4.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 9.6.sp,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 6.4.h),
                Text(
                  '${ticket['location'] ?? ''}',
                  style: TextStyle(
                    fontSize: 9.6.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6.4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => onCallPressed(ticket['phone'] ?? ''),
                      child: Container(
                        padding: EdgeInsets.all(4.8.w),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.phone,
                          color: Colors.white,
                          size: 14.4.sp,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => onNavigatePressed(ticket['location'] ?? ''),
                      child: Container(
                        padding: EdgeInsets.all(4.8.w),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.navigation,
                          color: Colors.white,
                          size: 14.4.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
