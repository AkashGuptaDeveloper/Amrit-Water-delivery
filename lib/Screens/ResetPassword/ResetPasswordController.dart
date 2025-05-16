// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, unnecessary_null_comparison, avoid_function_literals_in_foreach_calls
import 'package:amritwaterdelivery/GlobalComponents/HTTPRepository/Packages.dart';
import 'package:http/http.dart' as http;

//--🟢ResetPasswordProvider-------🟢------------------------------------------//
class ResetPasswordProvider with ChangeNotifier {
  final TextEditingController UserNameController = TextEditingController();
  final FocusNode myFocusUserName = FocusNode();

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
    if (UserNameController.text.isEmpty) {
      GlobalFunction().PopupFailedAlert(
        context,
        "Failed",
        "",
        "Enter New UserName",
      );
      return;
    }
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

  //✅--------------------------------------------------------------------✅//
  Future<void> UserResetPasswordService({required BuildContext context}) async {
    try {
      setResetPasswordLoading(true);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(GlobalServiceURL.ResetPasswordUrl),
      );

      request.fields.addAll({
        'username': UserNameController.text.toString().trim(),
        'password': NewPwdController.text.toString().trim(),
        'password_confirmation': ConfirmPwdController.text.toString().trim(),
      });

      http.StreamedResponse streamedResponse = await request.send();
      final String responseBody = await streamedResponse.stream.bytesToString();

      if (kDebugMode) {
        print("Raw response: $responseBody");
      }

      final decodedResponse = jsonDecode(responseBody);

      if (streamedResponse.statusCode == 200 &&
          decodedResponse["status"] == true) {
        GlobalFunction().PopupFailedAlert(
          context,
          "Success",
          "Password updated successfully",
          decodedResponse['message']?.toString() ?? '',
        );
      } else {
        String errorMessage =
            decodedResponse['message']?.toString() ??
            decodedResponse.values.first.toString(); // fallback

        GlobalFunction().PopupFailedAlert(context, "Failed", "", errorMessage);
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
    UserNameController.clear();
    myFocusUserName.unfocus();
    NewPwdController.clear();
    ConfirmPwdController.clear();
    myFocusNewPwd.unfocus();
    myFocusConfirmPwd.unfocus();
    GlobalResetPasswordLoader = false;
    notifyListeners();
  }
}

//✅------------------------------------------------------------------------✅//
