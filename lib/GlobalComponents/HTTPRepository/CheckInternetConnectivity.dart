// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, unnecessary_null_comparison, avoid_function_literals_in_foreach_call

import 'package:amritwaterdelivery/GlobalComponents/HTTPRepository/Packages.dart';
import 'package:amritwaterdelivery/Screens/OrderHistory/OrderHistoryController.dart';

//-🟢InternetProvider--------------🟢-----------------------------------------//

class CheckInternet with ChangeNotifier {
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool InternetStatus = false;
  var InternetTextValue = GlobalFlag.InActive;

  CheckInternet(BuildContext context) {
    getConnectivity(context);
    InternetTextValue;
    notifyListeners();
  }

  void getConnectivity(context) {
    subscription = Connectivity().onConnectivityChanged.listen((
      ConnectivityResult result,
    ) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected && InternetStatus == false) {
        //--InterNetOff-----
        InternetStatus = true;
        InternetTextValue = GlobalFlag.InActive;
        notifyListeners();
        if (kDebugMode) {
          print("============InterNet is not Active");
        }
      } else {
        //--InterNetOn-----
        InternetStatus = false;
        InternetTextValue = GlobalFlag.Active;
        notifyListeners();
        if (kDebugMode) {
          print("============InterNet is Active");
        }
      }
      notifyListeners();
    });
  }

  //---------------------------resetState---------------------------------------//
  void resetState() {
    InternetTextValue = GlobalFlag.InActive;
    notifyListeners();
  }
}

class GlobalCheckInternetConnectivity {
  // StreamSubscription to track the connectivity listener
  static StreamSubscription<ConnectivityResult>? connectivitySubscription;

  // Connectivity initialize method
  static void initializeConnectivity(
    BuildContext context,
    String apiCallFunctionScreenWise,
  ) {
    // subscription is active
    if (connectivitySubscription != null) {
      if (kDebugMode) {
        print("Connectivity listener is active hai.");
      }
      return; // already active initialize
    }

    // Listener start karna
    checkInternetConnectivity(context, apiCallFunctionScreenWise);
    if (kDebugMode) {
      print("Connectivity listener initialized.");
    }
  }

  static void checkInternetConnectivity(
    BuildContext context,
    String apiCallFunctionScreenWise,
  ) async {
    // Initial API call for the screen when the app starts
    GetScreenWiseApi(context, apiCallFunctionScreenWise);
    // Listen for connectivity changes in the background
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      ConnectivityResult result,
    ) async {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        // If connected to the internet, call the API again
        //----------------HomeScreenApi-----------------------------------------------//
        GetScreenWiseApi(context, apiCallFunctionScreenWise);
      } else {
        // If not connected to the internet, clear the data or show offline message
        //----------------HomeScreenApi-----------------------------------------------//
        GetScreenWiseApi(context, apiCallFunctionScreenWise);
      }
    });
  }

  // Function to dispose the connectivity listener
  static void disposeConnectivityListener() {
    if (connectivitySubscription != null) {
      connectivitySubscription!.cancel();
      connectivitySubscription = null; // Reset karna
      if (kDebugMode) {
        print("============Connectivity listener disposed.");
      }
    }
  }

  // isSubscriptionActive method
  static bool isSubscriptionActive() {
    return connectivitySubscription != null &&
        !connectivitySubscription!.isPaused;
  }

  //-------🟢--------GetScreenWiseApi------------🟢-----------------------------//

  static Future<void> GetScreenWiseApi(
    BuildContext context,
    String ScreenType,
  ) async {
    //-------HomeScreenAPIDATA----------------------------------------------------//
    if (ScreenType == "HomeScreenAPIDATA") {
      if (context.mounted) {
        await Provider.of<HomeProvider>(
          context,
          listen: false,
        ).HomeScreenAPIDATA(context);
      }
    }
    //-------OrderHistoryScreenAPIDATA----------------------------------------------------//
    if (ScreenType == "OrderHistoryScreenAPIDATA") {
      if (context.mounted) {
        await Provider.of<OrderHistoryProvider>(
          context,
          listen: false,
        ).OrderHistoryScreenAPIDATA(context);
      }
    }
  }
}
