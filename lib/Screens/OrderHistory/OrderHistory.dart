// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, unnecessary_null_comparison, avoid_function_literals_in_foreach_call, deprecated_member_use
import 'package:amritwaterdelivery/GlobalComponents/HTTPRepository/Packages.dart';
import 'package:amritwaterdelivery/Screens/OrderHistory/OrderHistoryController.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//✅------------------------------------------------------------------------✅//
class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  OrderHistoryScreenState createState() => OrderHistoryScreenState();
}

//✅------------------------------------------------------------------------✅//
class OrderHistoryScreenState extends State<OrderHistoryScreen>
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
      "OrderHistoryScreenAPIDATA",
    );
  }

  //✅------------------------------------------------------------------------✅//
  @override
  Widget build(BuildContext context) {
    Provider.of<HomeProvider>(context, listen: true);
    Provider.of<CheckInternet>(context, listen: true);
    Provider.of<LoginProvider>(context, listen: true);
    return Scaffold(
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
              'Order History',
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
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: GlobalAppColor.ButtonColor,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
        ),
      ),
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
    );
  }

  //---------OrderList----------------------------------------------------------//
  Widget OrderList() {
    Provider.of<CheckInternet>(context, listen: true);
    Provider.of<OrderHistoryProvider>(context, listen: true);
    final GetInternetActivity = context.watch<CheckInternet>();
    return Consumer<OrderHistoryProvider>(
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
        else if (providerValue.OrderHistoryListing.isEmpty) {
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
              itemCount: providerValue.OrderHistoryListing.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                var GetData = providerValue.OrderHistoryListing[index];
                return CommonCard(
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
                          value: GetData.user?.mobile ?? 'No mobile available',
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
                        AddressRow(
                          title: "Status:",
                          value: GetData.status ?? 'Not found',
                        ),
                        Divider(thickness: 0.5, height: 1),
                        _buildTableHeader(),
                        Divider(thickness: 0.5, height: 1),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: GetData.details?.length ?? 0,
                          itemBuilder:
                              (_, i) => _buildOrderRow(GetData.details![i]),
                        ),
                      ],
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

  //----------------------------------------------------------------------------//
  // ✅ Order Row
  Widget _buildOrderRow(orderDetail) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children:
        [
              orderDetail.product?.name ?? "No Product",
              orderDetail.quantity?.toString() ?? "0",
              "₹${orderDetail.product?.price ?? '0.0'}",
              "₹${orderDetail.amount ?? '0.0'}",
            ]
            .map(
              (data) =>
                  Expanded(child: _tableText(data, GlobalAppColor.ButtonColor)),
            )
            .toList(),
  );
  //----------------------------------------------------------------------------//
  // ✅ Table Text Widget
  Widget _tableText(String text, Color color) => Text(
    text,
    textAlign: TextAlign.center,
    style: GlobalDecorations.CommanTextStyle(
      context,
      fontWeight: FontWeight.w500,
      fontSize: 15,
      color: color,
    ),
  );
  //----------------------------------------------------------------------------//
  // ✅ Table Header
  Widget _buildTableHeader() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children:
        ["Name", "Quantity", "Price", "Amount"]
            .map(
              (title) => Expanded(
                child: _tableText(title, GlobalAppColor.BlackTextCode),
              ),
            )
            .toList(),
  );
}

//✅------------------------------------------------------------------------✅//
