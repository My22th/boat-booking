import 'dart:core';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<String> fetchJWTTokenUser(String myToken) async {
    final response = await http.post(
      Uri.parse(dotenv.env['API_URL']! + "authens"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: myToken,
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return response.body.toString();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
