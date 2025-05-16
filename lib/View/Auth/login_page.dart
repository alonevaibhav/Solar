// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../Controller/login_controller.dart';
//
// class LoginView extends StatelessWidget {
//   const LoginView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // Initialize controller if not already initialized
//     final LoginController controller = Get.find<LoginController>();
//
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       body: SafeArea(
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             return SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 24.0),
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(
//                   minHeight: constraints.maxHeight,
//                 ),
//                 child: IntrinsicHeight(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       const SizedBox(height: 60),
//                       _buildHeader(),
//                       const SizedBox(height: 60),
//                       _buildLoginForm(controller),
//                       const SizedBox(height: 40),
//                       Obx(() => _buildLoginButton(controller)),
//                       const SizedBox(height: 20),
//                       Obx(() => _buildErrorMessage(controller)),
//                       const SizedBox(height: 30),
//                       _buildTestCredentials(),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Column(
//       children: [
//         const Text(
//           'Welcome!',
//           style: TextStyle(
//             fontSize: 32,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           'Lorem Ipsum is simply dummy text of the\nprinting and typesetting industry.',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 16,
//             color: Colors.grey[600],
//             height: 1.5,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildLoginForm(controller) {
//     return Form(
//       key: controller.formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildEmailField(controller),
//           const SizedBox(height: 24),
//           _buildPasswordField(controller),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmailField(controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Email',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             color: Colors.grey[700],
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: controller.emailController,
//           keyboardType: TextInputType.emailAddress,
//           textInputAction: TextInputAction.next,
//           validator: controller.validateEmail,
//           decoration: InputDecoration(
//             hintText: 'Enter email..',
//             hintStyle: TextStyle(
//               color: Colors.grey[400],
//               fontSize: 16,
//             ),
//             filled: true,
//             fillColor: Colors.white,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: Colors.grey[300]!),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: Colors.grey[300]!),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Colors.black, width: 2),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Colors.red),
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 16,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPasswordField(controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Password',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             color: Colors.grey[700],
//           ),
//         ),
//         const SizedBox(height: 8),
//         Obx(() => TextFormField(
//           controller: controller.passwordController,
//           obscureText: !controller.isPasswordVisible.value,
//           textInputAction: TextInputAction.done,
//           validator: controller.validatePassword,
//           onFieldSubmitted: (_) => controller.login(),
//           decoration: InputDecoration(
//             hintText: 'Enter password..',
//             hintStyle: TextStyle(
//               color: Colors.grey[400],
//               fontSize: 16,
//             ),
//             filled: true,
//             fillColor: Colors.white,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: Colors.grey[300]!),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: Colors.grey[300]!),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Colors.black, width: 2),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Colors.red),
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 16,
//             ),
//             suffixIcon: IconButton(
//               icon: Icon(
//                 controller.isPasswordVisible.value
//                     ? Icons.visibility_off
//                     : Icons.visibility,
//                 color: Colors.grey[600],
//               ),
//               onPressed: controller.togglePasswordVisibility,
//             ),
//           ),
//         )),
//       ],
//     );
//   }
//
//   Widget _buildLoginButton(controller) {
//     return SizedBox(
//       height: 56,
//       child: ElevatedButton(
//         onPressed: controller.isLoading.value ? null : controller.login,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.black,
//           foregroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           elevation: 0,
//           disabledBackgroundColor: Colors.grey[300],
//           disabledForegroundColor: Colors.grey[500],
//         ),
//         child: controller.isLoading.value
//             ? const SizedBox(
//           height: 20,
//           width: 20,
//           child: CircularProgressIndicator(
//             strokeWidth: 2,
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
//           ),
//         )
//             : const Text(
//           'Login',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildErrorMessage(controller) {
//     if (controller.errorMessage.value.isEmpty) {
//       return const SizedBox.shrink();
//     }
//
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.red.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.red.withOpacity(0.3)),
//       ),
//       child: Row(
//         children: [
//           const Icon(
//             Icons.error_outline,
//             color: Colors.red,
//             size: 20,
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               controller.errorMessage.value,
//               style: const TextStyle(
//                 color: Colors.red,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTestCredentials() {
//     final controller = Get.find<LoginController>(); // Add this to ensure controller is available
//
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.blue.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.blue.withOpacity(0.1)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 Icons.info_outline,
//                 color: Colors.blue[600],
//                 size: 20,
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 'Test Credentials',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.blue[700],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           _buildCredentialRow('User Role', 'user@test.com', 'password123',controller),
//           const SizedBox(height: 8),
//           _buildCredentialRow('Cleaner Role', 'cleaner@test.com', 'clean123456',controller),
//           const SizedBox(height: 8),
//           _buildCredentialRow('Inspector Role', 'inspector@test.com', 'inspect123',controller),
//           const SizedBox(width: 8),
//           Text(
//             'Tap any credential to auto-fill',
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey[600],
//               fontStyle: FontStyle.italic,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCredentialRow(String role, String email, String password, controller) {
//     return InkWell(
//       onTap: () {
//         controller.emailController.text = email;
//         controller.passwordController.text = password;
//         controller.updateLoginModel();
//       },
//       borderRadius: BorderRadius.circular(8),
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           color: Colors.white.withOpacity(0.7),
//         ),
//         child: Row(
//           children: [
//             SizedBox(
//               width: 80,
//               child: Text(
//                 role,
//                 style: const TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Text(
//                 email,
//                 style: const TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             Text(
//               password,
//               style: TextStyle(
//                 fontSize: 13,
//                 color: Colors.grey[600],
//                 fontFamily: 'monospace',
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Controller/login_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scale = 0.8; // 20% smaller scale
    final LoginController controller = Get.find<LoginController>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w * scale),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 60.h * scale),
                      _buildHeader(scale),
                      SizedBox(height: 60.h * scale),
                      _buildLoginForm(controller, scale),
                      SizedBox(height: 40.h * scale),
                      Obx(() => _buildLoginButton(controller, scale)),
                      SizedBox(height: 20.h * scale),
                      Obx(() => _buildErrorMessage(controller, scale)),
                      SizedBox(height: 30.h * scale),
                      _buildTestCredentials(controller, scale),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(double scale) {
    return Column(
      children: [
        Text(
          'Welcome!',
          style: TextStyle(
            fontSize: 32.sp * scale,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h * scale),
        Text(
          'Lorem Ipsum is simply dummy text of the\nprinting and typesetting industry.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.sp * scale,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(LoginController controller, double scale) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEmailField(controller, scale),
          SizedBox(height: 24.h * scale),
          _buildPasswordField(controller, scale),
        ],
      ),
    );
  }

  Widget _buildEmailField(LoginController controller, double scale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: TextStyle(
            fontSize: 16.sp * scale,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8.h * scale),
        TextFormField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: controller.validateEmail,
          decoration: InputDecoration(
            hintText: 'Enter email..',
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 16.sp * scale,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r * scale),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r * scale),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r * scale),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r * scale),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w * scale,
              vertical: 16.h * scale,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(LoginController controller, double scale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(
            fontSize: 16.sp * scale,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8.h * scale),
        Obx(() => TextFormField(
          controller: controller.passwordController,
          obscureText: !controller.isPasswordVisible.value,
          textInputAction: TextInputAction.done,
          validator: controller.validatePassword,
          onFieldSubmitted: (_) => controller.login(),
          decoration: InputDecoration(
            hintText: 'Enter password..',
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 16.sp * scale,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r * scale),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r * scale),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r * scale),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r * scale),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w * scale,
              vertical: 16.h * scale,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                controller.isPasswordVisible.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.grey[600],
              ),
              onPressed: controller.togglePasswordVisibility,
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildLoginButton(LoginController controller, double scale) {
    return SizedBox(
      height: 56.h * scale,
      child: ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r * scale),
          ),
          elevation: 0,
          disabledBackgroundColor: Colors.grey[300],
          disabledForegroundColor: Colors.grey[500],
        ),
        child: controller.isLoading.value
            ? SizedBox(
          height: 20.h * scale,
          width: 20.w * scale,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          ),
        )
            : Text(
          'Login',
          style: TextStyle(
            fontSize: 18.sp * scale,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorMessage(LoginController controller, double scale) {
    if (controller.errorMessage.value.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(12.w * scale),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r * scale),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 20,
          ),
          SizedBox(width: 8.w * scale),
          Expanded(
            child: Text(
              controller.errorMessage.value,
              style: TextStyle(
                color: Colors.red,
                fontSize: 14.sp * scale,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestCredentials(LoginController controller, double scale) {
    return Container(
      padding: EdgeInsets.all(16.w * scale),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r * scale),
        border: Border.all(color: Colors.blue.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.blue[600],
                size: 20,
              ),
              SizedBox(width: 8.w * scale),
              Text(
                'Test Credentials',
                style: TextStyle(
                  fontSize: 16.sp * scale,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h * scale),
          _buildCredentialRow('User Role', 'user@test.com', 'password123', controller, scale),
          SizedBox(height: 8.h * scale),
          _buildCredentialRow('Cleaner Role', 'cleaner@test.com', 'clean123456', controller, scale),
          SizedBox(height: 8.h * scale),
          _buildCredentialRow('Inspector Role', 'inspector@test.com', 'inspect123', controller, scale),
          SizedBox(height: 8.h * scale),
          Text(
            'Tap any credential to auto-fill',
            style: TextStyle(
              fontSize: 12.sp * scale,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCredentialRow(String role, String email, String password, LoginController controller, double scale) {
    return InkWell(
      onTap: () {
        controller.emailController.text = email;
        controller.passwordController.text = password;
        controller.updateLoginModel();
      },
      borderRadius: BorderRadius.circular(8.r * scale),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h * scale, horizontal: 12.w * scale),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r * scale),
          color: Colors.white.withOpacity(0.7),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 80.w * scale,
              child: Text(
                role,
                style: TextStyle(
                  fontSize: 12.sp * scale,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
            Expanded(
              child: Text(
                email,
                style: TextStyle(
                  fontSize: 13.sp * scale,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              password,
              style: TextStyle(
                fontSize: 13.sp * scale,
                color: Colors.grey[600],
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
