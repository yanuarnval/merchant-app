import 'package:flutter/material.dart';
import 'package:merchant_app/screen/login/login_page.dart';
import 'package:merchant_app/screen/mainScreen/mainScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(const Duration(seconds: 3), () async {
      SharedPreferences sp = await SharedPreferences.getInstance();
      final u = sp.getString('id').toString().trim();
      final t = sp.getString('token').toString().trim();
      if (u.isNotEmpty && t.isNotEmpty) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext c) => MainScreen()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext c) => LoginPage()));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/splash.png',
          width: 120,
          height: 230,
        ),
      ),
    );
  }
}
