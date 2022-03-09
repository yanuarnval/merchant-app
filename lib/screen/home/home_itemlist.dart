import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:merchant_app/model/product_model.dart';
import 'package:merchant_app/screen/edit/edit_page.dart';

import '../../shared/colors_value.dart';

class HomeItemlist extends StatefulWidget {
  final ProductModel products;
  final index;

  const HomeItemlist({Key? key, required this.products, required this.index})
      : super(key: key);

  @override
  State<HomeItemlist> createState() => _HomeItemlistState();
}

class _HomeItemlistState extends State<HomeItemlist> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 166,
        margin: const EdgeInsets.only(top: 39, left: 20, right: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withOpacity(0.02)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  spreadRadius: -10,
                  blurRadius: 30,
                  offset: const Offset(14, -6))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16)),
              child: Image.network(
                widget.products.imagesModel,
                width: 137,
                height: 166,
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.products.name.substring(0, 12) + '..',
                      style: GoogleFonts.workSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 25,
                          color: Color(0xff24243F)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      (widget.products.description.toString().length > 100)
                          ? widget.products.description.substring(0, 100) + '..'
                          : widget.products.description,
                      style: TextStyle(
                          fontSize: 12, color: Colors.black.withOpacity(0.3)),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          NumberFormat.currency(
                                  locale: 'IDR', symbol: 'Rp', decimalDigits: 0)
                              .format(widget.products.price),
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: ColorsWeplant.colorPrimary,
                              fontSize: 14),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext c) => EditPage(
                                          productModel: widget.products.id,
                                        )));
                          },
                          child: Container(
                              width: 71,
                              height: 27,
                              decoration: BoxDecoration(
                                  color: ColorsWeplant.colorPrimary,
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Center(
                                child: Text(
                                  'Edit',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
