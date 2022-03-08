import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:merchant_app/screen/home/home_page.dart';
import 'package:merchant_app/screen/manageorder/manageorder_page.dart';
import 'package:merchant_app/screen/profil/profile_page.dart';

import '../../shared/colors_value.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static List<Widget> pages = <Widget>[
    const HomePage(),
    const ManageOrder(),
    const ProfilPage()
  ];
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [pages[_index], _buildBottomNavigationbar(context, _index)],
      ),
    );
  }

  Positioned _buildBottomNavigationbar(BuildContext context, int value) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(50), boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, -3),
          ),
        ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: BottomNavigationBar(
              elevation: 0,
              backgroundColor: Colors.white,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedIconTheme:
                  const IconThemeData(color: ColorsWeplant.colorPrimary),
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                    label: "",
                    icon: Icon(Icons.home)),
                BottomNavigationBarItem(
                    label: "",
                    icon: Icon(Icons.history)),
                BottomNavigationBarItem(
                    label: "",
                    icon: Icon(Icons.person)),
              ],
              currentIndex: value,
              onTap: (index) {
                setState(() {
                  _index=index;
                });
              }),
        ),
      ),
    );
  }
}
