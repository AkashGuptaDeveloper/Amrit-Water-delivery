// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, unnecessary_null_comparison, avoid_function_literals_in_foreach_call
// ignore: unused_import
import 'package:amritwaterdelivery/GlobalComponents/HTTPRepository/GlobalServiceURL.dart';

export 'dart:async';
export 'dart:convert';
export 'dart:io';
export 'dart:math';

export 'package:amritwaterdelivery/GlobalComponents/CustomConstant/Animation/SlideTransitionRoute.dart';
export 'package:amritwaterdelivery/GlobalComponents/CustomConstant/Constant/GlobalAppColor.dart';
export 'package:amritwaterdelivery/GlobalComponents/CustomConstant/Constant/GlobalDecorations.dart';
export 'package:amritwaterdelivery/GlobalComponents/CustomConstant/Constant/GlobalFlag.dart';
export 'package:amritwaterdelivery/GlobalComponents/CustomConstant/Constant/GlobalFunction.dart';
export 'package:amritwaterdelivery/GlobalComponents/CustomConstant/Constant/GlobalImage.dart';
export 'package:amritwaterdelivery/GlobalComponents/HTTPRepository/CheckInternetConnectivity.dart';
export 'package:amritwaterdelivery/GlobalComponents/HTTPRepository/GlobalServiceURL.dart';
export 'package:amritwaterdelivery/GlobalComponents/HTTPRepository/HttpService.dart';
export 'package:amritwaterdelivery/Screens/AuthScreen/LoginScreen/LoginController.dart';
export 'package:amritwaterdelivery/Screens/AuthScreen/LoginScreen/LoginScreen.dart';
export 'package:amritwaterdelivery/Screens/AuthScreen/RegistrationScreen/RegistrationController.dart';
export 'package:amritwaterdelivery/Screens/AuthScreen/RegistrationScreen/RegistrationScreen.dart';
export 'package:amritwaterdelivery/Screens/HomeScreen/HomeController.dart';
export 'package:amritwaterdelivery/Screens/HomeScreen/HomeModel/DeliveryOrdersModel.dart';
export 'package:amritwaterdelivery/Screens/HomeScreen/HomeScreen.dart';
export 'package:amritwaterdelivery/Screens/HomeScreen/OrderDetails.dart';
export 'package:amritwaterdelivery/Screens/HomeScreen/SideMenu.dart';
export 'package:amritwaterdelivery/Screens/OrderHistory/OrderHistory.dart';
export 'package:amritwaterdelivery/Screens/OrderHistory/OrderHistoryController.dart';
export 'package:amritwaterdelivery/Screens/ResetPassword/ResetPasswordController.dart';
export 'package:amritwaterdelivery/Screens/SplashScreen/SplashScreen.dart';
export 'package:animate_do/animate_do.dart';
export 'package:cached_network_image/cached_network_image.dart';
export 'package:connectivity_plus/connectivity_plus.dart';
export 'package:flutter/cupertino.dart';
export 'package:flutter/foundation.dart';
export 'package:flutter_animate/flutter_animate.dart';
export 'package:flutter_image_compress/flutter_image_compress.dart';
export 'package:fluttertoast/fluttertoast.dart';
export 'package:font_awesome_flutter/font_awesome_flutter.dart';
export 'package:image_picker/image_picker.dart';
export 'package:internet_connection_checker/internet_connection_checker.dart';
export 'package:path_provider/path_provider.dart';
export 'package:provider/provider.dart';
export 'package:responsive_framework/responsive_framework.dart';
export 'package:shared_preferences/shared_preferences.dart';

//-----------------------------API--------------------------------------------//
//----NewAPI.
String RegisterService = GlobalServiceURL.RegisterUrl.toString();
String LoginService = GlobalServiceURL.LoginUrl.toString();
String OrderListService = GlobalServiceURL.OrderListUrl.toString();
String UpdateOrderStatusService =
    GlobalServiceURL.UpdateOrderStatusUrl.toString();
String GetOrderService = GlobalServiceURL.GetOrderUrl.toString();
String ResetPasswordService = GlobalServiceURL.ResetPasswordUrl.toString();

//======================================END===================================//
