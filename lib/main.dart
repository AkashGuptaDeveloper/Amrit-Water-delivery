// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, deprecated_member_use, await_only_futures, unnecessary_null_comparison, unused_local_variable
import 'dart:ui';

import 'package:amritwaterdelivery/GlobalComponents/HTTPRepository/Packages.dart';
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
        ChangeNotifierProvider(create: (context) => ResetPasswordProvider()),
      ],
      child: MaterialApp(
        builder:
            (context, child) => ResponsiveBreakpoints.builder(
              breakpoints: [
                Breakpoint(start: 0, end: 450, name: MOBILE), // Mobile
                Breakpoint(start: 451, end: 800, name: TABLET), // Tablet
                Breakpoint(start: 801, end: 1920, name: DESKTOP), // Desktop
                Breakpoint(start: 1921, end: double.infinity, name: '4K'),
              ],
              child: Builder(
                builder: (context) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: child!,
                  );
                },
              ),
            ),
        useInheritedMediaQuery: true,
        scrollBehavior: MyCustomScrollBehavior(),
        theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
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
