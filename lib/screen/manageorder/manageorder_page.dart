import 'package:flutter/material.dart';

class ManageOrder extends StatefulWidget {
  const ManageOrder({Key? key}) : super(key: key);

  @override
  _ManageOrderState createState() => _ManageOrderState();
}

class _ManageOrderState extends State<ManageOrder> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:  Center(
        child: Text(
          'Empety Order',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
      ),
    );
  }
}
