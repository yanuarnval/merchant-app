import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:merchant_app/model/details_model.dart';
import 'package:merchant_app/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../netwotrk/products.dart';
import '../../shared/colors_value.dart';
import '../mainScreen/mainScreen.dart';

class EditPage extends StatefulWidget {
  final String productModel;

  const EditPage({Key? key, required this.productModel}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  File? img1;
  File? img2;
  File? img3;
  final name = TextEditingController();
  final des = TextEditingController();
  final price = TextEditingController();
  final stock = TextEditingController();
  bool _isloading = true;

  Widget bottomSheet(int i) {
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
                  onPressed: () => pickImage(ImageSource.camera, context, i),
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
                  onPressed: () => pickImage(ImageSource.gallery, context, i),
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

  Future pickImage(ImageSource source, BuildContext c, int i) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      if (i == 0) {
        setState(() => img1 = imageTemporary);
      }
      if (i == 1) {
        setState(() => img2 = imageTemporary);
      }
      if (i == 2) {
        setState(() => img3 = imageTemporary);
      }
      ;
      Navigator.pop(c);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  late DetailsModel detailsModel;

  @override
  void initState() {
    // TODO: implement initState
    _getproductId(widget.productModel);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    name.dispose();
    des.dispose();
    price.dispose();
    stock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(left: 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: () async {
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  final token = sp.getString('token').toString();
                  final yes = await Products()
                      .deleteProduct(widget.productModel, token);
                  if (yes) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext c) => const MainScreen()));
                  }
                },
                child: const Text('Delete Product')),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences sp = await SharedPreferences.getInstance();
                final token = sp.getString('token').toString();
                final yes = await Products().updateProducts(
                  widget.productModel,
                  name.text,
                  des.text,
                  int.parse(price.text),
                  int.parse(stock.text),
                  (img1) != null ? img1 : false,
                  (img1) != null ? img1 : false,
                  (img1) != null ? img1 : false,
                  token,
                  detailsModel.images!,
                );
                if (yes) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext c) => const MainScreen()));
                }
              },
              child: const Text(
                'Update Product',
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: Text(
          'New Product',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
        ),
      ),
      body: (_isloading)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Products Name',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, color: Colors.black)),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: TextFormField(
                        controller: name,
                        cursorColor: ColorsWeplant.colorPrimary,
                        style: GoogleFonts.poppins(
                            color: Colors.black, fontSize: 16),
                        validator: (value) {},
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: ColorsWeplant.colorTextfield,
                          filled: true,
                          hintText: "Products Name",
                          hintStyle: GoogleFonts.poppins(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text('Description',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, color: Colors.black)),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: TextFormField(
                        controller: des,
                        cursorColor: ColorsWeplant.colorPrimary,
                        style: GoogleFonts.poppins(
                            color: Colors.black, fontSize: 16),
                        validator: (value) {},
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: ColorsWeplant.colorTextfield,
                          filled: true,
                          hintText: "Description",
                          hintStyle: GoogleFonts.poppins(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text('Price',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, color: Colors.black)),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: TextFormField(
                        controller: price,
                        cursorColor: ColorsWeplant.colorPrimary,
                        style: GoogleFonts.poppins(
                            color: Colors.black, fontSize: 16),
                        validator: (value) {},
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: ColorsWeplant.colorTextfield,
                          filled: true,
                          hintText: "Price",
                          hintStyle: GoogleFonts.poppins(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text('Stock',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, color: Colors.black)),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: TextFormField(
                        controller: stock,
                        cursorColor: ColorsWeplant.colorPrimary,
                        style: GoogleFonts.poppins(
                            color: Colors.black, fontSize: 16),
                        validator: (value) {},
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: ColorsWeplant.colorTextfield,
                          filled: true,
                          hintText: "Stock",
                          hintStyle: GoogleFonts.poppins(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text('Image 1',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, color: Colors.black)),
                    (img1 != null)
                        ? SizedBox(
                            child: Image.file(
                              img1!,
                              width: 220,
                              height: 220,
                              fit: BoxFit.cover,
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: ((builder) => bottomSheet(0)),
                              );
                            },
                            child: Container(
                              width: 220,
                              height: 220,
                              color: Colors.grey.shade300,
                              child: Stack(
                                children: [
                                  const Center(
                                    child: Icon(
                                      Icons.add,
                                      color: ColorsWeplant.colorPrimary,
                                      size: 80,
                                    ),
                                  ),
                                  Image.network(detailsModel.main_image['url'])
                                ],
                              ),
                            ),
                          ),
                    Text('Image 2',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, color: Colors.black)),
                    (img2 != null)
                        ? SizedBox(
                            child: Image.file(
                              img2!,
                              width: 220,
                              height: 220,
                              fit: BoxFit.cover,
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: ((builder) => bottomSheet(1)),
                              );
                            },
                            child: Container(
                              width: 220,
                              height: 220,
                              color: Colors.grey.shade300,
                              child: Stack(
                                children: [
                                  const Center(
                                    child: Icon(
                                      Icons.add,
                                      color: ColorsWeplant.colorPrimary,
                                      size: 80,
                                    ),
                                  ),
                                  Image.network(detailsModel.images![1]['url'])
                                ],
                              ),
                            ),
                          ),
                    Text('Image 3',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, color: Colors.black)),
                    (img3 != null)
                        ? SizedBox(
                            child: Image.file(
                              img3!,
                              width: 220,
                              height: 220,
                              fit: BoxFit.cover,
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: ((builder) => bottomSheet(2)),
                              );
                            },
                            child: Container(
                              width: 220,
                              height: 220,
                              color: Colors.grey.shade300,
                              child: Stack(
                                children: [
                                  const Center(
                                    child: Icon(
                                      Icons.add,
                                      color: ColorsWeplant.colorPrimary,
                                      size: 80,
                                    ),
                                  ),
                                  Image.network(detailsModel.images![2]['url'])
                                ],
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 120,
                    )
                  ],
                ),
              ),
            ),
    );
  }

  void _getproductId(String id) async {
    final produGet = await Products().getProductById(id);
    detailsModel = produGet;
    name.text = produGet.name;
    des.text = produGet.description;
    stock.text = produGet.stok.toString();
    price.text = produGet.price.toString();
    setState(() {
      _isloading = false;
    });
  }
}
