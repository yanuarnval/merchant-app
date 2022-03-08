import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merchant_app/screen/home/add_page.dart';
import 'package:merchant_app/shared/colors_value.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isEmpety = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_isEmpety)
          ? Center(
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext c) =>const AddPage()));
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Add new products',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: ColorsWeplant.colorPrimary))
                      ],
                      text: 'upload your first\nproduct\n',
                      style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                  )),
            )
          : ListView.builder(itemBuilder: (BuildContext c, int i) {
              return Container();
            }),
    );
  }
}
