import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merchant_app/screen/shared/colors_value.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 40.0,right: 40.0,top: 10),
          child: Column(
            children: [
              Image.asset('assets/login_img.png'),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: TextFormField(
                  cursorColor: ColorsWeplant.colorPrimary,
                  style: GoogleFonts.poppins(color: Colors.black, fontSize: 16),
                  validator: (value) {},
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: ColorsWeplant.colorTextfield,
                    filled: true,
                    hintText: "Email",
                    hintStyle: GoogleFonts.poppins(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
