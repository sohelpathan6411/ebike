import 'package:flutter/material.dart';
import 'package:radarsoft_ebike/Helpers/constants.dart';

import 'customClipper.dart';

class TextLogo extends StatelessWidget {
  const TextLogo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: 'E',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(COLOR_PRIMARY),
            ),
            children: [
              TextSpan(
                text: '-',
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
              TextSpan(
                text: 'Bike',
                style: TextStyle(color: Color(COLOR_PRIMARY), fontSize: 30),
              ),
            ]),
      ),
    );
  }
}
