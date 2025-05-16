// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, unnecessary_null_comparison, avoid_function_literals_in_foreach_call, deprecated_member_use
import 'package:amritwaterdelivery/GlobalComponents/HTTPRepository/Packages.dart';
import 'package:flutter/material.dart';

//✅------------------------------------------------------------------------✅//
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

//✅------------------------------------------------------------------------✅//
class ResetPasswordScreenState extends State<ResetPasswordScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> SnackBarscaffoldKey =
      GlobalKey<ScaffoldState>();

  //✅------------------------------------------------------------------------✅//
  @override
  void initState() {
    super.initState();
    GlobalFunction().setPortrait();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = this.context;
      context.read<ResetPasswordProvider>().clearFields(context);
    });
  }

  //✅------------------------------------------------------------------------✅//
  @override
  Widget build(BuildContext context) {
    Provider.of<CheckInternet>(context, listen: true);
    Provider.of<ResetPasswordProvider>(context, listen: true);
    final GetResetPasswordData = context.watch<ResetPasswordProvider>();
    return WillPopScope(
      onWillPop: () async => !GetResetPasswordData.loadingResetPassword,
      child: Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: GlobalAppColor.WhiteColorCode,
        resizeToAvoidBottomInset: true,
        // Allow scrolling when keyboard is open
        key: SnackBarscaffoldKey,
        appBar: AppBar(
          flexibleSpace: Container(color: GlobalAppColor.BackgroundColor),
          iconTheme: IconThemeData(
            color: GlobalAppColor.ButtonColor,
            size: GlobalDecorations.IconResponsiveValue(
              context: context,
              mobileValue: 18.0, // Mobile size
              tabletValue: 30.0, // Tablet size
              desktopValue: 40.0, // Desktop size
            ),
          ),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: true,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // CircleAvatar for image
              ClipOval(
                child: Image.asset(
                  GlobalImage.Logo, // Replace with your image asset
                  width:
                      MediaQuery.of(context).size.width *
                      0.15, // Responsive width
                  height: MediaQuery.of(context).size.width * 0.15,
                  fit: BoxFit.contain,
                  semanticLabel: 'Logo', // Adds accessibility
                ),
              ),
              SizedBox(width: 10), // Adjusted spacing between image and text
              Text(
                'Reset Password',
                style: GlobalDecorations.CommanTextStyle(
                  context,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: GlobalAppColor.ButtonColor,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          leading: Builder(
            builder:
                (context) => IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: GlobalAppColor.ButtonColor,
                  ),
                  onPressed: () {
                    if (!GetResetPasswordData.loadingResetPassword) {
                      Navigator.pop(context);
                    }
                  },
                ),
          ),
        ),
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Please enter your current password and choose a new one to keep your account secure.',
                    style: GlobalDecorations.CommanTextStyle(
                      context,
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                      color: GlobalAppColor.BlackTextCode,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 15),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 15,
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 5,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: GlobalAppColor.BackgroundColor.withValues(
                            alpha: .6,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          spacing: 20,
                          children: <Widget>[
                            GlobalDecorations.globalCupertinoTextField(
                              duration: Duration(milliseconds: 800),
                              context: context,
                              controller:
                                  GetResetPasswordData.UserNameController,
                              focusNode: GetResetPasswordData.myFocusUserName,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              placeholder: 'Enter UserName',
                              enabled:
                                  !GetResetPasswordData.loadingResetPassword,
                            ),
                            GlobalDecorations.globalCupertinoTextField(
                              duration: Duration(milliseconds: 1000),
                              context: context,
                              controller: GetResetPasswordData.NewPwdController,
                              focusNode: GetResetPasswordData.myFocusNewPwd,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                              placeholder: 'Enter New Password',
                              enabled:
                                  !GetResetPasswordData.loadingResetPassword,
                            ),
                            GlobalDecorations.globalCupertinoTextField(
                              duration: Duration(milliseconds: 1200),
                              context: context,
                              controller:
                                  GetResetPasswordData.ConfirmPwdController,
                              focusNode: GetResetPasswordData.myFocusConfirmPwd,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                              placeholder: 'Enter Confirm Password',
                              enabled:
                                  !GetResetPasswordData.loadingResetPassword,
                            ),
                            // Login Button
                            GlobalDecorations().globalCupertinoButton(
                              context: context,
                              onPressed:
                                  GetResetPasswordData.loadingResetPassword ==
                                          true
                                      ? null
                                      : () async {
                                        bool isConnected =
                                            await GlobalDecorations()
                                                .checkInternetConnection(
                                                  context,
                                                );
                                        if (isConnected) {
                                          GetResetPasswordData.validateAndSubmit(
                                            context,
                                          );
                                        }
                                      },
                              isLoading:
                                  GetResetPasswordData
                                      .GlobalResetPasswordLoader,
                              buttonText: "Submit",
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
          ),
        ),
      ),
    );
  }
}

//✅------------------------------------------------------------------------✅//
