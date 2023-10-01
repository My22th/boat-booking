import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_boat/firebase_options.dart';
import 'package:provider/provider.dart';

import 'models/ui.dart';
import 'screen/home_screen.dart';
import 'screen/login/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UI()),
      ],
      child: MaterialApp(
        initialRoute: LoginScreen.id,
        routes: {
          HomeScreen.id: (context) => const HomeScreen(),
          LoginScreen.id: (context) => const LoginScreen(),
          // ProductScreen.id: (context) =>const ProductScreen(),
        },
      ),
    );
  }
}
