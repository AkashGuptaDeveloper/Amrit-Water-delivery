// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, unnecessary_null_comparison, avoid_function_literals_in_foreach_calls
import 'package:amritwaterdelivery/GlobalComponents/HTTPRepository/Packages.dart';
import 'package:flutter/services.dart';

//--🟢RegisterProvider-------🟢----------------------------------------//
class RegisterProvider with ChangeNotifier {
  final TextEditingController NameController = TextEditingController();
  final FocusNode myFocusName = FocusNode();
  final TextEditingController MobileController = TextEditingController();
  final FocusNode myFocusEmail = FocusNode();
  final TextEditingController EmailController = TextEditingController();
  final FocusNode myFocusMobile = FocusNode();
  final TextEditingController UserRegisterNameController =
      TextEditingController();
  final FocusNode myFocusUserRegisterName = FocusNode();
  final TextEditingController UserRegisterPasswordController =
      TextEditingController();
  final FocusNode myFocusRegisterPassword = FocusNode();
  ValueNotifier<bool> toggle = ValueNotifier<bool>(true);
  File? ProfileImageFile;
  String alertMessage = '';

  //✅------------------------------------------------------------------------✅//
  void SeePassword() async {
    toggle.value = !toggle.value;
    notifyListeners();
  }

  //-----ProfileImageFile-------------------------------------------------------//
  Future<void> OpenImagePickerModal(BuildContext context, MSG) async {
    showCupertinoModalPopup<void>(
      context: context,
      builder:
          (BuildContext context) => CupertinoActionSheet(
            title: Text(
              MSG,
              textAlign: TextAlign.center,
              style: GlobalDecorations.CommanTextStyle(
                context,
                fontWeight: FontWeight.w400,
                fontSize: 16.0,
                color: GlobalAppColor.BlackTextCode,
                letterSpacing: 1,
              ),
            ),
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                isDefaultAction: true,
                onPressed: () async {
                  // Handle camera action here
                  Navigator.of(context).pop();
                  // Add image picking logic
                  await _pickImage(context, ImageSource.camera, MSG);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      CupertinoIcons.camera,
                      size: GlobalDecorations.IconResponsiveValue(
                        context: context,
                        mobileValue: 18.0, // Mobile size
                        tabletValue: 24.0, // Tablet size
                        desktopValue: 40.0, // Desktop size
                      ),
                      color: GlobalAppColor.ButtonColor,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Camera",
                      style: GlobalDecorations.CommanTextStyle(
                        context,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                        color: GlobalAppColor.BlackTextCode,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              CupertinoActionSheetAction(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _pickImage(context, ImageSource.gallery, MSG);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      CupertinoIcons.photo,
                      size: GlobalDecorations.IconResponsiveValue(
                        context: context,
                        mobileValue: 18.0, // Mobile size
                        tabletValue: 24.0, // Tablet size
                        desktopValue: 40.0, // Desktop size
                      ),
                      color: GlobalAppColor.ButtonColor,
                    ),
                    SizedBox(width: 15),
                    Text(
                      "Gallery",
                      style: GlobalDecorations.CommanTextStyle(
                        context,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                        color: GlobalAppColor.BlackTextCode,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Close",
                  style: GlobalDecorations.CommanTextStyle(
                    context,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                    color: GlobalAppColor.BlackTextCode,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  //---------------------------------_pickImage---------------------------------//
  Future _pickImage(context, ImageSource source, MSG) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      ProfileImageFile = imageTemporary;
      notifyListeners();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed Image Pick: $e");
      }
    }
  }

  //-----Registration-Login-----------------------------------------------------//
  bool GlobalRegistrationLoader = false;

  bool get loadingRegistration => GlobalRegistrationLoader;

  setRegistrationLoading(bool value) {
    if (GlobalRegistrationLoader != value) {
      GlobalRegistrationLoader = value;
      notifyListeners();
    }
  }

  Future<void> UserRegistrationService({required BuildContext context}) async {
    final HttpService httpService = HttpService();
    final uri = Uri.parse(RegisterService);
    // Prepare request body
    final body = {
      'name': NameController.text.toString(),
      'email': EmailController.text.toString().trim(),
      'phone': MobileController.text.toString().trim(),
      'username': UserRegisterNameController.text.toString().trim(),
      'password': UserRegisterPasswordController.text.toString().trim(),
    };
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    try {
      setRegistrationLoading(true);
      File? GetImageFile = ProfileImageFile;
      if (GetImageFile != null) {
        // Compress the image
        File? compressedImage = await compressImage(GetImageFile);
        if (compressedImage != null) {
          // If the compressed image is under 2MB, add it to the request
          final response = await httpService.UploadImage(
            context,
            uri,
            headers,
            body,
            GetImageFile,
            'profile_pic',
            const Duration(seconds: 15),
            'POST',
          );
          if (response.statusCode == 200) {
            final responseBody = jsonDecode(response.body);
            if (responseBody['status'] == true) {
              GlobalFunction().PopupFailedAlert(
                context,
                "Success",
                "Delivery Partner registered successfully",
                responseBody["message"],
              );
              ProfileImageFile = null;
              NameController.clear();
              MobileController.clear();
              EmailController.clear();
              UserRegisterNameController.clear();
              UserRegisterPasswordController.clear();
              toggle = ValueNotifier<bool>(true);
              alertMessage = '';
            } else {
              // Create an alert message based on the response keys
              if (responseBody.containsKey('mobile') &&
                  responseBody.containsKey('email')) {
                alertMessage =
                    '${responseBody['email']}\n${responseBody['mobile']}';
              } else if (responseBody.containsKey('mobile')) {
                alertMessage = responseBody['mobile'];
              } else if (responseBody.containsKey('email')) {
                alertMessage = responseBody['email'];
              } else if (responseBody.containsKey('image')) {
                alertMessage = responseBody['image'];
              } else if (responseBody.containsKey('username')) {
                alertMessage = responseBody['username'];
              } else if (responseBody.containsKey('message')) {
                alertMessage = responseBody['message'];
              }
              if (alertMessage.isNotEmpty) {
                GlobalFunction().PopupFailedAlert(
                  context,
                  "Failed",
                  "",
                  alertMessage,
                );
              }
            }
          } else {
            // Handle non-200 status codes
            alertMessage = 'Error: ${response.statusCode}';
            GlobalFunction().PopupFailedAlert(
              context,
              "Failed",
              "",
              alertMessage,
            );
          }
          setRegistrationLoading(false);
          notifyListeners();
        } else {
          return;
        }
      } else {
        setRegistrationLoading(false);
        UserWithoutImageService(context);
      }
    } catch (e) {
      setRegistrationLoading(false);
      notifyListeners();
      if (kDebugMode) {
        print('============Error: $e');
      }
      rethrow;
    }
  }

  Future<void> UserWithoutImageService(BuildContext context) async {
    final HttpService httpService = HttpService();
    final uri = Uri.parse(RegisterService);
    // Prepare request body
    final body = {
      'name': NameController.text.toString(),
      'email': EmailController.text.toString().trim(),
      'phone': MobileController.text.toString().trim(),
      'username': UserRegisterNameController.text.toString().trim(),
      'password': UserRegisterPasswordController.text.toString().trim(),
    };
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    try {
      setRegistrationLoading(true);
      final response = await httpService.Request(
        method: 'POST',
        url: uri.toString(),
        body: body,
        headers: headers,
        context: context,
      );
      if (response != null && response["status"] == true) {
        GlobalFunction().PopupFailedAlert(
          context,
          "Success",
          "Delivery Partner registered successfully",
          response["message"],
        );
        ProfileImageFile = null;
        NameController.clear();
        MobileController.clear();
        EmailController.clear();
        UserRegisterNameController.clear();
        UserRegisterPasswordController.clear();
        toggle = ValueNotifier<bool>(true);
        alertMessage = '';
      } else {
        // Create an alert message based on the response keys
        if (response.containsKey('mobile') && response.containsKey('email')) {
          alertMessage = '${response['email']}\n${response['mobile']}';
        } else if (response.containsKey('mobile')) {
          alertMessage = response['mobile'];
        } else if (response.containsKey('email')) {
          alertMessage = response['email'];
        } else if (response.containsKey('image')) {
          alertMessage = response['image'];
        } else if (response.containsKey('username')) {
          alertMessage = response['username'];
        } else if (response.containsKey('message')) {
          alertMessage = response['message'];
        }
        if (alertMessage.isNotEmpty) {
          GlobalFunction().PopupFailedAlert(
            context,
            "Failed",
            "",
            alertMessage,
          );
        }
      }
      setRegistrationLoading(false);
      notifyListeners();
    } catch (e) {
      setRegistrationLoading(false);
      notifyListeners();
      if (kDebugMode) {
        print('============Error: $e');
      }
      rethrow;
    }
  }

  //✅------------------------------------------------------------------------✅//
  Future<File?> compressImage(File imageFile) async {
    final filePath = imageFile.path;

    // Compress the image to reduce its size
    final result = await FlutterImageCompress.compressWithFile(
      filePath,
      minWidth: 800, // Min width for the compressed image
      minHeight: 800, // Min height for the compressed image
      quality: 80, // You can adjust quality as per your needs
      rotate: 0, // No rotation needed
    );

    if (result != null) {
      // Create a new file from the compressed data
      final compressedImageFile = File(filePath)..writeAsBytesSync(result);

      // Check the size of the compressed image
      if (compressedImageFile.lengthSync() <= 2 * 1024 * 1024) {
        // 2MB
        return compressedImageFile; // Image is under 2MB, return the compressed image
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
