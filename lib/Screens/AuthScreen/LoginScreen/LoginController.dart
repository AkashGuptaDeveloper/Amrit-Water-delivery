// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, unnecessary_null_comparison, avoid_function_literals_in_foreach_calls
import 'package:amritwaterdelivery/GlobalComponents/HTTPRepository/Packages.dart';

//--🟢LoginProvider-------🟢----------------------------------------//
class LoginProvider with ChangeNotifier {
  final TextEditingController UserNameController = TextEditingController();
  final FocusNode myFocusUserName = FocusNode();
  final TextEditingController UserPasswordController = TextEditingController();
  final FocusNode myFocusPassword = FocusNode();
  ValueNotifier<bool> toggle = ValueNotifier<bool>(true);

  void SeePassword() async {
    toggle.value = !toggle.value;
    notifyListeners();
  }

  //-----Authentication-Login---------------------------------------------------//
  bool GlobalAuthenticationLoader = false;

  bool get loadingAuthentication => GlobalAuthenticationLoader;

  setAuthenticationLoading(bool value) {
    if (GlobalAuthenticationLoader != value) {
      GlobalAuthenticationLoader = value;
      notifyListeners();
    }
  }

  Future<void> UserLoginService({required BuildContext context}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final HttpService httpService = HttpService();
    final uri = Uri.parse(LoginService);
    // Prepare request body
    final body = {
      'username': UserNameController.text.toString(),
      'password': UserPasswordController.text.toString().trim(),
    };
    final headers = {'Content-Type': 'application/json'};
    try {
      setAuthenticationLoading(true);
      final response = await httpService.Request(
        method: 'POST',
        url: uri.toString(),
        body: body,
        headers: headers,
        context: context,
      );
      if (response != null && response["status"] == true) {
        // Extract user data from response
        String userImage =
            (response["deliveryPartner"]['profile_pic_url'] == null ||
                    response["deliveryPartner"]['profile_pic_url']!.isEmpty)
                ? GlobalServiceURL.ProfileImagesUrl.toString()
                : response["deliveryPartner"]['profile_pic_url'];
        // Save all user data in SharedPreferences
        await prefs.setInt("UserLoginID", response["deliveryPartner"]['id']);
        await prefs.setString(
          "UserLoginRole",
          response["deliveryPartner"]['role'].toString(),
        );
        await prefs.setString(
          "UserLoginName",
          response["deliveryPartner"]['name'].toString(),
        );
        await prefs.setString(
          "UserLoginUserName",
          response["deliveryPartner"]['username'].toString(),
        );
        await prefs.setString(
          "UserLoginEmail",
          response["deliveryPartner"]['email'].toString(),
        );
        await prefs.setString(
          "UserLoginEmailVerified",
          response["deliveryPartner"]['email_verified_at'].toString(),
        );
        await prefs.setString(
          "UserLoginMobile",
          response["deliveryPartner"]['phone'].toString(),
        );
        await prefs.setString(
          "UserLoginTime",
          response["deliveryPartner"]['login_time'].toString(),
        );
        await prefs.setString(
          "UserLoginStatus",
          response["deliveryPartner"]['status'].toString(),
        );
        await prefs.setString(
          "UserLoginCreatedAt",
          response["deliveryPartner"]['created_at'].toString(),
        );
        await prefs.setString(
          "UserLoginUpdatedAt",
          response["deliveryPartner"]['updated_at'].toString(),
        );
        await prefs.setString("UserLoginToken", response['token'].toString());
        await prefs.setString("UserLoginProfileImg", userImage.toString());

        toggle = ValueNotifier<bool>(true);
        UserNameController.clear();
        UserPasswordController.clear();
        // Notify listeners to update UI
        notifyListeners();
        GlobalFunction().navigateToScreen(context, const HomeScreen());
        // Debug log
        /*if (kDebugMode) {
          print("============");
          print("UserLoginID: ${prefs.getInt("UserLoginID").toString()}");
          print(
            "UserLoginRole: ${prefs.getString("UserLoginRole").toString()}",
          );
          print(
            "UserLoginName: ${prefs.getString("UserLoginName").toString()}",
          );
          print(
            "UserLoginEmail:${prefs.getString("UserLoginEmail").toString()}",
          );
          print(
            "UserLoginUserName:${prefs.getString("UserLoginUserName").toString()}",
          );
          print(
            "UserLoginMobile:${prefs.getString("UserLoginMobile").toString()}",
          );
          print(
            "UserLoginProfileImg: ${prefs.getString("UserLoginProfileImg").toString()}",
          );
          print(
            "UserLoginToken: ${prefs.getString("UserLoginToken").toString()}",
          );
        }*/
      } else {
        // Handle errors
        String errorMessage = "";
        if (response.containsKey("message")) {
          errorMessage = response["message"]; // "User not found."
        } else if (response.containsKey("password")) {
          errorMessage =
              response["password"]; // "The password must be at least 6 characters."
        }

        GlobalFunction().PopupFailedAlert(
          context,
          "Failed",
          "",
          errorMessage.toString(),
        );
      }
      setAuthenticationLoading(false);
      notifyListeners();
    } catch (e) {
      setAuthenticationLoading(false);
      notifyListeners();
      if (kDebugMode) {
        print('============Error: $e');
      }
      rethrow;
    }
  }

  //✅------------------------------------------------------------------------✅//
  // Remove user data from SharedPreferences (Logout)
  Future<void> removeUserData(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final GetRegisterData = Provider.of<RegisterProvider>(
      context,
      listen: false,
    );
    final GetLoginData = Provider.of<LoginProvider>(context, listen: false);
    await prefs.clear(); // Clears all saved data
    //------Register
    GetRegisterData.ProfileImageFile = null;
    GetRegisterData.NameController.clear();
    GetRegisterData.MobileController.clear();
    GetRegisterData.EmailController.clear();
    GetRegisterData.UserRegisterNameController.clear();
    GetRegisterData.UserRegisterPasswordController.clear();
    GetRegisterData.toggle = ValueNotifier<bool>(true);
    GetRegisterData.GlobalRegistrationLoader = false;
    GetRegisterData.setRegistrationLoading(false);
    GetRegisterData.alertMessage = '';
    //------Login
    GetLoginData.toggle = ValueNotifier<bool>(true);
    GetLoginData.UserNameController.clear();
    GetLoginData.UserPasswordController.clear();
    GetLoginData.GlobalAuthenticationLoader = false;
    GetLoginData.setAuthenticationLoading(false);
    notifyListeners();
    GlobalFunction().navigateToScreen(context, const SplashScreen());
  }
}
