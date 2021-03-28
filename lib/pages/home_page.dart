import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:provider/provider.dart';
import 'package:radarsoft_ebike/Helpers/constants.dart';
import 'package:radarsoft_ebike/Helpers/helper.dart';
import 'package:radarsoft_ebike/Widget/NoInternet.dart';
import 'package:radarsoft_ebike/Widget/bikes_list.dart';
import 'package:radarsoft_ebike/Widget/textLogo.dart';
import 'package:radarsoft_ebike/auth/LoginPage.dart';
import 'package:radarsoft_ebike/auth/LoginPage.dart';
import 'package:radarsoft_ebike/models/BikesParser.dart';
import 'package:radarsoft_ebike/view%20models/bikes_view_model.dart';

final List<String> imgList = [
  'https://joblist.techsohel.com/mobileapp/assets/slider1.jpg',
  'https://joblist.techsohel.com/mobileapp/assets/slider2.jpg',
  'https://joblist.techsohel.com/mobileapp/assets/slider3.jpg',
];

class home_page extends StatefulWidget {
  @override
  _home_pageState createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  bool _isinternet = true;
  bool _isloaded = false;

  @override
  void initState() {
    super.initState();
    //Initial data fetched
    _pullRefresh();
  }

  //Refreshes feed data
  Future<void> _pullRefresh() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == true) {
      setState(() {
        _isloaded = false;
        _isinternet = true;
      });
      Provider.of<BikesViewModel>(context, listen: false)
          .fetchBikes()
          .then((value) {
        setState(() {
          _isloaded = true;
          _isinternet = true;
        });
      });
    } else {
      print(DataConnectionChecker().lastTryResults);
      setState(() {
        _isloaded = false;
        _isinternet = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //providers(Feeds and comments)

    final ap = Provider.of<BikesViewModel>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(COLOR_BACKGROUND),
        iconTheme: IconThemeData(color: Color(COLOR_PRIMARY)),
        title: Column(
          children: [
            Text(
              APP_TITLE,
              style: TextStyle(
                  color: Color(COLOR_PRIMARY),
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ],
        ),
        centerTitle: true,
      ),

      drawer: Drawer(
          child: Container(
        color: Color(COLOR_BACKGROUND),
        child: ListView(
          children: <Widget>[
            InkWell(
              onTap: () {
                //redirect to profile tab if possible
                setState(() {
                  Navigator.pop(context);
                });
              },
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Color(COLOR_BACKGROUND)),
                accountName: Text(
                  'John Doe',
                  style: TextStyle(color: Color(COLOR_PRIMARY)),
                ),
                accountEmail: Text(
                  '0123456789',
                  style: TextStyle(color: Color(COLOR_PRIMARY)),
                ),
                currentAccountPicture: GestureDetector(
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://joblist.techsohel.com/mobileapp/assets/avatar.png",
                    placeholder: (context, url) => Center(
                      child: new CircularProgressIndicator(
                        strokeWidth: 1,
                        backgroundColor: Color(COLOR_BACKGROUND),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(COLOR_PRIMARY)),
                      ),
                    ),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                onTap: () {
                  Navigator.pop(context);
                },
                leading: Icon(Icons.home_outlined, color: Color(COLOR_PRIMARY)),
                title: Text(
                  'Home',
                  style: TextStyle(fontSize: 17.0, color: Color(COLOR_PRIMARY)),
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {},
              child: ListTile(
                onTap: () {
                  Navigator.pop(context);
                },
                leading:
                    Icon(Icons.category_outlined, color: Color(COLOR_PRIMARY)),
                title: Text(
                  'Search By Category',
                  style: TextStyle(fontSize: 17.0, color: Color(COLOR_PRIMARY)),
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {},
              child: ListTile(
                onTap: () {
                  Navigator.pop(context);
                },
                leading: Icon(Icons.location_on_outlined,
                    color: Color(COLOR_PRIMARY)),
                title: Text(
                  'Search By Location',
                  style: TextStyle(fontSize: 17.0, color: Color(COLOR_PRIMARY)),
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {},
              child: ListTile(
                onTap: () {
                  Navigator.pop(context);
                },
                leading:
                    Icon(Icons.share_outlined, color: Color(COLOR_PRIMARY)),
                title: Text(
                  'Share App',
                  style: TextStyle(fontSize: 17.0, color: Color(COLOR_PRIMARY)),
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {},
              child: ListTile(
                onTap: () {
                  Navigator.pop(context);
                },
                leading:
                    Icon(Icons.settings_outlined, color: Color(COLOR_PRIMARY)),
                title: Text(
                  'Settings',
                  style: TextStyle(fontSize: 17.0, color: Color(COLOR_PRIMARY)),
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {},
              child: ListTile(
                onTap: () {
                  Navigator.pop(context);
                },
                leading: Icon(Icons.privacy_tip_outlined,
                    color: Color(COLOR_PRIMARY)),
                title: Text(
                  'Privacy Policy',
                  style: TextStyle(fontSize: 17.0, color: Color(COLOR_PRIMARY)),
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () async {
                pushReplacement(context, LoginPage());
              },
              child: ListTile(
                leading:
                    Icon(Icons.power_settings_new, color: Color(COLOR_PRIMARY)),
                title: Text(
                  'Log Out',
                  style: TextStyle(fontSize: 17.0, color: Color(COLOR_PRIMARY)),
                ),
              ),
            ),
            Divider(),
            SizedBox(
              height: 30.0,
            ),
          ],
        ),
      )),
      //view as per index or tab selected
      body: _isinternet == true
          ? _isloaded == true
              ? Container(
                  color: Color(COLOR_BACKGROUND),
                  child: Column(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          aspectRatio: 16 / 9,
                          viewportFraction: 1,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 2),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                        ),
                        items: imgList
                            .map((item) => Container(
                                  child: CachedNetworkImage(
                                    imageUrl: item,
                                    placeholder: (context, url) => Center(
                                      child: new CircularProgressIndicator(
                                        strokeWidth: 1,
                                        backgroundColor:
                                            Color(COLOR_BACKGROUND),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Color(COLOR_PRIMARY)),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        new Icon(Icons.error),
                                  ),
                                ))
                            .toList(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'E-Bikes',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: BikesList(
                          bikesOBJ: ap.listModel,
                        ),
                      )
                    ],
                  ),
                )
              : Container(
                  color: Color(COLOR_BACKGROUND),
                  child: Center(
                    child: new CircularProgressIndicator(
                      strokeWidth: 1,
                      backgroundColor: Color(COLOR_BACKGROUND),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(COLOR_PRIMARY)),
                    ),
                  ),
                )
          : NoInternet(),
    );
  }
}
