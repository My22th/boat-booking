import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_boat/firebase_options.dart';
import 'package:flutter_application_boat/models/ui.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../../data_source/api_service.dart';
import '../../config.dart';
import '../../home/home_screen.dart';

class LayerThree extends StatefulWidget {
  const LayerThree({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LayerThree();
  }
}

class _LayerThree extends State<LayerThree> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late GoogleSignInAccount _userObj;

  bool isChecked = false;

  checklogin(String token) async {
    var jwtoken = "";
    await ApiService().fetchJWTTokenUser(token).then((value) {
      jwtoken = value;
    });
    return jwtoken;
  }

  listenlogin() {
    FirebaseAuth.instance.idTokenChanges().listen((User? user) {
      initfirebase(user);
    });
    FirebaseAuth.instance.userChanges().listen((User? user) {
      initfirebase(user);
    });
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      initfirebase(user);
    });
  }

  initfirebase(User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      FirebaseAuth.instance.currentUser!.getIdToken().then((value) {
        String jwt = checklogin(value.toString()).toString();
        if (jwt != "") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
      });

      print('User is signed in!');
    }
  }

  @override
  void initState() {
    super.initState();

    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Widget build(BuildContext context) {
    var ctx = context;
    return Consumer<UI>(builder: (context, ui, child) {
      return SizedBox(
        height: 584,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            const Positioned(
              left: 59,
              top: 99,
              child: Text(
                'Username',
                style: TextStyle(
                    fontFamily: 'Poppins-Medium',
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const Positioned(
                left: 59,
                top: 129,
                child: SizedBox(
                  width: 310,
                  child: TextField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Enter User ID or Email',
                      hintStyle: TextStyle(color: hintText),
                    ),
                  ),
                )),
            const Positioned(
              left: 59,
              top: 199,
              child: Text(
                'Password',
                style: TextStyle(
                    fontFamily: 'Poppins-Medium',
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const Positioned(
                left: 59,
                top: 229,
                child: SizedBox(
                  width: 310,
                  child: TextField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Enter Password',
                      hintStyle: TextStyle(color: hintText),
                    ),
                  ),
                )),
            const Positioned(
                right: 60,
                top: 296,
                child: Text(
                  'Forgot Password',
                  style: TextStyle(
                      color: forgotPasswordText,
                      fontSize: 16,
                      fontFamily: 'Poppins-Medium',
                      fontWeight: FontWeight.w600),
                )),
            Positioned(
                left: 46,
                top: 361,
                child: Checkbox(
                  checkColor: Colors.black,
                  activeColor: checkbox,
                  value: isChecked,
                  onChanged: (bool? value) {
                    isChecked = value!;
                  },
                )),
            const Positioned(
                left: 87,
                top: 375,
                child: Text(
                  'Remember Me',
                  style: TextStyle(
                      color: forgotPasswordText,
                      fontSize: 16,
                      fontFamily: 'Poppins-Medium',
                      fontWeight: FontWeight.w500),
                )),
            Positioned(
                top: 365,
                right: 60,
                child: Container(
                  width: 99,
                  height: 35,
                  decoration: const BoxDecoration(
                    color: signInButton,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(top: 6.0),
                    child: Text(
                      'Sign In',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
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
                  color: inputBorder,
                )),
            Positioned(
                top: 482,
                left: 120,
                right: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'or login by',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins-Regular',
                          color: hintText),
                    ),
                    Container(
                      width: 59,
                      height: 48,
                      decoration: BoxDecoration(
                          border: Border.all(color: signInBox),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20))),
                      child: IconButton(
                          onPressed: () async {
                            await _googleSignIn.signIn().then((value) {
                              ui.account = value;
                              value?.authentication.then((ggkey) async {
                                final credential =
                                    GoogleAuthProvider.credential(
                                        idToken: ggkey.idToken,
                                        accessToken: ggkey.accessToken);
                                await FirebaseAuth.instance
                                    .signInWithCredential(credential);

                                listenlogin();
                              });
                            });
                          },
                          icon: Image.asset('assets/images/icon_google.png')),
                    )
                  ],
                ))
          ],
        ),
      );
    });
  }
}
