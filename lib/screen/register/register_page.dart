import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:merchant_app/netwotrk/user_api.dart';
import 'package:merchant_app/screen/mainScreen/mainScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/colors_value.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({Key? key}) : super(key: key);

  @override
  _RegisterpageState createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  File? image;
  final _fullname = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _postalCode = TextEditingController();
  final _province = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _fullname.dispose();
    _email.dispose();
    _password.dispose();
    _phone.dispose();
    _address.dispose();
    _city.dispose();
    _postalCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(left: 36),
        child: ElevatedButton(
          onPressed: () async {
            SharedPreferences pref = await SharedPreferences.getInstance();
            CollectionReference users =
                FirebaseFirestore.instance.collection('users');
            await UserApi()
                .userRegister(
                    _email.text,
                    _fullname.text,
                    _password.text,
                    _phone.text,
                    _address.text,
                    _city.text,
                    _province.text,
                    _postalCode.text,
                    image!)
                .then((user) async {
              final idMerchant = user['data']['id'];
              final token = user['data']['token'];
              print(token + "        " + idMerchant);

              final userById =
                  await UserApi().getMerchantById(idMerchant, token);
              //add user to firestore
              await users.add({
                'email': userById['data']['email'],
                'name': userById['data']['name'],
                'photourl': userById['data']['main_image']['url'],
                'phone': userById['data']['phone'],
                'chatrooms': []
              }).then((value) {
                if (token.isNotEmpty) {
                  pref.setString('token', token);
                  pref.setString('id', token);
                  pref.setString('uid', value.id);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext c) => const MainScreen()));
                }
              });
            });
          },
          child: const Text(
            'Register',
          ),
        ),
      ),
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Register',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 30),
                ),
                Center(
                  child: (image != null)
                      ? ClipOval(
                          child: Image.file(
                            image!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: ((builder) => bottomSheet()),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              color: Colors.grey.shade300,
                            ),
                            child: const Center(
                                child: Text(
                              'click to upload image',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            )),
                          ),
                        ),
                ),
                const SizedBox(
                  height: 17,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: TextFormField(
                    cursorColor: ColorsWeplant.colorPrimary,
                    controller: _fullname,
                    style:
                        GoogleFonts.poppins(color: Colors.black, fontSize: 16),
                    validator: (value) {},
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: ColorsWeplant.colorTextfield,
                      filled: true,
                      hintText: "Fullname",
                      hintStyle: GoogleFonts.poppins(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: TextFormField(
                    cursorColor: ColorsWeplant.colorPrimary,
                    controller: _email,
                    style:
                        GoogleFonts.poppins(color: Colors.black, fontSize: 16),
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
                const SizedBox(
                  height: 16,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: TextFormField(
                    obscureText: true,
                    cursorColor: ColorsWeplant.colorPrimary,
                    controller: _password,
                    style:
                        GoogleFonts.poppins(color: Colors.black, fontSize: 16),
                    validator: (value) {},
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: ColorsWeplant.colorTextfield,
                      filled: true,
                      hintText: "password",
                      hintStyle: GoogleFonts.poppins(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: TextFormField(
                    controller: _phone,
                    keyboardType: TextInputType.number,
                    cursorColor: ColorsWeplant.colorPrimary,
                    style:
                        GoogleFonts.poppins(color: Colors.black, fontSize: 16),
                    validator: (value) {},
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: ColorsWeplant.colorTextfield,
                      filled: true,
                      hintText: "Phone",
                      hintStyle: GoogleFonts.poppins(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: TextFormField(
                    controller: _address,
                    keyboardType: TextInputType.number,
                    cursorColor: ColorsWeplant.colorPrimary,
                    style:
                        GoogleFonts.poppins(color: Colors.black, fontSize: 16),
                    validator: (value) {},
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: ColorsWeplant.colorTextfield,
                      filled: true,
                      hintText: "Address",
                      hintStyle: GoogleFonts.poppins(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: TextFormField(
                    controller: _city,
                    keyboardType: TextInputType.number,
                    cursorColor: ColorsWeplant.colorPrimary,
                    style:
                        GoogleFonts.poppins(color: Colors.black, fontSize: 16),
                    validator: (value) {},
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: ColorsWeplant.colorTextfield,
                      filled: true,
                      hintText: "City",
                      hintStyle: GoogleFonts.poppins(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: TextFormField(
                    controller: _postalCode,
                    keyboardType: TextInputType.number,
                    cursorColor: ColorsWeplant.colorPrimary,
                    style:
                        GoogleFonts.poppins(color: Colors.black, fontSize: 16),
                    validator: (value) {},
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: ColorsWeplant.colorTextfield,
                      filled: true,
                      hintText: "Postal Code",
                      hintStyle: GoogleFonts.poppins(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: TextFormField(
                    controller: _province,
                    keyboardType: TextInputType.number,
                    cursorColor: ColorsWeplant.colorPrimary,
                    style:
                        GoogleFonts.poppins(color: Colors.black, fontSize: 16),
                    validator: (value) {},
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: ColorsWeplant.colorTextfield,
                      filled: true,
                      hintText: "Province",
                      hintStyle: GoogleFonts.poppins(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: 'By signing you agree to our ',
                          style: GoogleFonts.poppins(
                              color: ColorsWeplant.colorPrimary)),
                      TextSpan(
                          text: 'Term of use ',
                          style: GoogleFonts.poppins(color: Colors.grey)),
                      TextSpan(
                          text: 'and ',
                          style: GoogleFonts.poppins(
                              color: ColorsWeplant.colorPrimary)),
                      TextSpan(
                          text: 'privacy notice',
                          style: GoogleFonts.poppins(color: Colors.grey)),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.14,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            'Choose Profile Photo',
            style: GoogleFonts.manrope(
              textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton.icon(
                  onPressed: () => pickImage(ImageSource.camera, context),
                  icon: const Icon(
                    Icons.camera,
                    color: Colors.black,
                  ),
                  label: Text(
                    'Camera',
                    style: GoogleFonts.manrope(
                      textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  )),
              TextButton.icon(
                  onPressed: () => pickImage(ImageSource.gallery, context),
                  icon: Icon(
                    Icons.image,
                    color: Colors.black,
                  ),
                  label: Text(
                    'Gallery',
                    style: GoogleFonts.manrope(
                      textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Future pickImage(ImageSource source, BuildContext c) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
      print(this.image);
      Navigator.pop(c);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}
