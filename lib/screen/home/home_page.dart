import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:merchant_app/bloc/event/products_event.dart';
import 'package:merchant_app/bloc/products_bloc.dart';
import 'package:merchant_app/bloc/state/products_state.dart';
import 'package:merchant_app/screen/home/add_page.dart';
import 'package:merchant_app/screen/home/home_itemlist.dart';
import 'package:merchant_app/shared/colors_value.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ProductsBloc>(
        create: (_) => ProductsBloc(),
        child: SafeArea(
          child: BlocBuilder<ProductsBloc, ProductsState>(
              builder: (context, state) {
            if (state is InitialProductsState) {
              context.read<ProductsBloc>().add(Getproducts());
            }
            if (state is LoadingProductsState) {
              return const Center(
                child: CircularProgressIndicator(
                  color: ColorsWeplant.colorPrimary,
                ),
              );
            }

            if (state is SuccesProductstate) {
              return Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 21.0, right: 21, top: 14),
                    child: Row(
                      children: [
                        Text(
                          'My Product',
                          style: GoogleFonts.workSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 28,
                              color: Colors.black),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext c) =>
                                        const AddPage()));
                          },
                          child: const Text(
                            'Add new product',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: ColorsWeplant.colorPrimary),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                        itemCount: state.produts.length,
                        itemBuilder: (BuildContext c, int i) {
                          return HomeItemlist(
                            products: state.produts[i],
                            index: i,
                          );
                        }),
                  ),
                  const SizedBox(
                    height: 76,
                  )
                ],
              );
            }
            return Center(
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext c) => const AddPage()));
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
            );
          }),
        ),
      ),
    );
  }
}
