import 'package:flutter_application_boat/models/cate_model.dart';

class CartModel {
  late CategoryBoat cate;
  late DateTime formdate;
  late DateTime todate;

  CartModel({
    required this.cate,
    required this.formdate,
    required this.todate,
  });
}

class BookingRequest {
  int categoryId;
  DateTime fromDate;
  DateTime toDate;

  BookingRequest({
    required this.categoryId,
    required this.fromDate,
    required this.toDate,
  });
  Map<String, dynamic> toJson() => {
        'categoryId': categoryId,
        'fromDate': fromDate.toIso8601String(),
        'toDate': toDate.toIso8601String()
      };
}

class BookingRes {
  bool isErr;
  String mess;
  List<dynamic>? ids;
  BookingRes({required this.isErr, required this.mess, this.ids});
}
