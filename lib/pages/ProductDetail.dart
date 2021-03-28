import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:radarsoft_ebike/Helpers/constants.dart';
import 'package:radarsoft_ebike/Helpers/helper.dart';
import 'package:radarsoft_ebike/Widget/permissionDenied.dart';
import 'package:radarsoft_ebike/models/BikesParser.dart';
import 'package:radarsoft_ebike/pages/ScanQRCode.dart';
import 'package:radarsoft_ebike/pages/startRide.dart';
import 'package:radarsoft_ebike/pages/trackRide.dart';

class ProductDetail extends StatefulWidget {
  ProductDetail({Key key, this.product}) : super(key: key);

  final BikesParser product;

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final Geolocator geolocator = Geolocator();
  double latitudePick = 0.0;
  double longitudePick = 0.0;

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        print("locper" + "3");

        latitudePick = position.latitude;
        longitudePick = position.longitude;
      });
    }).catchError((e) {
      print(e);
    });
  }

  void _Rationale() async {
    PermissionStatus permission =
        await LocationPermissions().checkPermissionStatus();
    print("locper" + permission.toString());
    if (permission == PermissionStatus.granted) {
      print("locper" + "1");
      _getCurrentLocation();
    } else {
      print("locper" + permission.toString());

      await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          String title = "Permission Required";
          String message =
              "This app collects location data to enable feature like find near by drivers, calculate distance, track driver & navigate to places even when the app is not in use.";
          String btnAllow = "Allow";
          String btnCancel = "Cancel";
          return Platform.isIOS
              ? new CupertinoAlertDialog(
                  title: Text(title),
                  content: Text(message),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(btnCancel),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true)
                            .pop("Discard");
                        pushReplacement(context, permissionDenied());
                      },
                    ),
                    FlatButton(
                      child: Text(btnAllow),
                      onPressed: () async {
                        PermissionStatus permission =
                            await LocationPermissions().requestPermissions();
                        if (permission == PermissionStatus.granted) {
                          Navigator.of(context, rootNavigator: true)
                              .pop("Discard");
                          _getCurrentLocation();
                        } else {
                          pushReplacement(context, permissionDenied());
                        }
                      },
                    ),
                  ],
                )
              : new AlertDialog(
                  title: Text(title),
                  content: Text(message),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(btnCancel),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true)
                            .pop("Discard");
                        pushReplacement(context, permissionDenied());
                      },
                    ),
                    FlatButton(
                      child: Text(btnAllow),
                      onPressed: () async {
                        PermissionStatus permission =
                            await LocationPermissions().requestPermissions();
                        if (permission == PermissionStatus.granted) {
                          Navigator.of(context, rootNavigator: true)
                              .pop("Discard");
                          _getCurrentLocation();
                        } else {
                          pushReplacement(context, permissionDenied());
                        }
                      },
                    ),
                  ],
                );
        },
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _Rationale();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenHeight = (screenSize.height) / 2;
    //var screenWidth = (screenSize.width) / 2;

    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        color: Color(COLOR_BACKGROUND),
        child: ListView(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: CachedNetworkImage(
                imageUrl: widget.product.image_link,
                placeholder: (context, url) => Center(
                  child: new CircularProgressIndicator(
                    strokeWidth: 1,
                    backgroundColor: Color(COLOR_BACKGROUND),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(COLOR_PRIMARY),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
            ),
            // provides vertical space of 10 pxl
            SizedBox(height: 10),

            // container for the price & detail contents of the product
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(widget.product.title,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(COLOR_TEXT_PRIMARY))),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Base Fare: \$${widget.product.base_fare}",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(COLOR_TEXT_PRIMARY))),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Charges: \$${widget.product.cost_per_minute} /min",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(COLOR_TEXT_PRIMARY))),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(widget.product.description,
                      style: TextStyle(color: Color(COLOR_TEXT_PRIMARY))),
                  SizedBox(height: 30),
                  Text(
                      '* on click rent now, list of nearest bikes can be found!',
                      style: TextStyle(color: Color(COLOR_TEXT_PRIMARY))),
                  SizedBox(height: 20),
                  BookBikeButton(),
                  SizedBox(height: 30),
                  Text(
                      '* User can track bikes live location from nearest centre to users current location or vice versa!',
                      style: TextStyle(color: Color(COLOR_TEXT_PRIMARY))),
                  SizedBox(height: 20),
                  TrackBikeButton(),
                  SizedBox(height: 30),
                  Text(
                      '* Once bike reached to user or vice versa, on QR Scanning we will verify it on server',
                      style: TextStyle(color: Color(COLOR_TEXT_PRIMARY))),
                  SizedBox(height: 20),
                  ScanQRCodeButton(),
                  SizedBox(height: 30),
                  Text(
                      '* Once ride started, we will take start time\n* will fetch current cost after each 1 minute\n* Once user end ride, we will calculate time at server',
                      style: TextStyle(color: Color(COLOR_TEXT_PRIMARY))),
                  SizedBox(height: 20),
                  NaviGateToDestination(),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget BookBikeButton() {
    return InkWell(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(COLOR_BACKGROUND),
          borderRadius: BorderRadius.all(Radius.circular(16)),
          border: Border.all(
            color: Color(COLOR_PRIMARY),
          ),
        ),
        child: Text(
          "Rent Now",
          style: TextStyle(fontSize: 20, color: Color(COLOR_TEXT_PRIMARY)),
        ),
      ),
    );
  }

  Widget TrackBikeButton() {
    return InkWell(
      onTap: () {
        push(
            context,
            trackRide(
              latDest: widget.product.lat,
              langDest: widget.product.lang,
            ));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(COLOR_BACKGROUND),
          borderRadius: BorderRadius.all(Radius.circular(16)),
          border: Border.all(
            color: Color(COLOR_PRIMARY),
          ),
        ),
        child: Text(
          "Track ride",
          style: TextStyle(fontSize: 20, color: Color(COLOR_TEXT_PRIMARY)),
        ),
      ),
    );
  }

  Widget ScanQRCodeButton() {
    return InkWell(
      onTap: () {
        push(context, ScanQRCode());
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(COLOR_BACKGROUND),
          borderRadius: BorderRadius.all(Radius.circular(16)),
          border: Border.all(
            color: Color(COLOR_PRIMARY),
          ),
        ),
        child: Text(
          "Scan to unlock",
          style: TextStyle(fontSize: 20, color: Color(COLOR_TEXT_PRIMARY)),
        ),
      ),
    );
  }

  Widget NaviGateToDestination() {
    return InkWell(
      onTap: () {
        geolocator
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
            .then((Position position) {
          setState(() {
            push(
                context,
                startRide(
                  latPick: latitudePick,
                  langPick: longitudePick,
                  latDest: double.parse(widget.product.lat),
                  langDest: double.parse(widget.product.lang),
                ));
          });
        }).catchError((e) {
          print(e);
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(COLOR_BACKGROUND),
          borderRadius: BorderRadius.all(Radius.circular(16)),
          border: Border.all(
            color: Color(COLOR_PRIMARY),
          ),
        ),
        child: Text(
          "NaviGate To Destination",
          style: TextStyle(fontSize: 20, color: Color(COLOR_TEXT_PRIMARY)),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Color(COLOR_ACCENT),
      title: Text(
        widget.product.title,
        style: TextStyle(fontSize: 22),
      ),
      centerTitle: true,
    );
  }
}
