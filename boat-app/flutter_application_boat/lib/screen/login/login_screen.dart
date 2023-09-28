import 'package:flutter/material.dart';
import 'package:flutter_application_boat/components/components.dart';
import 'package:provider/provider.dart';

import '../../models/ui.dart';
import 'layer_one.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'login_screen';

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    bool isChecked = false;
    return Consumer<UI>(builder: (context, ui, child) {
      return Scaffold(
          backgroundColor: ui.isDark ? Colors.black : Colors.white,
          body: SafeArea(
              child: Container(
                  decoration: BoxDecoration(
                    // Box decoration takes a gradient
                    gradient: LinearGradient(
                      // Where the linear gradient begins and ends
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      // Add one stop for each color. Stops should increase from 0 to 1
                      stops: getStopsColors(ui.isDark),
                      colors: getColors(ui.isDark),
                    ),
                  ),
                  child: Stack(children: <Widget>[
                    Positioned(
                        top: 0,
                        right: 0,
                        left: 0,
                        bottom: 0,
                        child: LayerOne(
                          ui,
                        )),
                    // Positioned(
                    //     top: 318, right: 0, bottom: 28, child: LayerTwo()),
                    // Positioned(
                    //     top: 320, right: 0, bottom: 48, child: LayerThree()),
                  ]))));
    });
  }
}
