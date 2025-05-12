import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <-- Required for setting system UI overlay
import 'package:get/get.dart';
import 'API Service/api_service.dart';
import 'Route Manager/app_bindings.dart';
import 'Route Manager/app_routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await ApiService.init();

  // 🧱 Match status bar and nav bar with white background
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark, // black icons
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GetMaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        debugShowCheckedModeBanner: false,
        title: 'Restaurant App',
        initialRoute: AppRoutes.login,
        getPages: AppRoutes.routes,
        initialBinding: AppBindings(),
      ),
    );
  }
}
