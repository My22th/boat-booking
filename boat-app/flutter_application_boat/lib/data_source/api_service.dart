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

  Future<List<CategoryBoat>> getAllCate() async {
    try {
      Dio dio = Dio();

      var response = await dio.get(dotenv.env['API_URL']! + "categorys");
      List<CategoryBoat> productList = List.empty(growable: true);
      var a = response.data[1]["lstImgURL"];
      response.data.forEach((json) => {
            productList.add(CategoryBoat(
              id: "",
              title: json['title'],
              pricePerDay: json['pricePerDay'].toDouble(),
              description: json['description'],
              lstImgURL: [json["lstImgURL"][0]],
              capacity: json['capacity'],
              categoryId: json['categoryId'],
              categoryPrice: json['categoryPrice'].toDouble(),
              categoryVolume: json['categoryVolume'],
              lat: json['lat'],
              long: json['long'],
              name: json['name'],
              type: BoatType(id: 1, name: "long"),
            ))
          });

      return productList;
    } catch (e) {
      print(e.toString());
    }
    return List.empty();
  }
}
