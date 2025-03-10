// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, unnecessary_null_comparison, avoid_function_literals_in_foreach_calls
import 'package:amritwaterdelivery/GlobalComponents/HTTPRepository/Packages.dart';

//--🟢HomeProvider-------🟢---------------------------------------------------//
class HomeProvider with ChangeNotifier {
  bool isLoading = false;
  List<Orders> HomeListing = [];
  List<String>? dropdownValues;
  List<String> dropdownItems = [];
  String SelectedItems = "";

  //----🟢️HomeScreenAPIDATA --------🟢------------------------------------------//
  Future<void> HomeScreenAPIDATA(BuildContext context) async {
    ClearData();
    var result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      await getHomeDataDetails(context);
    } else {
      /*if (kDebugMode) {
        print("============Internet is Not Active an HomeScree");
      }*/
      ClearData();
      notifyListeners();
    }
  }

  ClearData() async {
    isLoading = false;
    HomeListing = [];
  }

  //-----ProductList----------------------------//
  Future<DeliveryOrdersData> getHomeDataDetails(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final HttpService httpService = HttpService();
    final uri = Uri.parse(OrderListService);
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${prefs.getString("UserLoginToken")}',
    };
    try {
      isLoading = true;
      final response = await httpService.Request(
        method: 'GET',
        url: uri.toString(),
        headers: headers,
        context: context,
      );
      if (response != null && response["status"] == true) {
        HomeListing = [];
        for (var element in response["orders"]) {
          Orders model = Orders.fromJson(element);
          HomeListing.add(model);
        }
        dropdownValues = List.generate(
          HomeListing.length, // Generate based on the length of HomeListing
          (index) =>
              'Select Type', // Set 'Select Type' as default for each item
        );
      } else {
        ClearProductData();
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      ClearProductData();
      rethrow;
    }
    return DeliveryOrdersData(DeliveryOrderDetails: HomeListing);
  }

  void ClearProductData() {
    HomeListing = [];
    isLoading = false;
    notifyListeners();
  }

  void ChangedDropDownStatus(String newValue, int index) async {
    dropdownValues![index] = newValue; // Update value at specific index
    SelectedItems = newValue;
    /*if (kDebugMode) {
      print("============Selected status for item $index: ${dropdownValues![index]}");
    }*/
    notifyListeners(); // Notify listeners to update UI
  }

  //✅------------------------------------------------------------------------✅//
  bool GlobalOrderStatusLoader = false;

  bool get loadingOrderStatus => GlobalOrderStatusLoader;

  setOrderStatusLoading(bool value) {
    if (GlobalOrderStatusLoader != value) {
      GlobalOrderStatusLoader = value;
      notifyListeners();
    }
  }

  Future<void> UserUpdateOrderStatusService({
    required BuildContext context,
    required String OrderID,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final HttpService httpService = HttpService();
    final uri = Uri.parse(UpdateOrderStatusService);
    // Prepare request body
    final body = {
      'order_id': OrderID.toString(),
      'status': SelectedItems.toString(),
    };
    var headers = {
      'Content-Type': 'application/json',
      'accept': 'application/json',
      'Authorization': 'Bearer ${prefs.getString("UserLoginToken")}',
    };
    try {
      setOrderStatusLoading(true);
      final response = await httpService.Request(
        method: 'POST',
        url: uri.toString(),
        body: body,
        headers: headers,
        context: context,
      );
      if (response != null && response["status"] == true) {
        getHomeDataDetails(context);
        dropdownValues = List.generate(
          HomeListing.length, // Generate based on the length of HomeListing
          (index) =>
              'Select Type', // Set 'Select Type' as default for each item
        );
        SelectedItems = "";
        GlobalFunction().PopupFailedAlert(
          context,
          "Success",
          "",
          response["message"].toString(),
        );
      } else {
        GlobalFunction().PopupFailedAlert(
          context,
          "Failed",
          "",
          response["message"].toString(),
        );
      }
      setOrderStatusLoading(false);
      notifyListeners();
    } catch (e) {
      dropdownValues = List.generate(
        HomeListing.length, // Generate based on the length of HomeListing
        (index) => 'Select Type', // Set 'Select Type' as default for each item
      );
      SelectedItems = "";
      setOrderStatusLoading(false);
      notifyListeners();
      if (kDebugMode) {
        print('============Error: $e');
      }
      rethrow;
    }
  }
}

//✅------------------------------------------------------------------------✅//
class DeliveryOrdersData {
  final List<Orders> DeliveryOrderDetails;

  DeliveryOrdersData({required this.DeliveryOrderDetails});
}
