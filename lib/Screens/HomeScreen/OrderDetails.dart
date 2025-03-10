// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, unnecessary_null_comparison, avoid_function_literals_in_foreach_call, deprecated_member_use
import 'package:amritwaterdelivery/GlobalComponents/HTTPRepository/Packages.dart';
import 'package:flutter/material.dart';

//✅------------------------------------------------------------------------✅//
class OrderDetails extends StatefulWidget {
  final Orders SendData;

  const OrderDetails({super.key, required this.SendData});
  @override
  OrderDetailsState createState() => OrderDetailsState();
}

//✅------------------------------------------------------------------------✅//
class OrderDetailsState extends State<OrderDetails>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> SnackBarscaffoldKey =
      GlobalKey<ScaffoldState>();

  //✅------------------------------------------------------------------------✅//
  @override
  void initState() {
    super.initState();
    GlobalFunction().setPortrait();
  }

  //✅------------------------------------------------------------------------✅//
  @override
  Widget build(BuildContext context) {
    Provider.of<HomeProvider>(context, listen: true);
    Provider.of<CheckInternet>(context, listen: true);
    Provider.of<LoginProvider>(context, listen: true);
    Orders order = widget.SendData;
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
              'Order Details',
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
        titleSpacing: -15,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //----------------------------------------------------------------------------//
                  SizedBox(height: 1),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Order Details for: ${order.orderNumber ?? 'Not available'}",
                      style: GlobalDecorations.CommanTextStyle(
                        context,
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: GlobalAppColor.BlackTextCode,
                      ),
                    ),
                  ),
                  Divider(),
                  //----------------------------------------------------------------------------//
                  SizedBox(
                    width: double.infinity,
                    child: CommonCard(
                      child: Column(
                        spacing: 12,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _headerText("Order Details"),
                          Divider(thickness: 0.5, height: 1),
                          AddressRow(
                            title: "Order No:",
                            value: order.orderNumber ?? 'Not available',
                          ),
                          AddressRow(
                            title: "Customer Name:",
                            value: order.user?.name ?? 'Not available',
                          ),
                          AddressRow(
                            title: "Customer Mobile:",
                            value: order.user?.mobile ?? 'Not available',
                          ),
                          AddressRow(
                            title: "Total Amount:",
                            value: "₹ ${order.totalAmount ?? '0.0'}",
                          ),
                          AddressRow(
                            title: "Status:",
                            value: order.status ?? 'Not available',
                          ),
                        ],
                      ),
                    ),
                  ),
                  //----------------------------------------------------------------------------//
                  SizedBox(
                    width: double.infinity,
                    child: CommonCard(
                      child: Column(
                        spacing: 12,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _headerText("User Address"),
                          Divider(thickness: 0.5, height: 1),
                          AddressRow(
                            title: "Address:",
                            value:
                                order.userAddress?.getFormattedAddress() ??
                                'Not found',
                          ),
                          AddressRow(
                            title: "City:",
                            value: order.userAddress?.city ?? 'Not available',
                          ),
                          AddressRow(
                            title: "State:",
                            value: order.userAddress?.state ?? 'Not available',
                          ),
                          AddressRow(
                            title: "ZipCode:",
                            value:
                                order.userAddress?.postalCode ??
                                'Not available',
                          ),
                          AddressRow(
                            title: "Phone:",
                            value: order.user?.mobile ?? 'Not available',
                          ),
                        ],
                      ),
                    ),
                  ),
                  //----------------------------------------------------------------------------//
                  SizedBox(
                    width: double.infinity,
                    child: CommonCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _headerText("Ordered Products"),
                          Divider(thickness: 0.5),
                          _buildTableHeader(),
                          Divider(thickness: 0.5),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: order.details?.length ?? 0,
                            itemBuilder:
                                (_, i) => _buildOrderRow(order.details![i]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------//
  // ✅ Header Text Widget
  Widget _headerText(String title) => Text(
    title,
    style: GlobalDecorations.CommanTextStyle(
      context,
      fontWeight: FontWeight.w500,
      fontSize: 18,
      color: GlobalAppColor.ButtonColor,
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
}

//----------------------------------------------------------------------------//
// ✅ Reusable CommonCard Widget
class CommonCard extends StatelessWidget {
  final Widget child;
  final double elevation;
  final EdgeInsetsGeometry padding;

  const CommonCard({
    super.key,
    required this.child,
    this.elevation = 4,
    this.padding = const EdgeInsets.all(10),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: GlobalAppColor.ButtonColor, width: 1),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

// ✅ Reusable AddressRow Widget
class AddressRow extends StatelessWidget {
  final String title;
  final String value;

  const AddressRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Text(
            title,
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
          child: Text(
            value,
            style: GlobalDecorations.CommanTextStyle(
              context,
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: GlobalAppColor.ButtonColor,
              letterSpacing: 0.8,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}
