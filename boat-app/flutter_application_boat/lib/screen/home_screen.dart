import 'package:flutter/material.dart';
import 'package:flutter_application_boat/models/cate_model.dart';

import '../data_source/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String id = 'home_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: const Text("123Home"),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

getAllCate() async {
  CategoryBoat? cb = null;
  return await ApiService().getAllCate().then((value) {
    cb = value;
  });
}

class _HomeScreenState extends State<HomeScreen> {
  CategoryBoat? cb;
  @override
  void initState() {
    cb = getAllCate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
