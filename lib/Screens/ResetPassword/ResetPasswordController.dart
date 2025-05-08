// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, unnecessary_null_comparison, avoid_function_literals_in_foreach_calls
import 'package:amritwaterdelivery/GlobalComponents/HTTPRepository/Packages.dart';

//--🟢ResetPasswordProvider-------🟢------------------------------------------//
class ResetPasswordProvider with ChangeNotifier {
  final TextEditingController NewPwdController = TextEditingController();
  final FocusNode myFocusNewPwd = FocusNode();

  final TextEditingController ConfirmPwdController = TextEditingController();
  final FocusNode myFocusConfirmPwd = FocusNode();

  //-----Authentication-Login-------------------------------------------------//
  bool GlobalResetPasswordLoader = false;

  bool get loadingResetPassword => GlobalResetPasswordLoader;

  setResetPasswordLoading(bool value) {
    if (GlobalResetPasswordLoader != value) {
      GlobalResetPasswordLoader = value;
      notifyListeners();
    }
  }

  //✅------------------------------------------------------------------------✅//
  void validateAndSubmit(BuildContext context) async {
    if (NewPwdController.text.isEmpty) {
      GlobalFunction().PopupFailedAlert(
        context,
        "Failed",
        "",
        "Enter New Password",
      );
      return;
    }

    if (ConfirmPwdController.text.isEmpty) {
      GlobalFunction().PopupFailedAlert(
        context,
        "Failed",
        "",
        "Enter Confirm Password",
      );
      return;
    }

    if (NewPwdController.text != ConfirmPwdController.text) {
      GlobalFunction().PopupFailedAlert(
        context,
        "Failed",
        "",
        "New Password and Confirm Password do not match",
      );
      return;
    } else {
      await UserResetPasswordService(context: context);
    }
  }

  //✅------------------------------------------------------------------------✅//
  Future<void> UserResetPasswordService({required BuildContext context}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final HttpService httpService = HttpService();
    final uri = Uri.parse(
      "$ResetPasswordService${prefs.getInt("UserLoginID")}",
    );
    // Prepare request body
    final body = {
      'password': NewPwdController.text.toString().trim(),
      'password_confirmation': ConfirmPwdController.text.toString().trim(),
    };
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${prefs.getString("UserLoginToken")}',
    };
    try {
      setResetPasswordLoading(true);
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
          "Password updated successfully",
          response['message'].toString(),
        );
      } else {
        GlobalFunction().PopupFailedAlert(
          context,
          "Failed",
          "",
          response['message'].toString(),
        );
      }
      setResetPasswordLoading(false);
      notifyListeners();
    } catch (e) {
      setResetPasswordLoading(false);
      notifyListeners();
      if (kDebugMode) {
        print('============Error: $e');
      }
      rethrow;
    }
  }

  //--🔹--clearFields----------------------------------------------------🔹--//
  void clearFields(context) {
    NewPwdController.clear();
    ConfirmPwdController.clear();
    myFocusNewPwd.unfocus();
    myFocusConfirmPwd.unfocus();
    GlobalResetPasswordLoader = false;
    notifyListeners();
  }
}

//✅------------------------------------------------------------------------✅//
