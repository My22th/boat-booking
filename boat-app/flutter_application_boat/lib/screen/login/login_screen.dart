import 'package:flutter/material.dart';

import 'layer_one.dart';
import 'layer_three.dart';
import 'layer_two.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'login_screen';

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: Image.asset('assets/images/primaryBg.png').image,
          fit: BoxFit.cover,
        )),
        child: const Stack(
          children: <Widget>[
            Positioned(
                top: 100,
                left: 59,
                child: Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 48,
                      fontFamily: 'Poppins-Medium',
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                )),
            Positioned(top: 190, right: 0, bottom: 0, child: LayerOne()),
            Positioned(top: 218, right: 0, bottom: 28, child: LayerTwo()),
            Positioned(top: 220, right: 0, bottom: 48, child: LayerThree()),
          ],
        ),
      ),
    );
  }
}
