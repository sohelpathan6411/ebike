import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:radarsoft_ebike/Helpers/constants.dart';

class permissionDenied extends StatefulWidget {
  permissionDenied({
    Key key,
  }) : super(key: key);

  _permissionDeniedState createState() => _permissionDeniedState();
}

class _permissionDeniedState extends State<permissionDenied> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Permissions Denied',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'If you wish to use  Maujud App, it is mandatory to give them permission to use your location services',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(COLOR_TEXT_PRIMARY),
                          fontSize: 16.0,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                    ),
                    Material(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.0)),
                      elevation: 18.0,
                      color: Color(COLOR_PRIMARY_DARK),
                      clipBehavior: Clip.antiAlias,
                      child: MaterialButton(
                          minWidth: 200.0,
                          height: 35,
                          child: new Text('Open Settings',
                              style: new TextStyle(
                                  fontSize: 16.0, color: Colors.white)),
                          onPressed: () async {
                            LocationPermissions().openAppSettings();
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
