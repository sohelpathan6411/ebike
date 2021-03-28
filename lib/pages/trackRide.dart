import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:geolocator/geolocator.dart';
import 'package:radarsoft_ebike/Helpers/constants.dart';

double roundDouble(double value, int places) {
  double mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

double _height, _width, _fixedPadding;

class trackRide extends StatefulWidget {
  final latDest, langDest;

  trackRide({
    Key key,
    @required this.latDest,
    @required this.langDest,
  }) : super(key: key);

  _trackRideState createState() => _trackRideState();
}

class _trackRideState extends State<trackRide> {
  MapBoxNavigation _directions;
  MapBoxOptions _options;
  bool _arrived = false;
  bool _isMultipleStop = false;
  double _distanceRemaining, _durationRemaining;
  MapBoxNavigationViewController _controller;
  bool _routeBuilt = false;
  bool _isNavigating = false;
  final Geolocator geolocator = Geolocator();
  Timer timer;
  bool isfirsttime = true;

  double latCurrent, langCurrent;
  String latChange;

  @override
  void initState() {
    super.initState();
    initialize();
    setState(() {
      _arrived = false;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    print("disposed");
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initialize() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _directions = MapBoxNavigation(onRouteEvent: _onEmbeddedRouteEvent);
    _options = MapBoxOptions(
        initialLatitude: double.parse(widget.latDest),
        initialLongitude: double.parse(widget.langDest),
        zoom: 13.0,
        tilt: 0.0,
        bearing: 0.0,
        enableRefresh: false,
        alternatives: true,
        voiceInstructionsEnabled: false,
        bannerInstructionsEnabled: true,
        allowsUTurnAtWayPoints: true,
        mode: MapBoxNavigationMode.drivingWithTraffic,
        units: VoiceUnits.imperial,
        simulateRoute: true,
        animateBuildRoute: true,
        longPressDestinationEnabled: false,
        language: 'en');

    setState(() {
      latChange = widget.latDest;
    });

    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => buildRoute());
    if (isfirsttime) {
      buildRouteFirstTime();
    }
  }

  buildRoute() async {
    print("aaaaaa");
    final response = await http.post(Uri.parse(getbikelocation), body: {
      "bike_id": "1",
    });

    var temp = response.body;
    if (temp == "false") {
    } else {
      var temp = jsonDecode(response.body);
      geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) {
        print("issame: " + temp[0]["lat"] + " , " + latChange.toString());
        if (temp[0]["lat"] != latChange.toString()) {
          setState(() {
            latCurrent = position.latitude;
            langCurrent = position.longitude;
            latChange = temp[0]["lat"];
          });

          final _origin = WayPoint(
              name: "Way Point 1",
              latitude: double.parse(temp[0]["lat"]),
              longitude: double.parse(temp[0]["lang"]));
          final _stop1 = WayPoint(
              name: "Way Point 2",
              latitude: latCurrent,
              longitude: langCurrent);

          var wayPoints = List<WayPoint>();
          wayPoints.add(_origin);
          wayPoints.add(_stop1);
          _controller.buildRoute(wayPoints: wayPoints);
        }
      }).catchError((e) {
        print(e);
      });
    }
  }

  buildRouteFirstTime() {
    geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      final _origin = WayPoint(
          name: "Way Point 1",
          latitude: double.parse(widget.latDest),
          longitude: double.parse(widget.langDest));
      final _stop1 = WayPoint(
          name: "Way Point 2",
          latitude: position.latitude,
          longitude: position.longitude);

      var wayPoints = List<WayPoint>();
      wayPoints.add(_origin);
      wayPoints.add(_stop1);
      _controller.buildRoute(wayPoints: wayPoints);
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _width * 0.1;

    return Scaffold(
      appBar: AppBar(
        title: Text(APP_TITLE),
        backgroundColor: Color(COLOR_ACCENT),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.grey,
                    child: MapBoxNavigationView(
                        options: _options,
                        onRouteEvent: _onEmbeddedRouteEvent,
                        onCreated:
                            (MapBoxNavigationViewController controller) async {
                          _controller = controller;
                          controller.initialize();
                        }),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onEmbeddedRouteEvent(e) async {
    _distanceRemaining = await _directions.distanceRemaining;
    _durationRemaining = await _directions.durationRemaining;

    switch (e.eventType) {
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        setState(() {
          _routeBuilt = true;
        });
        break;
      case MapBoxEvent.route_build_failed:
        setState(() {
          _routeBuilt = false;
        });
        break;
      case MapBoxEvent.navigation_running:
        setState(() {
          _isNavigating = true;
        });
        break;
      case MapBoxEvent.on_arrival:
        setState(() {
          _arrived = true;
        });
        if (!_isMultipleStop) {
          await Future.delayed(Duration(seconds: 3));
          await _controller.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        setState(() {
          _routeBuilt = false;
          _isNavigating = false;
        });
        break;
      default:
        break;
    }
    setState(() {});
  }
}
