import 'dart:core';

import 'package:http/http.dart' as http;

class ApiService {
  Future<String> fetchJWTTokenUser(String myToken) {
    return http.get(const String.fromEnvironment('API_URL') as Uri).then((value) {
      if (value.statusCode == 200) {
        return value.body.toString();
      } else {
        return "";
      }
    });
  }
}
