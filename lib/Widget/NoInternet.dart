import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radarsoft_ebike/Helpers/constants.dart';
import 'package:radarsoft_ebike/Helpers/helper.dart';
import 'package:radarsoft_ebike/pages/home_page.dart';
import 'package:radarsoft_ebike/view%20models/bikes_view_model.dart';

class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Color(COLOR_BACKGROUND),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                ASSET_PATAH + 'noint.png',
                height: screenHeight / 2,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(20.0),
                width: double.infinity,
                height: 45.0,
                child: Text(
                  "No Internet Connected!",
                  style: TextStyle(
                      color: Color(COLOR_TEXT_PRIMARY),
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              InkWell(
                onTap: (){
                  pushReplacement(
                    context,
                    MultiProvider(
                      providers: [
                        ChangeNotifierProvider(
                          create: (context) => BikesViewModel(),
                          child: home_page(),
                        ),
                      ],
                      child: home_page(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Material(
                    color: Color(COLOR_PRIMARY),
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                        height: 40.0,
                        width: double.infinity,
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              '',
                              style: TextStyle(
                                  color: Color(COLOR_WHITE),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'RESUME',
                                  style: TextStyle(
                                      color: Color(COLOR_WHITE),
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.refresh,
                              color: Color(COLOR_WHITE),
                              size: 40,
                            ),
                          ],
                        )),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
