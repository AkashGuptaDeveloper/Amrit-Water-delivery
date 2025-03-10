// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, unnecessary_null_comparison, avoid_function_literals_in_foreach_call, deprecated_member_use
import 'package:amritwaterdelivery/GlobalComponents/HTTPRepository/Packages.dart';
import 'package:flutter/material.dart';

//✅------------------------------------------------------------------------✅//
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

//✅------------------------------------------------------------------------✅//
class RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  RegisterProvider? getRegisterData;

  //✅------------------------------------------------------------------------✅//
  @override
  void initState() {
    super.initState();
    GlobalFunction().setPortrait();
    getRegisterData = Provider.of<RegisterProvider>(context, listen: false);
    Provider.of<RegisterProvider>(context, listen: false)
        .GlobalRegistrationLoader = false;
  }

  //✅------------------------------------------------------------------------✅//
  @override
  void dispose() {
    getRegisterData = null;
    super.dispose();
  }

  //✅------------------------------------------------------------------------✅//
  @override
  Widget build(BuildContext context) {
    Provider.of<CheckInternet>(context, listen: true);
    Provider.of<RegisterProvider>(context, listen: true);
    final GetRegisterData = context.watch<RegisterProvider>();
    return WillPopScope(
      onWillPop: () async => !GetRegisterData.loadingRegistration,
      child: Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: GlobalAppColor.BackgroundColor,
        resizeToAvoidBottomInset: true, // Allow scrolling when keyboard is open
        body: GestureDetector(
          onTap: () {
            GlobalDecorations.hideKeyboard(context);
          },
          child: Stack(
            children: [
              // 🔹 Back Button (Top Left)
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                left: 10,
                child: GestureDetector(
                  onTap:
                      GetRegisterData.loadingRegistration == true
                          ? null
                          : () {
                            Navigator.of(context).pop(); // Navigate back
                          },
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 24,
                    color: GlobalAppColor.ButtonColor, // Change color as needed
                  ),
                ),
              ),
              // 🔹 Logo + Form + Signup (Centered)
              Positioned.fill(
                top: MediaQuery.of(context).padding.top,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 40),
                    // 🔹 Logo
                    Animate(
                      effects: const [FadeEffect(), ScaleEffect()],
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 200,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Center(
                                child: Container(
                                  width: 150.0,
                                  height: 150.0,
                                  decoration: BoxDecoration(
                                    color: GlobalAppColor.WhiteColorCode,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: GlobalAppColor.WhiteColorCode,
                                      width: 1.0,
                                    ),
                                  ),
                                  child:
                                      GetRegisterData.ProfileImageFile == null
                                          ? CircleAvatar(
                                            backgroundColor:
                                                GlobalAppColor.WhiteColorCode,
                                            radius: 35,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                  GlobalServiceURL
                                                      .ProfileImagesUrl,
                                                ),
                                          )
                                          : CircleAvatar(
                                            backgroundColor:
                                                GlobalAppColor.WhiteColorCode,
                                            radius: 35,
                                            backgroundImage: FileImage(
                                              GetRegisterData.ProfileImageFile!,
                                            ),
                                          ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 10.0,
                                  left: 145.0,
                                ),
                                child: GestureDetector(
                                  onTap:
                                      GetRegisterData.loadingRegistration ==
                                              true
                                          ? null
                                          : () async {
                                            GetRegisterData.ProfileImageFile =
                                                null;
                                            GetRegisterData.OpenImagePickerModal(
                                              context,
                                              "Upload Profile Picture",
                                            );
                                          },
                                  child: CircleAvatar(
                                    backgroundColor: GlobalAppColor.ButtonColor,
                                    radius:
                                        GlobalDecorations.IconResponsiveValue(
                                          context: context,
                                          mobileValue: 18.0, // Mobile size
                                          tabletValue: 20.0, // Tablet size
                                          desktopValue: 40.0, // Desktop size
                                        ),
                                    child: Icon(
                                      CupertinoIcons.camera_fill,
                                      color: GlobalAppColor.WhiteColorCode,
                                      size:
                                          GlobalDecorations.IconResponsiveValue(
                                            context: context,
                                            mobileValue: 18.0, // Mobile size
                                            tabletValue: 20.0, // Tablet size
                                            desktopValue: 40.0, // Desktop size
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate().fade(duration: 1500.ms).scale(delay: 1500.ms),
                    ),
                    // 🔹 Form Fields
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            spacing: 15,
                            children: <Widget>[
                              // Name Field
                              GlobalDecorations.globalCupertinoTextField(
                                duration: Duration(milliseconds: 600),
                                context: context,
                                controller: GetRegisterData.NameController,
                                focusNode: GetRegisterData.myFocusName,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                placeholder: 'Enter Name',
                                enabled: !GetRegisterData.loadingRegistration,
                              ),
                              // Mobile Field
                              GlobalDecorations.globalCupertinoTextField(
                                duration: Duration(milliseconds: 800),
                                maxLines: 1,
                                maxLength: 10,
                                inputFormatters:
                                    GlobalDecorations.NumberInputFormatters,
                                context: context,
                                controller: GetRegisterData.MobileController,
                                focusNode: GetRegisterData.myFocusMobile,
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.done,
                                placeholder: 'Enter Mobile',
                                enabled: !GetRegisterData.loadingRegistration,
                              ),
                              // Email Field
                              GlobalDecorations.globalCupertinoTextField(
                                duration: Duration(milliseconds: 1000),
                                inputFormatters:
                                    GlobalDecorations.EmailInputFormatters,
                                context: context,
                                controller: GetRegisterData.EmailController,
                                focusNode: GetRegisterData.myFocusEmail,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                placeholder: 'Enter Email',
                                enabled: !GetRegisterData.loadingRegistration,
                              ),
                              // Username Field
                              GlobalDecorations.globalCupertinoTextField(
                                duration: Duration(milliseconds: 1200),
                                context: context,
                                controller:
                                    GetRegisterData.UserRegisterNameController,
                                focusNode:
                                    GetRegisterData.myFocusUserRegisterName,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                placeholder: 'Enter Username',
                                enabled: !GetRegisterData.loadingRegistration,
                              ),
                              // Password Field
                              GlobalDecorations.globalCupertinoTextField(
                                obscureText: GetRegisterData.toggle.value,
                                duration: Duration(milliseconds: 1400),
                                context: context,
                                controller:
                                    GetRegisterData
                                        .UserRegisterPasswordController,
                                focusNode:
                                    GetRegisterData.myFocusRegisterPassword,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                placeholder: 'Enter Password',
                                enabled: !GetRegisterData.loadingRegistration,
                                suffix: GestureDetector(
                                  onTap:
                                      GetRegisterData.loadingRegistration ==
                                              true
                                          ? null
                                          : () {
                                            GetRegisterData.SeePassword();
                                          },
                                  child: Icon(
                                    GetRegisterData.toggle.value
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
                              // Login Button
                              GlobalDecorations().globalCupertinoButton(
                                context: context,
                                onPressed:
                                    GetRegisterData.loadingRegistration == true
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
                                    GetRegisterData.GlobalRegistrationLoader,
                                buttonText: "Register",
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
            ],
          ),
        ),
      ),
    );
  }

  //✅------------------------------------------------------------------------✅//
  void validateAndSubmit(BuildContext context) async {
    final GetRegisterData = Provider.of<RegisterProvider>(
      context,
      listen: false,
    );
    if (GetRegisterData.NameController.text.trim().isEmpty) {
      GlobalFunction().PopupFailedAlert(context, "Failed", "", "Enter Name");
      return;
    }
    if (GetRegisterData.MobileController.text.trim().isEmpty) {
      GlobalFunction().PopupFailedAlert(
        context,
        "Failed",
        "",
        GlobalFlag.MobileisRequired,
      );
      return;
    }
    if (GetRegisterData.MobileController.text.trim().length != 10) {
      GlobalFunction().PopupFailedAlert(
        context,
        "Failed",
        "",
        GlobalFlag.Mobilenumbermust10digits,
      );
      return;
    }
    if (GetRegisterData.EmailController.text.trim().isEmpty) {
      GlobalFunction().PopupFailedAlert(
        context,
        "Failed",
        "",
        GlobalFlag.EmailRequireds,
      );
      return;
    }
    if (!RegExp(
      GlobalFlag.PattternEmails.toString(),
    ).hasMatch(GetRegisterData.EmailController.text.trim())) {
      GlobalFunction().PopupFailedAlert(
        context,
        "Failed",
        "",
        GlobalFlag.InvalidEmails,
      );
      return;
    }
    if (GetRegisterData.UserRegisterNameController.text.trim().isEmpty) {
      GlobalFunction().PopupFailedAlert(
        context,
        "Failed",
        "",
        "Enter UserName",
      );
      return;
    }
    if (GetRegisterData.UserRegisterPasswordController.text.trim().isEmpty) {
      GlobalFunction().PopupFailedAlert(
        context,
        "Failed",
        "",
        "Enter Password",
      );
      return;
    } else {
      Provider.of<RegisterProvider>(
        context,
        listen: false,
      ).UserRegistrationService(context: context);
    }
  }
}

//✅------------------------------------------------------------------------✅//
