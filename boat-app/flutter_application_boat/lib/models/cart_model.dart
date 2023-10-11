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
