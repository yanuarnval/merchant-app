import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merchant_app/screen/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/colors_value.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Text(
              'My Profile',
              style: GoogleFonts.workSans(
                  fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.3),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.width * 0.3,
                child: (true)
                    ? Container(
                        color: ColorsWeplant.colorPrimary,
                        child: const Center(
                          child: Text(
                            'Y',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 24),
                          ),
                        ),
                      )
                    : Image.network(
                        'state.photourl',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
              child: Text(
            'yanuar',
            style:
                GoogleFonts.workSans(fontWeight: FontWeight.w700, fontSize: 20),
          )),
          Center(
              child: Text(
            'yanuar1@gmail.com',
            style: GoogleFonts.workSans(color: Colors.black.withOpacity(0.3)),
          )),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 29),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 0.5,
                    blurRadius: 10)
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(40)),
                        child: SvgPicture.asset(
                          'assets/icons/profile.svg',
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        'My Account',
                        style: GoogleFonts.workSans(
                            fontSize: 18,
                            color: const Color(0xff181D27),
                            fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 18,
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.grey,
                  height: 1,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(40)),
                        child: SvgPicture.asset(
                          'assets/icons/setting.svg',
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        'Setting',
                        style: GoogleFonts.workSans(
                            fontSize: 18,
                            color: const Color(0xff181D27),
                            fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 18,
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.grey,
                  height: 1,
                ),
                GestureDetector(
                  onTap: () async {
                    SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                    await preferences.clear();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext c) =>
                            const LoginPage()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              top: 13, left: 14, bottom: 15, right: 11),
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(40)),
                          child: SvgPicture.asset(
                            'assets/icons/logout.svg',
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text(
                          'Log Out',
                          style: GoogleFonts.workSans(
                              fontSize: 18,
                              color: const Color(0xff181D27),
                              fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
