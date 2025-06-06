import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solar_app/Component/Inspector/TicketPage/CreateTicket/priority_indicator.dart';
import 'package:solar_app/Component/Inspector/TicketPage/CreateTicket/ticket_controller.dart';
import '../../../../utils/custom_text_form_field.dart';
import '../../../../utils/drop_down.dart';

class TicketRaisingView extends StatelessWidget {
  const TicketRaisingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     TicketRaisingController controller = Get.put(TicketRaisingController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Raise Support Ticket',
          style: TextStyle(
            fontSize: 18.sp * 0.9,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w * 0.9),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w * 0.9),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r * 0.9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 0,
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12.w * 0.9),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1565C0).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.r * 0.9),
                                ),
                                child: Icon(
                                  Icons.support_agent,
                                  color: const Color(0xFF1565C0),
                                  size: 24.sp * 0.9,
                                ),
                              ),
                              SizedBox(width: 16.w * 0.9),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Need Help?',
                                      style: TextStyle(
                                        fontSize: 20.sp * 0.9,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1A1A1A),
                                      ),
                                    ),
                                    SizedBox(height: 4.h * 0.9),
                                    Text(
                                      'Describe your issue and our support team will assist you.',
                                      style: TextStyle(
                                        fontSize: 14.sp * 0.9,
                                        color: const Color(0xFF6B7280),
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h * 0.9),

                    Container(
                      padding: EdgeInsets.all(24.w * 0.9),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r * 0.9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 0,
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ticket Details',
                            style: TextStyle(
                              fontSize: 18.sp * 0.9,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                          SizedBox(height: 20.h * 0.9),

                          CustomTextFormField(
                            controller: controller.titleController,
                            validator: controller.validateTitle,
                            labelText: 'Ticket Title *',
                            hintText: 'Brief summary of the issue',
                            borderRadius: 12.r,
                            errorBorderColor: theme.colorScheme.error,
                            labelStyle: TextStyle(
                              fontSize: 14.sp * 0.9,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF374151),
                            ),
                            hintStyle: TextStyle(
                              fontSize: 14.sp * 0.9,
                              color: const Color(0xFF9CA3AF),
                            ),
                            textStyle: TextStyle(
                              fontSize: 14.sp * 0.9,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLength: 100,
                          ),

                          SizedBox(height: 20.h * 0.9),

                          Obx(() => CustomDropdownField<String>(
                            value: controller.selectedTicketType.value,
                            labelText: 'Issue Category',
                            hintText: 'Select category of issue',
                            items: controller.ticketTypes,
                            itemLabelBuilder: (type) => controller.getTicketTypeLabel(type),
                            onChanged: (value) => controller.selectedTicketType.value = value,
                            validator: controller.validateTicketType,
                            prefixIcon: Icons.category_outlined,
                            isRequired: true,
                            borderColor: const Color(0xFFE5E7EB),
                            focusedBorderColor: const Color(0xFF1565C0),
                            fillColor: const Color(0xFFF9FAFB),
                            borderRadius: 12.r * 0.9,
                            labelStyle: TextStyle(
                              fontSize: 14.sp * 0.9,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF374151),
                            ),
                            hintStyle: TextStyle(
                              fontSize: 14.sp * 0.9,
                              color: const Color(0xFF9CA3AF),
                            ),
                            itemTextStyle: TextStyle(
                              fontSize: 14.sp * 0.9,
                              fontWeight: FontWeight.w500,
                            ),
                          )),

                          SizedBox(height: 20.h * 0.9),

                          Obx(() => CustomDropdownField<String>(
                            value: controller.selectedPriority.value,
                            labelText: 'Priority Level',
                            hintText: 'Select priority level',
                            items: controller.priorities,
                            itemLabelBuilder: (priority) => controller.getPriorityLabel(priority),
                            onChanged: (value) => controller.selectedPriority.value = value,
                            validator: controller.validatePriority,
                            prefixIcon: Icons.priority_high,
                            isRequired: true,
                            borderColor: const Color(0xFFE5E7EB),
                            focusedBorderColor: const Color(0xFF1565C0),
                            fillColor: const Color(0xFFF9FAFB),
                            borderRadius: 12.r * 0.9,
                            labelStyle: TextStyle(
                              fontSize: 14.sp * 0.9,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF374151),
                            ),
                            hintStyle: TextStyle(
                              fontSize: 14.sp * 0.9,
                              color: const Color(0xFF9CA3AF),
                            ),
                            itemTextStyle: TextStyle(
                              fontSize: 14.sp * 0.9,
                              fontWeight: FontWeight.w500,
                            ),
                          )),

                          SizedBox(height: 8.h * 0.9),

                          Obx(() => controller.selectedPriority.value != null
                              ? PriorityIndicator(priority: controller.selectedPriority.value!)
                              : const SizedBox.shrink()),

                          SizedBox(height: 20.h * 0.9),

                          CustomTextFormField(
                            controller: controller.descriptionController,
                            validator: controller.validateDescription,
                            maxLines: 6,
                            minLines: 4,
                            labelText: 'Description *',
                            hintText: 'Provide detailed description of the issue, steps to reproduce, and any relevant information...',
                            alignLabelWithHint: true,
                            borderRadius: 12.r,
                            errorBorderColor: theme.colorScheme.error,
                            labelStyle: TextStyle(
                              fontSize: 14.sp * 0.9,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF374151),
                            ),
                            hintStyle: TextStyle(
                              fontSize: 14.sp * 0.9,
                              color: const Color(0xFF9CA3AF),
                              height: 1.4,
                            ),
                            textStyle: TextStyle(
                              fontSize: 14.sp * 0.9,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                            ),
                            maxLength: 1000,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32.h * 0.9),

                    Obx(() => SizedBox(
                      width: double.infinity,
                      height: 56.h * 0.9,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.submitTicket,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r * 0.9),
                          ),
                          disabledBackgroundColor: const Color(0xFF9CA3AF),
                        ),
                        child: controller.isLoading.value
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20.w * 0.9,
                              height: 20.h * 0.9,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w * 0.9),
                            Text(
                              'Creating Ticket...',
                              style: TextStyle(
                                fontSize: 16.sp * 0.9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.send_outlined,
                              size: 20.sp * 0.9,color: Colors.white,
                            ),
                            SizedBox(width: 8.w * 0.9),
                            Text(
                              'Submit Ticket',
                              style: TextStyle(
                                fontSize: 16.sp * 0.9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),

                    SizedBox(height: 16.h * 0.9),

                    SizedBox(
                      width: double.infinity,
                      height: 48.h * 0.9,
                      child: OutlinedButton(
                        onPressed: controller.clearForm,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF6B7280),
                          side: BorderSide(
                            color: const Color(0xFFE5E7EB),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r * 0.9),
                          ),
                        ),
                        child: Text(
                          'Clear Form',
                          style: TextStyle(
                            fontSize: 14.sp * 0.9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 40.h * 0.9),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}