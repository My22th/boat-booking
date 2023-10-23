import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_application_boat/models/cate_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  Future<String> fetchJWTTokenUser(String myToken) async {
    try {
      Dio dio = Dio();

      var response = await dio.post("${dotenv.env['API_URL']!}authens",
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

  Future<List<CategoryBoat>> getAllCate(DateTime fd, DateTime td) async {
    try {
      Dio dio = Dio();

      var response = await dio
          .get("${dotenv.env['API_URL']!}categorys/getbydate", data: {
        'fromdate': fd.toIso8601String(),
        'todate': td.toIso8601String()
      });
      List<CategoryBoat> cateList = List.empty(growable: true);
      if (response.data["code"] == 200) {
        jsonDecode(response.data["msg"]).forEach((json) => {
              cateList.add(CategoryBoat(
                id: "",
                title: json['Title'],
                pricePerDay: json['PricePerDay']?.toDouble(),
                description: json['Description'],
                lstImgURL: (json["LstImgURL"] as List)
                    .map((item) => item as String)
                    .toList(),
                capacity: json['Capacity'],
                categoryId: json['CategoryId'],
                categoryPrice: json['CategoryPrice']?.toDouble(),
                categoryVolume: json['CategoryVolume'],
                lat: json['Lat'],
                long: json['Long'],
                name: json['Name'],
                type: BoatType(id: 1, name: "long"),
              ))
            });
      }

      return cateList;
    } catch (e) {
      print(e.toString());
    }
    return List.empty();
  }
}
