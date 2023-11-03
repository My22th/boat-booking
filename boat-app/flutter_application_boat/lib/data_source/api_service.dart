import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_application_boat/models/cart_model.dart';
import 'package:flutter_application_boat/models/cate_model.dart';
import 'package:flutter_application_boat/models/order_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  Future<String> fetchJWTTokenUser(String myToken) async {
    try {
      Dio dio = Dio();

      var response = await dio.post("${dotenv.env['API_URL']!}authens",
          data: {"token": myToken},
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

  Future<BookingRes> booking(List<CartModel> lstItem, String userToken) async {
    try {
      Dio dio = Dio();
      List<BookingRequest> lstbk = List.empty(growable: true);
      for (var e in lstItem) {
        lstbk.add(BookingRequest(
            categoryId: e.cate.categoryId!,
            fromDate: e.formdate,
            toDate: e.todate));
      }
      var das = jsonEncode(lstbk.map((e) => e.toJson()).toList());
      var response = await dio.post("${dotenv.env['API_URL']!}orders/booking",
          data: das,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.acceptHeader: "*/*",
            HttpHeaders.authorizationHeader: userToken
          }, contentType: "application/json", followRedirects: false));

      if (response.data["code"] == 200) {
        return BookingRes(
            isErr: false,
            mess: response.data["msg"],
            ids: response.data["ids"]);
      } else {
        return BookingRes(isErr: true, mess: response.data["msg"]);
      }
    } catch (e) {
      print(e.toString());
    }
    return BookingRes(isErr: true, mess: "Error From Server");
  }

  Future<List<Order>> getorders(String userToken) async {
    try {
      Dio dio = Dio();
      List<Order> lstors = new List.empty(growable: true);

      var response = await dio.get("${dotenv.env['API_URL']!}orders",
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.acceptHeader: "*/*",
            HttpHeaders.authorizationHeader: userToken
          }, contentType: "application/json", followRedirects: false));

      if (response.data["code"] == 200) {
        var datas = response.data["msg"] as List<dynamic>;

        for (var element in datas) {
          print(element);
          lstors.add(Order(
            boatId: element['BoatId'],
            bookingDate: element['BookingDate'] == null
                ? DateTime.now()
                : element['BookingDate'] as DateTime,
            fromDate: element['FromDate'] == null
                ? DateTime.now()
                : element['FromDate'] as DateTime,
            toDate: element['ToDate'] == null
                ? DateTime.now()
                : element['ToDate'] as DateTime,
            price: element['Price'],
            boatName: element['BoatName'],
            paymentType: element['PaymentType'],
          ));
          // jsonDecode(element).forEach((json) => {
          //       print(json)
          //       // lstors.add(Order(
          //       //   boatId: json['BoatId'],
          //       //   bookingDate: json['BookingDate'] as DateTime,
          //       //   fromDate: json['FromDate'] as DateTime,
          //       //   toDate: json['ToDate'] as DateTime,
          //       //   price: json['Price'],
          //       //   paymentType: json['PaymentType'],
          //       // ))
          //     });
        }

        return lstors;
      } else {
        return List.empty(growable: true);
      }
    } catch (e) {
      print(e.toString());
    }
    return List.empty(growable: true);
  }

  Future<String> changePayment(String userToken, String data) async {
    try {
      Dio dio = Dio();

      var response = await dio.put("${dotenv.env['API_URL']!}orders",
          data: data,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.acceptHeader: "*/*",
            HttpHeaders.authorizationHeader: userToken
          }, contentType: "application/json", followRedirects: false));

      if (response.data["code"] == 200) {
        var mess = response.data["msg"];

        return mess;
      } else {
        return "Error From server";
      }
    } catch (e) {
      print(e.toString());
    }
    return "Error From server";
  }
}
