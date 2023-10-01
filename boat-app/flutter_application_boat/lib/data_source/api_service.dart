import 'dart:core';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class ApiService {
  Future<String> fetchJWTTokenUser(String myToken) async {
    Uri url = Uri.parse(dotenv.env['API_URL']! + "authens");
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = myToken;
    // tạo POST request
    Response response = await post(url, headers: headers, body: json);
    // kiểm tra status code của kết quả response
    int statusCode = response.statusCode;
    // API này trả về id của item mới được add trong body
    String body = response.body;
    return body;
  }
}
