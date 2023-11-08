import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_boat/screen/login/login_screen.dart';
import 'package:provider/provider.dart';

import '../../../models/ui.dart';

class BodyProfile extends StatefulWidget {
  const BodyProfile({Key? key}) : super(key: key);

  @override
  _BodyProfileState createState() => _BodyProfileState();
}

class _BodyProfileState extends State<BodyProfile> {
  int statusCurrentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Consumer<UI>(builder: (context, ui, child) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        width: width,
        height: height,
        child: Column(
          children: [
            topProfilePicAndName(width, height, ui.account!.photoUrl,
                ui.account!.displayName, ui.account!.email),
            const SizedBox(
              height: 40,
            ),
            middleStatusListView(width, height),
            const SizedBox(
              height: 30,
            ),
            middleDashboard(width, height),
            bottomSection(width, height)
          ],
        ),
      );
    });
  }

  // Top Profile Photo And Name Components
  topProfilePicAndName(width, height, url, name, email) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(url),
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(email),
              Text(
                name,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.edit_outlined,
                color: Colors.grey,
              ))
        ],
      ),
    );
  }

  // Middle Status List View Components
  middleStatusListView(width, height) {
    return Container(
      width: width,
      height: height / 9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "My Status",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  fontSize: 15),
            ),
          ),
          const SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }

  // Middle Dashboard ListTile Components
  middleDashboard(width, height) {
    return Container(
        width: width,
        height: height / 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "    Dashboard",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  fontSize: 15),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: 80,
              height: 30,
              margin: EdgeInsets.only(left: 13),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blue[700],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "  2 New",
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.w500),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black87,
                    size: 15,
                  )
                ],
              ),
            )
          ],
        ));
  }

  bottomSection(width, height) {
    return Container(
      width: width,
      height: 52,
      child: Row(
        children: [
          Text(
            "    Log Out",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.red[500],
                fontSize: 18),
          ),
          IconButton(
              onPressed: () async {
                FirebaseAuth.instance.signOut();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (contexts) => const LoginScreen()));
              },
              icon: Icon(
                Icons.logout,
                color: Colors.black87,
                size: 35,
              )),
        ],
      ),
    );
  }
  // My Account Section Components
}
