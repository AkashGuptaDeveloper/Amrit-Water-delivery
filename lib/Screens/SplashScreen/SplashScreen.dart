// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, unnecessary_null_comparison, avoid_function_literals_in_foreach_call, deprecated_member_use
import 'package:amritwaterdelivery/GlobalComponents/HTTPRepository/Packages.dart';
import 'package:flutter/material.dart';

//✅------------------------------------------------------------------------✅//
// Constants
const Duration splashTimeoutDuration = Duration(seconds: 5);

//✅------------------------------------------------------------------------✅//
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

//✅------------------------------------------------------------------------✅//
class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  //✅------------------------------------------------------------------------✅//
  @override
  void initState() {
    super.initState();
    GlobalFunction().setPortrait();
    _startTimeout();
  }

  //✅------------------------------------------------------------------------✅//
  void _handleTimeout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      if (prefs.getInt("UserLoginID") == null ||
          prefs.getInt("UserLoginID") == 0) {
        _navigateTo(const LoginScreen());
      } else {
        _navigateTo(const HomeScreen());
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching user data: $error');
      }
    }
  }

  //✅------------------------------------------------------------------------✅//
  // ignore: unused_element
  void _navigateTo(Widget destination) {
    if (!mounted) return;
    GlobalFunction().navigateToScreen(context, destination);
  }

  //✅------------------------------------------------------------------------✅//
  void _startTimeout() {
    Future.delayed(splashTimeoutDuration, _handleTimeout);
  }

  //✅------------------------------------------------------------------------✅//
  @override
  Widget build(BuildContext context) {
    Provider.of<CheckInternet>(context, listen: true);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: GlobalAppColor.BackgroundColor,
        resizeToAvoidBottomInset: true,
        body: Container(
          width:
              MediaQuery.of(
                context,
              ).size.width, // Adjust width as a percentage of screen width
          height:
              MediaQuery.of(
                context,
              ).size.height, // Optionally set height as a percentage
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(GlobalImage.Splash),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

//✅------------------------------------------------------------------------✅//
