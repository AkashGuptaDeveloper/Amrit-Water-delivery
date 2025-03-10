// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, unnecessary_null_comparison, avoid_function_literals_in_foreach_call, deprecated_member_use
import 'package:amritwaterdelivery/GlobalComponents/HTTPRepository/Packages.dart';
import 'package:flutter/material.dart';

//✅------------------------------------------------------------------------✅//
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

//✅------------------------------------------------------------------------✅//
class LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  LoginProvider? getLoginData;

  //✅------------------------------------------------------------------------✅//
  @override
  void initState() {
    super.initState();
    GlobalFunction().setPortrait();
    getLoginData = Provider.of<LoginProvider>(context, listen: false);
    Provider.of<LoginProvider>(context, listen: false)
        .GlobalAuthenticationLoader = false;
  }

  //✅------------------------------------------------------------------------✅//
  @override
  void dispose() {
    getLoginData = null;
    super.dispose();
  }

  //✅------------------------------------------------------------------------✅//
  @override
  Widget build(BuildContext context) {
    Provider.of<CheckInternet>(context, listen: true);
    Provider.of<LoginProvider>(context, listen: true);
    final GetLoginData = context.watch<LoginProvider>();
    return WillPopScope(
      onWillPop: () async {
        if (!GetLoginData.loadingAuthentication) {
          GlobalFunction().NormalMessageWithTwoButtonAlert(
            context,
            "Notify",
            GlobalFlag.exitanApp,
            "Exit",
          );
        }
        return false; // Always prevent back navigation
      },
      child: Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: GlobalAppColor.BackgroundColor,
        resizeToAvoidBottomInset:
            false, // Allow scrolling when keyboard is open
        body: GestureDetector(
          onTap: () {
            GlobalDecorations.hideKeyboard(context);
          },
          child: Stack(
            children: [
              // 🔹 Logo + Form + Signup (Centered)
              Positioned.fill(
                top: MediaQuery.of(context).padding.top,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 🔹 Logo
                    Animate(
                      effects: const [FadeEffect(), ScaleEffect()],
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          GlobalImage.Logo,
                          fit: BoxFit.contain,
                          width: MediaQuery.of(context).size.width * 0.8,
                          // Adjust width as a percentage of screen width
                          height:
                              MediaQuery.of(context).size.height *
                              0.3, // Optionally set height as a percentage
                        ),
                      ).animate().fade(duration: 1500.ms).scale(delay: 1500.ms),
                    ),
                    const SizedBox(height: 10),
                    // 🔹 Form Fields
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            spacing: 15,
                            children: <Widget>[
                              // Username Field
                              GlobalDecorations.globalCupertinoTextField(
                                duration: Duration(milliseconds: 800),
                                context: context,
                                controller: GetLoginData.UserNameController,
                                focusNode: GetLoginData.myFocusUserName,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                placeholder: 'Enter Username',
                                enabled: !GetLoginData.loadingAuthentication,
                                inputFormatters:
                                    GlobalDecorations.EmailInputFormatters,
                              ),
                              // Password Field
                              GlobalDecorations.globalCupertinoTextField(
                                duration: Duration(milliseconds: 1000),
                                context: context,
                                controller: GetLoginData.UserPasswordController,
                                focusNode: GetLoginData.myFocusPassword,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                placeholder: 'Enter Password',
                                enabled: !GetLoginData.loadingAuthentication,
                                obscureText: GetLoginData.toggle.value,
                                suffix: GestureDetector(
                                  onTap:
                                      GetLoginData.loadingAuthentication == true
                                          ? null
                                          : () {
                                            GetLoginData.SeePassword();
                                          },
                                  child: Icon(
                                    GetLoginData.toggle.value
                                        ? Icons.remove_red_eye_rounded
                                        : Icons.highlight_remove,
                                    size: GlobalDecorations.IconResponsiveValue(
                                      context: context,
                                      mobileValue: 18.0, // Mobile size
                                      tabletValue: 24.0, // Tablet size
                                      desktopValue: 40.0, // Desktop size
                                    ),
                                    color: GlobalAppColor.NewBlackTextCode,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Login Button
                              GlobalDecorations().globalCupertinoButton(
                                context: context,
                                onPressed:
                                    GetLoginData.loadingAuthentication == true
                                        ? null
                                        : () async {
                                          bool isConnected =
                                              await GlobalDecorations()
                                                  .checkInternetConnection(
                                                    context,
                                                  );
                                          if (isConnected) {
                                            validateAndSubmit(context);
                                          }
                                        },
                                isLoading:
                                    GetLoginData.GlobalAuthenticationLoader,
                                buttonText: "Login",
                                loaderKey: GlobalFunction().LoaderKey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 🔹 Signup Text (Bottom)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: GlobalDecorations().FadeInUpWidget(
                  duration: Duration(milliseconds: 1200),
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Don't have an account?  ",
                          style: GlobalDecorations.CommanTextStyle(
                            context,
                            fontWeight: FontWeight.w400,
                            fontSize: 17,
                          ),
                        ),
                        GestureDetector(
                          onTap:
                              GetLoginData.loadingAuthentication == true
                                  ? null
                                  : () {
                                    GlobalFunction().navigateToScreen(
                                      context,
                                      const RegistrationScreen(),
                                    );
                                  },
                          child: Text(
                            "Sign Up",
                            style: GlobalDecorations.CommanTextStyle(
                              context,
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: GlobalAppColor.ButtonColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //✅------------------------------------------------------------------------✅//
  void validateAndSubmit(BuildContext context) async {
    final GetLoginData = Provider.of<LoginProvider>(context, listen: false);
    if (GetLoginData.UserNameController.text.isEmpty) {
      GlobalFunction().PopupFailedAlert(
        context,
        "Failed",
        "",
        "Enter Username",
      );
      return;
    }
    if (GetLoginData.UserPasswordController.text.isEmpty) {
      GlobalFunction().PopupFailedAlert(
        context,
        "Failed",
        "",
        "Enter Password",
      );
      return;
    } else {
      GetLoginData.UserLoginService(context: context);
    }
  }
}

//✅------------------------------------------------------------------------✅//
