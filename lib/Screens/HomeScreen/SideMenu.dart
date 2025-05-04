// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, unnecessary_null_comparison, avoid_function_literals_in_foreach_call, deprecated_member_use
import 'package:amritwaterdelivery/GlobalComponents/HTTPRepository/Packages.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//-----------------------------------------NavigationDrawer-------------------//
class SideDrawerScreen extends StatefulWidget {
  const SideDrawerScreen({super.key});

  @override
  SideDrawerScreenState createState() => SideDrawerScreenState();
}

//-----------------------------------------NavigationDrawerState--------------//
class SideDrawerScreenState extends State<SideDrawerScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int BROWSEChangeColor = -1;
  List<dynamic> BROWSEDrawerListing = [];
  final ScrollController _scrollController = ScrollController();
  String? Name;
  String? Phone;
  String? Image = GlobalServiceURL.ProfileImagesUrl;
  //----------------------------------------------------------------------------//
  @override
  void initState() {
    super.initState();
    GetInf();
    setState(() {
      BROWSEChangeColor = -1;
      BROWSEDrawerListing = GlobalFunction().NavigationBROWSEDrawerList;
    });
  }

  //----------------------------------------------------------------------------//
  void GetInf() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Name = prefs.getString("UserLoginName").toString();
      Phone = prefs.getString("UserLoginMobile").toString();
      //Image = prefs.getString("UserLoginProfileImg") ?? GlobalServiceURL.ProfileImagesUrl;
      Image = GlobalServiceURL.ProfileImagesUrl;
    });
  }

  //-----------------------------------Widget-----------------------------------//
  @override
  Widget build(BuildContext context) {
    Provider.of<LoginProvider>(context, listen: true);
    Provider.of<CheckInternet>(context, listen: true);
    return Scaffold(
      backgroundColor: GlobalAppColor.BackgroundColor, // Bottom section white
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.only(top: 15.0, left: 16),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: GlobalDecorations.IconResponsiveValue(
                      context: context,
                      mobileValue: 18.0,
                      tabletValue: 30.0,
                      desktopValue: 40.0,
                    ),
                    backgroundColor: Colors.white,
                    backgroundImage: CachedNetworkImageProvider(
                      Image.toString(),
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        toBeginningOfSentenceCase(Name.toString()),
                        style: GlobalDecorations.CommanTextStyle(
                          context,
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        Phone.toString(),
                        style: GlobalDecorations.CommanTextStyle(
                          context,
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                color: GlobalAppColor.WhiteColorCode, // Top section background
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  controller: _scrollController,
                  itemCount: BROWSEDrawerListing.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> item = BROWSEDrawerListing[index];
                    return GestureDetector(
                      onTap: () => _onItemBROWSETapped(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              BROWSEChangeColor == index
                                  ? GlobalAppColor.BackgroundColor
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ), // Set the radius here
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 10,
                        ),
                        margin: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 10,
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              item['Icon'],
                              size: GlobalDecorations.IconResponsiveValue(
                                context: context,
                                mobileValue: 18.0, // Mobile size
                                tabletValue: 20.0, // Tablet size
                                desktopValue: 40.0, // Desktop size
                              ),
                              color: GlobalAppColor
                                  .NewBlackTextCode.withOpacity(0.7),
                            ),
                            SizedBox(width: 15),
                            Text(
                              item["Title"],
                              style: GlobalDecorations.CommanTextStyle(
                                context,
                                fontSize: 16,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "VERSION 1.0.0",
                  style: GlobalDecorations.CommanTextStyle(
                    context,
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                    color: GlobalAppColor.ButtonColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //-----------------_onItemBROWSETapped----------------------------------------//
  void _onItemBROWSETapped(int index) {
    setState(() {
      BROWSEChangeColor = index;
      if (index == 0) {
        Navigator.of(context).pop();
        GlobalFunction().navigateToScreen(context, const OrderHistoryScreen());
      }
      if (index == 1) {
        Navigator.of(context).pop();
      }
      if (index == 2) {
        Navigator.of(context).pop();
      }
      if (index == 3) {
        Navigator.of(context).pop();
        GlobalFunction().navigateToScreen(context, const ResetPasswordScreen());
      }
      if (index == 4) {
        Navigator.of(context).pop();
        GlobalFunction().NormalMessageWithTwoButtonAlert(
          context,
          "Logout",
          GlobalFlag.LogOutApp,
          "Logout",
        );
      }
    });
  }
}
