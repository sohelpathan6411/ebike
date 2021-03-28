import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:radarsoft_ebike/Helpers/constants.dart';
import 'package:radarsoft_ebike/Helpers/helper.dart';
import 'package:radarsoft_ebike/auth/LoginPage.dart';
import 'package:radarsoft_ebike/pages/home_page.dart';
import 'package:radarsoft_ebike/view%20models/bikes_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_TITLE,
      debugShowCheckedModeBanner: false,
      home: OnBoardingPage(),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  double screenHeight=0.0, screenWidth=0.0;
  bool _ischecked = false;

  Future introDone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('FINISHED_ON_BOARDING', true);
  }

  Future isFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isfinished = await prefs.getBool('FINISHED_ON_BOARDING');
    if(isfinished==true){
      pushReplacement(context, LoginPage());
    }else{
      setState(() {
        _ischecked = true;
      });
    }
  }

  void _onIntroEnd(context) {
    introDone();
    pushReplacement(context, LoginPage());
  }

  Widget _buildImage(String assetName) {

    return Align(
      child: Image.asset('assets/$assetName.png', height: screenHeight/4,),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isFirstTime();
  }

  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return _ischecked==true?IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "E-Bike",
          body:
          "Provides a dedicated Electric Vehicle for rental, locals and many more. The Eco-friendly deliveries reduces the carbon footprint and makes India Pollution free",
          image: _buildImage('scooter'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Scan QR code to start",
          body:
          "Start your ride, watch ride fare and travelled distance",
          image: _buildImage('barcode'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Locate your bike",
          body:
          "Find current, destination locations with minimal distances and routes.",
          image: _buildImage('track'),
          decoration: pageDecoration,
        ),

      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(COLOR_BACKGROUND),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    ): Scaffold(
      backgroundColor: Color(COLOR_BACKGROUND),
      body: Container(
        color: Colors.transparent,
        child: Center(
          child: new CircularProgressIndicator(
            strokeWidth: 1,
            backgroundColor: Colors.black,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }
}
