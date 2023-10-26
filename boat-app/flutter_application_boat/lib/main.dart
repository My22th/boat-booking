import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_boat/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'models/ui.dart';
import 'screen/checkout/checkout_screen.dart';
import 'screen/home/home_screen.dart';
import 'screen/home/widget/shopping_cart_screen.dart';
import 'screen/login/login_screen.dart';
import 'screen/product/product_detail_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: "lib/.env");
  HttpOverrides.global = new MyHttpOverrides();

  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => false;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UI()),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => SelectedDate()),
      ],
      child: MaterialApp(
        initialRoute: LoginScreen.id,
        routes: {
          HomeScreen.id: (context) => const HomeScreen(),
          LoginScreen.id: (context) => const LoginScreen(),
          ShoppingCartPage.id: (context) => ShoppingCartPage(),
          CheckOutScreen.id: (context) => const CheckOutScreen(),
          ProductDetailPage.id: (context) => const ProductDetailPage(
                cate: null,
              )
          // ProductScreen.id: (context) =>const ProductScreen(),
        },
      ),
    );
  }
}
