// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, unnecessary_null_comparison, avoid_function_literals_in_foreach_call
class GlobalServiceURL {
  //----------------------------Authorization-URL-------------------------------//
  //static String BaseURL = "https://backendapi-mobile.ibaptech.sbs/api/v2/mobile/";

  //static String BaseURL = "https://water.bookmydraws.com/api/";
  static String BaseURL = "https://admin.amritmineralwater.in/api/";
  static String ImageBaseURL = "https://water.bookmydraws.com/";
  static String ProductNoImgURL =
      "https://tinasbotanicals.com/wp-content/uploads/2025/01/No-Product-Image-Available.png";
  static String ProfileImagesUrl =
      "https://www.pngplay.com/wp-content/uploads/12/User-Avatar-Profile-PNG-Photos.png";

  //----------------------------Before-Login-Registration-API-------------------//
  static String LoginUrl = "${BaseURL}delivery-partner/login";
  static String RegisterUrl = "${BaseURL}delivery-partner/register";
  static String OrderListUrl = "${BaseURL}delivery-partner/orders";
  static String UpdateOrderStatusUrl =
      "${BaseURL}delivery-partner/update-order-status";
  static String GetOrderUrl = "${BaseURL}delivery-partner/get-order-history";
  static String ResetPasswordUrl =
      "${BaseURL}delivery-partner/update-password/";
}

//======================================END===================================//
