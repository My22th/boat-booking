import 'package:flutter/material.dart';
import 'package:flutter_application_boat/models/ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../components/components.dart';

class LayerOne extends StatelessWidget {
  bool isChecked = false;
  UI? uis;
  LayerOne(UI ui, {super.key}) {
    uis = ui;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
        child: Stack(children: <Widget>[
      Positioned(
          top: 20,
          left: 20,
          child: ScreenTitle(
            color: uis!.isDark ? Colors.white : Colors.black,
            title: "Login",
          )),
      Positioned(
        left: 59,
        top: 99,
        child: Text(
          'Username',
          style: TextStyle(
              fontFamily: 'Poppins-Medium',
              fontSize: 22,
              color: uis!.isDark ? Colors.white70 : Colors.black87,
              fontWeight: FontWeight.w500),
        ),
      ),
      Positioned(
          left: 59,
          top: 129,
          child: Container(
            width: 310,
            child: TextField(
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'Enter User ID or Email',
                hintStyle: TextStyle(
                    color: uis!.isDark ? Colors.white38 : Colors.black38),
              ),
            ),
          )),
      Positioned(
        left: 59,
        top: 199,
        child: Text(
          'Password',
          style: TextStyle(
              fontFamily: 'Poppins-Medium',
              fontSize: 22,
              color: uis!.isDark ? Colors.white70 : Colors.black87,
              fontWeight: FontWeight.w500),
        ),
      ),
      Positioned(
          left: 59,
          top: 229,
          child: Container(
            width: 310,
            child: TextField(
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'Enter Password',
                hintStyle: TextStyle(
                    color: uis!.isDark ? Colors.white38 : Colors.black38),
              ),
            ),
          )),
      Positioned(
          right: 20,
          top: 280,
          child: Text(
            'Forgot Password',
            style: TextStyle(
                color: uis!.isDark
                    ? Color.fromARGB(179, 189, 236, 156)
                    : Color.fromARGB(221, 135, 67, 67),
                fontSize: 14,
                fontFamily: 'Poppins-Medium',
                fontWeight: FontWeight.w600),
          )),
      Positioned(
          left: 46,
          top: 331,
          child: Checkbox(
            checkColor: Colors.black,
            activeColor: Colors.green,
            value: isChecked,
            onChanged: (bool? value) {
              isChecked = value!;
            },
          )),
      Positioned(
          left: 83,
          top: 345,
          child: Text(
            'Remember Me',
            style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
                fontFamily: 'Poppins-Medium',
                fontWeight: FontWeight.w500),
          )),
      Positioned(
          top: 335,
          right: 60,
          child: Container(
            width: 99,
            height: 35,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Text(
                'Sign In',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Poppins-Medium',
                    fontWeight: FontWeight.w400),
              ),
            ),
          )),
      Positioned(
          top: 432,
          left: 59,
          child: Container(
            height: 0.5,
            width: 310,
            color: Colors.black54,
          )),
      Positioned(
        top: 500,
        left: 80,
        right: 80,
        child: Center(
          child: Container(
              decoration: BoxDecoration(border: Border.all(width: 1)),
              child: Row(
                children: [
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.google,
                      size: 30,
                      color: Colors.blue[300],
                    ),
                    onPressed: () {
                      _handleSignIn();
                    },
                  ),
                  Container(
                      padding: EdgeInsets.all(0),
                      child: Text("or Sign in With Google"))
                ],
              )),
        ),
      )
    ]));
  }
}

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);
Future<void> _handleSignIn() async {
  try {
    await _googleSignIn
        .signIn()
        .then((value) => print("Google Value" + value.toString()));
  } catch (error) {
    print(error);
  }
}
