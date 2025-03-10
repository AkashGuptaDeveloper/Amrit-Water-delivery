// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, unnecessary_null_comparison, avoid_function_literals_in_foreach_call, deprecated_member_use
import 'package:amritwaterdelivery/GlobalComponents/HTTPRepository/Packages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

HttpService httpService = HttpService();

//=============================GlobalFunction=================================//
class GlobalFunction {
  final GlobalKey<ScaffoldState> LoaderKey = GlobalKey<ScaffoldState>();
  //------------------------------------NavigationDrawerList--------------------//
  List<dynamic> NavigationBROWSEDrawerList = [
    {"Title": "Order History", "Icon": FontAwesomeIcons.shoppingCart},
    {"Title": "Contact Us", "Icon": CupertinoIcons.headphones},
    {"Title": "Share", "Icon": FontAwesomeIcons.shareFromSquare},
    {"Title": "Log Out", "Icon": Icons.logout_outlined},
  ];
  //--------------------------------PortraitMode--------------------------------//
  Future<void> setPortrait() async {
    // Set the status bar to be transparent
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Make status bar transparent
        statusBarIconBrightness:
            Brightness.light, // Set icons to light for dark background
      ),
    );
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  //---navigateToScreen---------------------------------------------------------//
  void navigateToScreen(BuildContext context, Widget screen) {
    if (!context.mounted) return;
    Navigator.push(context, SlideTransitionRoute(page: screen));
  }

  //-------------fadeInUpWidget-------------------------------------------------//
  Future<void> NormalMessageWithTwoButtonAlert(
    BuildContext context,
    String msgType,
    String msgTitle,
    String buttonText,
  ) async {
    // Check if the widget is still mounted before showing the dialog
    if (!context.mounted) {
      return;
    }
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (BuildContext context) => WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              contentPadding: EdgeInsets.zero,
              actionsPadding: EdgeInsets.zero,
              content: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: GlobalAppColor.WhiteColorCode,
                ),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 10,
                  children: <Widget>[
                    SizedBox(height: 5.0),
                    Animate(
                      effects: [
                        FadeEffect(delay: 500.ms),
                        const SlideEffect(
                          begin: Offset(0, 0.3),
                          end: Offset(0, 0),
                          curve: Curves.easeOut,
                        ),
                      ],
                      child: Text(
                        msgTitle,
                        textAlign: TextAlign.center,
                        style: GlobalDecorations.CommanTextStyle(
                          context,
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: GlobalAppColor.NewBlackTextCode,
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    SizedBox(
                      width: double.infinity,
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: GlobalDecorations().globalCupertinoButton(
                                context: context,
                                btnHeight: 40,
                                onPressed: () async {
                                  GlobalDecorations.hideKeyboard(context);
                                  if (buttonText == "Logout") {
                                    context
                                        .read<LoginProvider>()
                                        .removeUserData(context);
                                  } else {
                                    exit(0);
                                  }
                                },
                                isLoading: false,
                                buttonText:
                                    buttonText == "Logout"
                                        ? "Logout"
                                        : buttonText,
                                loaderKey: GlobalFunction().LoaderKey,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: GlobalDecorations.CustomButton(
                                btnHeight: 40,
                                context: context,
                                textColor: Colors.white,
                                onPressed: () async {
                                  GlobalDecorations.hideKeyboard(context);
                                  Navigator.pop(context);
                                },
                                buttonText: "Close",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  //---PopupSuccessFailedAlert--------------------------------------------------//
  Future<void> PopupFailedAlert(
    BuildContext context,
    String msgType,
    String btnValue,
    String msgTitle,
  ) async {
    if (!context.mounted) {
      return;
    }
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (BuildContext context) => WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              // Set background to transparent
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              contentPadding: EdgeInsets.zero,
              content: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white,
                ),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  spacing: 15,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 1.0),
                    // Icon Animation
                    Animate(
                      effects: [
                        const FadeEffect(),
                        const ScaleEffect(curve: Curves.elasticOut),
                        SlideEffect(curve: Curves.easeOut, delay: 300.ms),
                      ],
                      child: Icon(
                        _getIconForMessageType(msgType),
                        size:
                            ResponsiveValue(
                              context,
                              defaultValue:
                                  60.0, // Default size for larger screens (desktop)
                              conditionalValues: [
                                Condition.smallerThan(
                                  name: TABLET,
                                  value: 60.0,
                                ), // Tablet size
                                Condition.smallerThan(
                                  name: MOBILE,
                                  value: 18.0,
                                ), // Mobile size
                                Condition.largerThan(
                                  name: DESKTOP,
                                  value: 40.0,
                                ), // Desktop size
                              ],
                            ).value,
                        color: _getIconColor(msgType),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    // Text Animation
                    Animate(
                      effects: [
                        FadeEffect(delay: 500.ms),
                        const SlideEffect(
                          begin: Offset(0, 0.3),
                          end: Offset(0, 0),
                          curve: Curves.easeOut,
                        ),
                      ],
                      child: Text(
                        msgTitle,
                        textAlign: TextAlign.center,
                        style: GlobalDecorations.CommanTextStyle(
                          context,
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                          color: GlobalAppColor.NewBlackTextCode,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    // Button Animation
                    GlobalDecorations.CustomButton(
                      context: context,
                      onPressed: () async {
                        GlobalDecorations.hideKeyboard(context);
                        //Delivery Partner registered successfully
                        if (btnValue ==
                            "Delivery Partner registered successfully") {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      buttonText: "Close",
                      textColor: Colors.white,
                      btnHeight: 40,
                    ),
                  ],
                ),
              ),
              actionsPadding: EdgeInsets.zero,
            ),
          ),
    );
  }

  Color _getIconColor(String msgType) {
    switch (msgType) {
      case "Success":
        return Colors.green;
      case "WorkInProgress":
        return GlobalAppColor.ButtonColor;
      case "Failed":
      case "InternetNotConnected": // Handle both as red
      case "Location": // Handle both as red
        return Colors.red; // Existing case for failed
      default:
        return Colors.black; // Default color if msgType is unknown
    }
  }

  IconData? _getIconForMessageType(String msgType) {
    switch (msgType) {
      case "Success":
        return CupertinoIcons.checkmark_alt_circle_fill;
      case "Failed":
        return CupertinoIcons.exclamationmark_shield_fill;
      case "WorkInProgress":
        return CupertinoIcons.exclamationmark_triangle_fill;
      case "InternetNotConnected":
        return FontAwesomeIcons.wifi;
      case "Location":
        return CupertinoIcons.location_solid;
      default:
        return null;
    }
  }
}
