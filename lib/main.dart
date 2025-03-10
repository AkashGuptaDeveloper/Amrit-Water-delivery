// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, unnecessary_null_comparison, avoid_function_literals_in_foreach_call
import 'dart:ui';

import 'package:amritwaterdelivery/GlobalComponents/HTTPRepository/Packages.dart';
import 'package:amritwaterdelivery/Screens/OrderHistory/OrderHistoryController.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//----------------------------------------------------------------------------//
// Main method
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await GlobalFunction().setPortrait();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Make status bar transparent
      statusBarIconBrightness:
          Brightness.light, // Set icons to light for dark background
    ),
  );
  GestureBinding.instance.resamplingEnabled = true;
  runApp(const MyApp());
}

//----------------------------------------------------------------------------//
// MyApp Widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CheckInternet(context)),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => RegisterProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => OrderHistoryProvider()),
      ],
      child: MaterialApp(
        builder:
            (context, child) => ResponsiveBreakpoints.builder(
              breakpoints: [
                const Breakpoint(start: 0, end: 450, name: MOBILE),
                const Breakpoint(start: 451, end: 800, name: TABLET),
                const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
              ],
              child: child!,
            ),
        scrollBehavior: MyCustomScrollBehavior(),
        theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}

//----------------------------------------------------------------------------//
// HttpOverrides for SSL certificate handling
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) =>
              true; // Ignore certificate errors
  }
}

//----------------------------------------------------------------------------//
// Custom scroll behavior for responsive design
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

//----------------------------------------------------------------------------//
