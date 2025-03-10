// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, unnecessary_null_comparison, avoid_function_literals_in_foreach_call, deprecated_member_use
import 'package:amritwaterdelivery/GlobalComponents/HTTPRepository/Packages.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//✅------------------------------------------------------------------------✅//
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

//✅------------------------------------------------------------------------✅//
class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> SnackBarscaffoldKey =
      GlobalKey<ScaffoldState>();

  //✅------------------------------------------------------------------------✅//
  @override
  void initState() {
    super.initState();
    GlobalFunction().setPortrait();
    GlobalCheckInternetConnectivity.checkInternetConnectivity(
      context,
      "HomeScreenAPIDATA",
    );
  }

  //✅------------------------------------------------------------------------✅//
  @override
  Widget build(BuildContext context) {
    Provider.of<HomeProvider>(context, listen: true);
    Provider.of<CheckInternet>(context, listen: true);
    Provider.of<LoginProvider>(context, listen: true);
    return WillPopScope(
      onWillPop: () async {
        GlobalFunction().NormalMessageWithTwoButtonAlert(
          context,
          "Notify",
          GlobalFlag.exitanApp,
          "Exit",
        );
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: GlobalAppColor.WhiteColorCode,
        resizeToAvoidBottomInset: true, // Allow scrolling when keyboard is open
        key: SnackBarscaffoldKey,
        appBar: AppBar(
          flexibleSpace: Container(color: GlobalAppColor.BackgroundColor),
          iconTheme: IconThemeData(
            color: GlobalAppColor.ButtonColor,
            size: GlobalDecorations.IconResponsiveValue(
              context: context,
              mobileValue: 18.0, // Mobile size
              tabletValue: 30.0, // Tablet size
              desktopValue: 40.0, // Desktop size
            ),
          ),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: true,
          titleSpacing: -10,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // CircleAvatar for image
              ClipOval(
                child: Image.asset(
                  GlobalImage.Logo, // Replace with your image asset
                  width:
                      MediaQuery.of(context).size.width *
                      0.15, // Responsive width
                  height: MediaQuery.of(context).size.width * 0.15,
                  fit: BoxFit.contain,
                  semanticLabel: 'Logo', // Adds accessibility
                ),
              ),
              SizedBox(width: 10), // Adjusted spacing between image and text
              Text(
                'AmritMineral Delivery Water',
                style: GlobalDecorations.CommanTextStyle(
                  context,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: GlobalAppColor.ButtonColor,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          leading: Builder(
            builder:
                (context) => IconButton(
                  icon: Icon(Icons.menu, color: GlobalAppColor.ButtonColor),
                  onPressed:
                      () => SnackBarscaffoldKey.currentState?.openDrawer(),
                ),
          ),
        ),
        drawer: const SizedBox(child: Drawer(child: SideDrawerScreen())),
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              width: double.infinity,
              child: OrderList(),
            ),
          ),
        ),
      ),
    );
  }

  //---------OrderList----------------------------------------------------------//
  Widget OrderList() {
    Provider.of<CheckInternet>(context, listen: true);
    Provider.of<HomeProvider>(context, listen: true);
    final GetInternetActivity = context.watch<CheckInternet>();
    return Consumer<HomeProvider>(
      builder: (context, providerValue, child) {
        // Check for loading state
        if (providerValue.isLoading == true) {
          return Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.1,
            ),
            child: GlobalDecorations().buildLoadingState(context),
          );
        }
        // Check for internet state
        else if (GetInternetActivity.InternetTextValue == GlobalFlag.InActive) {
          return Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.1,
            ),
            child: GlobalDecorations().buildNoInternetState(context),
          );
        }
        // Check for NoData state
        else if (providerValue.HomeListing.isEmpty) {
          return Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.1,
            ),
            child: GlobalDecorations().buildNoDataState(
              context,
              "No Order Available!",
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: providerValue.HomeListing.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                var GetData = providerValue.HomeListing[index];
                if (GetData.status == "Accept") {
                  providerValue.dropdownItems = ['Select Type', 'Transit'];
                } else if (GetData.status == "Transit") {
                  providerValue.dropdownItems = [
                    'Select Type',
                    'Delivered',
                    'Cancelled',
                  ];
                }
                return GestureDetector(
                  onTap: () async {
                    bool isConnected = await GlobalDecorations()
                        .checkInternetConnection(context);
                    if (isConnected) {
                      GlobalFunction().navigateToScreen(
                        context,
                        OrderDetails(
                          SendData: providerValue.HomeListing[index],
                        ),
                      );
                    }
                  },
                  child: CommonCard(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          AddressRow(
                            title: "Customer Name:",
                            value: GetData.user?.name ?? 'No name available',
                          ),
                          AddressRow(
                            title: "Customer Mobile:",
                            value:
                                GetData.user?.mobile ?? 'No mobile available',
                          ),
                          AddressRow(
                            title: "Order Date:",
                            value: formatDateTime(
                              GetData.orderDate.toString(),
                              GetData.orderTime.toString(),
                            ),
                          ),
                          AddressRow(
                            title: "Order No:",
                            value: GetData.orderNumber ?? 'Not found',
                          ),
                          AddressRow(
                            title: "Order Amount:",
                            value: '₹ ${GetData.totalAmount ?? '0.0'}',
                          ),
                          AddressRow(
                            title: "Address:",
                            value:
                                GetData.userAddress?.getFormattedAddress() ??
                                'Not found',
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "Change Status:",
                                  style: GlobalDecorations.CommanTextStyle(
                                    context,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: GlobalAppColor.BlackTextCode,
                                    letterSpacing: 0.8,
                                    height: 1.2,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  isDense: true,
                                  value: providerValue.dropdownValues![index],
                                  // Set current item value
                                  onChanged:
                                      providerValue.loadingOrderStatus == true
                                          ? null
                                          : (String? newValue) {
                                            if (newValue != null) {
                                              providerValue
                                                  .dropdownValues = List.generate(
                                                providerValue
                                                    .HomeListing
                                                    .length,
                                                // Generate based on the length of HomeListing
                                                (index) =>
                                                    'Select Type', // Set 'Select Type' as default for each item
                                              );
                                              providerValue.SelectedItems = "";
                                              providerValue.ChangedDropDownStatus(
                                                newValue,
                                                index,
                                              ); // Update selected value
                                            }
                                          },
                                  iconSize: 30,
                                  iconDisabledColor: GlobalAppColor.ButtonColor,
                                  iconEnabledColor: GlobalAppColor.ButtonColor,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    // Remove borders
                                    focusedBorder: InputBorder.none,
                                    // Remove focus border
                                    enabledBorder: InputBorder.none,
                                    // Remove enabled border
                                    disabledBorder: InputBorder.none,
                                    // Remove disabled border
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 1.0,
                                    ), // Custom padding
                                  ),
                                  items:
                                      providerValue.dropdownItems.map<
                                        DropdownMenuItem<String>
                                      >((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style:
                                                GlobalDecorations.CommanTextStyle(
                                                  context,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                  color:
                                                      GlobalAppColor
                                                          .ButtonColor,
                                                  letterSpacing: 0.8,
                                                  height: 1.2,
                                                ),
                                          ),
                                        );
                                      }).toList(),

                                  /// Ensure dropdown menu opens below
                                  menuMaxHeight: 300,
                                  // Adjust menu height to fit below
                                  alignment: Alignment.bottomCenter,
                                  // Align dropdown towards bottom
                                  /// Wrap with `DropdownButtonHideUnderline` to remove default underline
                                  dropdownColor:
                                      Colors.white, // Dropdown background color
                                ),
                              ),
                            ],
                          ),
                          GlobalDecorations().globalCupertinoButton(
                            context: context,
                            onPressed:
                                providerValue.loadingOrderStatus == true
                                    ? null
                                    : () async {
                                      bool isConnected =
                                          await GlobalDecorations()
                                              .checkInternetConnection(context);
                                      if (isConnected) {
                                        bool hasInvalidSelection = providerValue
                                            .dropdownValues![index]
                                            .contains("Select Type");
                                        if (hasInvalidSelection) {
                                          GlobalFunction().PopupFailedAlert(
                                            context,
                                            "Failed",
                                            "",
                                            "Please select a valid status for all items!",
                                          );
                                        } else {
                                          String? OrderID;
                                          for (var detail in GetData.details!) {
                                            OrderID = detail.orderId.toString();
                                          }
                                          validateAndSubmit(
                                            context,
                                            OrderID.toString(),
                                          );
                                        }
                                      }
                                    },
                            isLoading: providerValue.GlobalOrderStatusLoader,
                            buttonText: GetData.status.toString(),
                            loaderKey: GlobalFunction().LoaderKey,
                            btnHeight: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  //✅------------------------------------------------------------------------✅//
  String formatDateTime(String date, String time) {
    try {
      DateTime dateTime = DateTime.parse("$date $time");
      return DateFormat("dd MMM yyyy hh:mm a").format(dateTime);
    } catch (e) {
      return "Invalid Date"; // Agar koi issue ho to default text
    }
  }

  //✅------------------------------------------------------------------------✅//
  void validateAndSubmit(BuildContext context, String OrderID) async {
    final GetHomeData = Provider.of<HomeProvider>(context, listen: false);
    GetHomeData.UserUpdateOrderStatusService(
      context: context,
      OrderID: OrderID,
    );
  }
}
