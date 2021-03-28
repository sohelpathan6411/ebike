import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Helpers/helper.dart';

class RequestBikes {
  Future fetchBikes() async {
    final url  = "https://joblist.techsohel.com/mobileapp/get_bikes.php";
    print(url);
    try {
      final response = await http.get(Uri.parse(url));
      print("response" + response.body.toString());
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception("Unable to perform request!");
      }
    }catch(Exception){
      print("exception"+ Exception.toString());
    }
  }
}