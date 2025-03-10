// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, unnecessary_null_comparison, avoid_function_literals_in_foreach_call
import 'package:amritwaterdelivery/GlobalComponents/HTTPRepository/Packages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//----------------------------------------------------------------------------//

class GlobalDecorations {
  //----------------CommanTextStyle---------------------------------------------//
  static TextStyle CommanTextStyle(
    BuildContext context, {
    String? fontFamily,
    Color? color,
    FontWeight fontWeight = FontWeight.w400,
    double fontSize = 16.0,
    double letterSpacing = 0.5,
    FontStyle fontStyle = FontStyle.normal,
    double? height,
  }) {
    return TextStyle(
      fontFamily: fontFamily ?? GlobalFlag.GoogleFonts,
      // Default font family
      fontStyle: fontStyle,
      color: color ?? GlobalAppColor.BlackTextCode,
      // Default color
      fontWeight: fontWeight,
      fontSize:
          ResponsiveValue(
            context,
            defaultValue: fontSize,
            conditionalValues: [
              Condition.smallerThan(name: TABLET, value: fontSize),
            ],
          ).value,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  //--------------------------ButtonLoadingCupertinoActivityIndicator-----------//
  static Widget ButtonLoadingCupertinoActivityIndicator(
    LoaderKey,
    double value,
  ) {
    return CupertinoActivityIndicator(
      animating: true,
      radius: value,
      color: Colors.white,
      key: LoaderKey,
    );
  }

  //------------------ globalCupertinoTextField--------------------------------//
  // Common CupertinoTextField properties function
  static SizedBox globalCupertinoTextField({
    required BuildContext context,
    required TextEditingController controller,
    required FocusNode focusNode,
    required TextInputType keyboardType,
    TextInputAction textInputAction = TextInputAction.done,
    int? maxLines = 1,
    int? minLines = 1,
    int? maxLength,
    bool enabled = true,
    EdgeInsets padding = const EdgeInsets.all(10),
    List<TextInputFormatter>? inputFormatters,
    BoxDecoration? decoration,
    String placeholder = '',
    bool obscureText = false,
    Widget? suffix,
    String? prefixTextValue,
    TextStyle? style,
    TextStyle? placeholderStyle,
    bool showSuffixIcon = false,
    Function()? onTapSuffix, // Add onTapSuffix parameter
    Function(String)? onChanged, // Added onChanged parameter
    IconData? suffixIcon,
    double height = 50,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: height,
      child: GlobalDecorations().FadeInUpWidget(
        duration: duration,
        child: CupertinoTextField(
          padding: padding,
          controller: controller,
          focusNode: focusNode,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLength,
          minLines: minLines,
          enabled: enabled,
          inputFormatters: inputFormatters,
          clearButtonMode: OverlayVisibilityMode.editing,
          showCursor: true,
          textCapitalization: TextCapitalization.words,
          textAlign: TextAlign.start,
          autocorrect: true,
          textAlignVertical: TextAlignVertical.center,
          cursorColor: GlobalAppColor.NewBlackTextCode,
          style: CommanTextStyle(
            context,
            fontWeight: FontWeight.w400,
            fontSize: 16.0,
            color: GlobalAppColor.BlackTextCode,
            letterSpacing: 1,
          ),
          placeholderStyle: CommanTextStyle(
            context,
            fontWeight: FontWeight.w400,
            fontSize: 16.0,
            color: GlobalAppColor.NewBlackTextCode,
            letterSpacing: 1,
          ),
          placeholder: placeholder,
          obscureText: obscureText,
          onChanged: onChanged,
          // Set the onChanged callback
          suffix: Padding(
            padding: EdgeInsets.only(right: 8.0),
            child:
                showSuffixIcon
                    ? GestureDetector(
                      onTap: onTapSuffix,
                      child: Icon(
                        suffixIcon,
                        color: GlobalAppColor.NewBlackTextCode,
                        size:
                            ResponsiveValue(
                              context,
                              defaultValue:
                                  24.0, // Default size for larger screens (desktop)
                              conditionalValues: [
                                Condition.smallerThan(
                                  name: TABLET,
                                  value: 24.0,
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
                      ),
                    )
                    : suffix,
          ),
          prefix:
              prefixTextValue != null
                  ? Text(
                    prefixTextValue,
                    style: CommanTextStyle(
                      context,
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                      color: GlobalAppColor.NewBlackTextCode,
                      letterSpacing: 1,
                    ),
                  )
                  : null,
          contextMenuBuilder: (context, editableTextState) {
            // Empty context menu to disable copy/paste options
            return Container();
          },
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: GlobalAppColor.NewBlackTextCode, // Border color
              width: 1.5, // Border width
            ),
            borderRadius: BorderRadius.circular(8.0), // Border radius
          ),
        ),
      ),
    );
  }

  //-------------fadeInUpWidget-------------------------------------------------//
  Widget FadeInUpWidget({required Duration duration, required Widget child}) {
    return FadeInUp(duration: duration, child: child);
  }

  //-----------------hideKeyboard-----------------------------------------------//
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    FocusScope.of(context).unfocus();
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  //-----------------CommanButton-----------------------------------------------//
  Widget globalCupertinoButton({
    required VoidCallback? onPressed, // The onPressed function for the button
    required bool isLoading, // Flag to show loading indicator
    required String buttonText, // Button text
    Key? loaderKey, // Key for loader
    double fontSize = 16.5,
    double borderRadius = 8.0,
    Color? buttonColor,
    Color? textColor = Colors.white,
    EdgeInsets padding = const EdgeInsets.all(5), // Default padding
    FontWeight GlobalFontWeight = FontWeight.w400,
    required BuildContext context,
    double btnHeight = 50,
  }) {
    return SizedBox(
      width: double.infinity,
      height: btnHeight,
      child: CupertinoButton(
        disabledColor: buttonColor ?? GlobalAppColor.ButtonColor,
        color: buttonColor ?? GlobalAppColor.ButtonColor,
        borderRadius: BorderRadius.circular(borderRadius),
        padding: padding,
        alignment: Alignment.center,
        onPressed: onPressed,
        child:
            isLoading
                ? ButtonLoadingCupertinoActivityIndicator(loaderKey, 12)
                : Text(
                  buttonText,
                  textAlign: TextAlign.center,
                  style: GlobalDecorations.CommanTextStyle(
                    context,
                    fontWeight: GlobalFontWeight,
                    fontSize: fontSize,
                    color: textColor,
                    letterSpacing: 1,
                  ),
                ),
      ).animate().scale(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      ),
    );
  }

  //-----------------CommanButton-----------------------------------------------//
  static Widget CustomButton({
    required VoidCallback? onPressed, // The onPressed function for the button
    required String buttonText, // Button text
    double fontSize = 16.5,
    double borderRadius = 8.0,
    Color? buttonColor,
    Color? textColor,
    EdgeInsets padding = const EdgeInsets.all(5), // Default padding
    FontWeight GlobalFontWeight = FontWeight.w400,
    required BuildContext context,
    double btnHeight = 50,
  }) {
    return SizedBox(
      width: double.infinity,
      height: btnHeight,
      child: CupertinoButton(
        disabledColor: buttonColor ?? GlobalAppColor.CloseBtnCode,
        color: buttonColor ?? GlobalAppColor.CloseBtnCode,
        borderRadius: BorderRadius.circular(borderRadius),
        padding: padding,
        alignment: Alignment.center,
        onPressed: onPressed,
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: GlobalDecorations.CommanTextStyle(
            context,
            fontWeight: GlobalFontWeight,
            fontSize: fontSize,
            color: textColor,
            letterSpacing: 1,
          ),
        ),
      ).animate().scale(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      ),
    );
  }

  //-----------------NumberInputFormatters--------------------------------------//
  static List<TextInputFormatter> get NumberInputFormatters {
    return [
      FilteringTextInputFormatter.deny(RegExp(r'\s')),
      // Deny whitespace
      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
      // Allow only alphanumeric characters
    ];
  }

  //-----------------EmailInputFormatters---------------------------------------//
  static List<TextInputFormatter> get EmailInputFormatters {
    return [FilteringTextInputFormatter.deny(RegExp(r'\s'))];
  }

  //-----------------checkInternetConnection------------------------------------//
  // Internet checking utility
  Future<bool> checkInternetConnection(BuildContext context) async {
    hideKeyboard(context);
    FocusScope.of(context).requestFocus(FocusNode());
    FocusScope.of(context).unfocus();
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      GlobalFunction().PopupFailedAlert(
        context,
        "InternetNotConnected",
        "",
        GlobalFlag.InternetNotConnected,
      );
      return false;
    }
    return true;
  }

  //-----------------IconResponsiveValue----------------------------------------//
  static double IconResponsiveValue({
    required BuildContext context,
    double defaultValue = 24.0, // Default set to 24
    double mobileValue = 18.0, // Mobile size
    double tabletValue = 22.0, // Tablet size
    double desktopValue = 40.0, // Desktop size
  }) {
    return ResponsiveValue<double>(
      context,
      defaultValue: defaultValue, // Default for large screens
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: mobileValue), // Mobile size
        Condition.smallerThan(name: TABLET, value: tabletValue), // Tablet size
        Condition.largerThan(
          name: DESKTOP,
          value: desktopValue,
        ), // Desktop size
      ],
    ).value;
  }

  //-----------------_buildLoadingState-----------------------------------------//
  // Method to build loading state
  Widget buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CupertinoActivityIndicator(
            animating: true,
            radius: GlobalDecorations.IconResponsiveValue(
              context: context,
              mobileValue: 18.0, // Mobile size
              tabletValue: 30.0, // Tablet size
              desktopValue: 40.0, // Desktop size
            ),
            color: GlobalAppColor.ButtonColor,
          ),
          Text(
            GlobalFlag.PleaseWait,
            textAlign: TextAlign.center,
            style: GlobalDecorations.CommanTextStyle(
              context,
              fontWeight: FontWeight.w400,
              fontSize: 18,
              letterSpacing: 1,
              color: GlobalAppColor.ButtonColor,
            ),
          ),
        ],
      ),
    );
  }

  //-----------------buildNoInternetState---------------------------------------//
  // Method to build loading state
  Widget buildNoInternetState(BuildContext context) {
    return Center(
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Animate(
            effects: const [FadeEffect(), ScaleEffect()],
            child: Icon(
                  FontAwesomeIcons.wifi,
                  size: GlobalDecorations.IconResponsiveValue(
                    context: context,
                    mobileValue: 18.0, // Mobile size
                    tabletValue: 30.0, // Tablet size
                    desktopValue: 40.0, // Desktop size
                  ),
                  color: Colors.red,
                )
                .animate()
                .fade(duration: const Duration(milliseconds: 700))
                .scale(delay: const Duration(milliseconds: 700)),
          ),
          Text(
            GlobalFlag.NotConnected,
            textAlign: TextAlign.center,
            style: GlobalDecorations.CommanTextStyle(
              context,
              fontWeight: FontWeight.w400,
              fontSize: 18,
              color: GlobalAppColor.ButtonColor,
            ),
          ),
        ],
      ),
    );
  }

  //-----------------buildNoInternetState---------------------------------------//
  // Method to build loading state
  Widget buildNoDataState(BuildContext context, String Msg) {
    return Center(
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Animate(
            effects: const [FadeEffect(), ScaleEffect()],
            child: Icon(
                  FontAwesomeIcons.triangleExclamation,
                  size: GlobalDecorations.IconResponsiveValue(
                    context: context,
                    mobileValue: 18.0, // Mobile size
                    tabletValue: 50.0, // Tablet size
                    desktopValue: 40.0, // Desktop size
                  ),
                  color: GlobalAppColor.ButtonColor,
                )
                .animate()
                .fade(duration: const Duration(milliseconds: 700))
                .scale(delay: const Duration(milliseconds: 700)),
          ),
          Text(
            Msg,
            textAlign: TextAlign.center,
            style: GlobalDecorations.CommanTextStyle(
              context,
              fontWeight: FontWeight.w400,
              fontSize: 18,
              color: GlobalAppColor.ButtonColor,
            ),
          ),
        ],
      ),
    );
  }
}
