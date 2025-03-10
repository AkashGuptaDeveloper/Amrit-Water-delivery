// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, unnecessary_null_comparison, avoid_function_literals_in_foreach_calls
import 'package:amritwaterdelivery/GlobalComponents/HTTPRepository/Packages.dart';
import 'package:amritwaterdelivery/Screens/OrderHistory/OrderHistoryModel/OrderHistoryModel.dart';

//--🟢OrderHistoryProvider-------🟢-------------------------------------------//
class OrderHistoryProvider with ChangeNotifier {
  bool isLoading = false;
  List<OrderHistory> OrderHistoryListing = [];
  //----🟢️OrderHistoryAPIDATA --------🟢------------------------------------------//
  Future<void> OrderHistoryScreenAPIDATA(BuildContext context) async {
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
    OrderHistoryListing = [];
  }

  //-----ProductList----------------------------//
  Future<OrderHistoryData> getHomeDataDetails(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final HttpService httpService = HttpService();
    final uri = Uri.parse(GetOrderService);
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
        OrderHistoryListing = [];
        for (var element in response["orderHistory"]) {
          OrderHistory model = OrderHistory.fromJson(element);
          OrderHistoryListing.add(model);
        }
      } else {
        ClearProductData();
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      ClearProductData();
      rethrow;
    }
    return OrderHistoryData(OrderHistoryDetails: OrderHistoryListing);
  }

  void ClearProductData() {
    OrderHistoryListing = [];
    isLoading = false;
    notifyListeners();
  }
}

//✅------------------------------------------------------------------------✅//
class OrderHistoryData {
  final List<OrderHistory> OrderHistoryDetails;

  OrderHistoryData({required this.OrderHistoryDetails});
}
