import 'dart:core';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_application_boat/models/cate_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  Future<String> fetchJWTTokenUser(String myToken) async {
    try {
      Dio dio = Dio();

      var response = await dio.post(dotenv.env['VAR_NAME']! + "authens",
          data: '"' + myToken + '"',
          options: Options(
              headers: {
                HttpHeaders.contentTypeHeader: "application/json",
                HttpHeaders.acceptHeader: "*/*"
              },
              contentType: "application/json",
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500;
              }));
      return response.data.toString();
    } catch (e) {
      print(e.toString());
    }
    return "";
  }

  Future<CategoryBoat?> getAllCate() async {
    try {
      Dio dio = Dio();
      var response = await dio.get(dotenv.env['VAR_NAME']! + "authens");

      return response.data;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
