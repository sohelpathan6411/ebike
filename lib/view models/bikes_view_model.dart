import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:radarsoft_ebike/models/BikesParser.dart';
import 'package:radarsoft_ebike/services/web_service.dart';


class BikesViewModel extends ChangeNotifier {

  List<BikesParser> listModel = [];

  //Modeling data to list
  Future<void> fetchBikes() async {

    final response = await RequestBikes().fetchBikes();
    print("data: "+response.toString());
    this.listModel.clear();


    final data = jsonDecode(response.body);
    for (Map i in data) {
      listModel.add(BikesParser.fromJson(i));
    }

    notifyListeners();
  }
}
