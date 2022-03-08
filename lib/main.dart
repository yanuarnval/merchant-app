import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:merchant_app/screen/splash_page.dart';
import 'package:merchant_app/shared/theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: WeplantTheme.Light(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SplashPage(),
      ),
    );
  }
}
