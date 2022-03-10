import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:merchant_app/bloc/event/products_event.dart';
import 'package:merchant_app/bloc/event/transaksi_event.dart';
import 'package:merchant_app/bloc/order_bloc.dart';
import 'package:merchant_app/bloc/state/products_state.dart';
import 'package:merchant_app/bloc/state/transaksi_state.dart';
import 'package:merchant_app/model/order_model.dart';

import '../../shared/colors_value.dart';

class ManageOrder extends StatefulWidget {
  const ManageOrder({Key? key}) : super(key: key);

  @override
  _ManageOrderState createState() => _ManageOrderState();
}

class _ManageOrderState extends State<ManageOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Order',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 2,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: BlocProvider<OrderBloc>(
          create: (_) => OrderBloc(),
          child: BlocListener<OrderBloc, TransaksiState>(
            listener: (context, state) {
              if (state is FailureTransaksiState) {
                print(state.msg);
              }
            },
            child: BlocBuilder<OrderBloc, TransaksiState>(
                builder: (context, state) {
              if (state is InitialTransaksiState) {
                context.read<OrderBloc>().add(GetTransaksi());
              }
              if (state is LoadingTransaksiState) {
                print('loading');
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is SuccesTransaksistate) {
                print('succes mng order');
                return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.produts.length,
                    itemBuilder: (BuildContext c, int i) {
                      return GestureDetector(
                        onTap: () {
                          _showMyDialog(state.produts[i]);
                        },
                        child: Container(
                            height: 166,
                            margin: const EdgeInsets.only(
                                top: 39, left: 20, right: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: Colors.black.withOpacity(0.02)),
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
                                    state.produts[i].imagesModel,
                                    width: 137,
                                    height: 166,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.produts[i].name
                                                  .substring(0, 12) +
                                              '..',
                                          style: GoogleFonts.workSans(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 25,
                                              color: Color(0xff24243F)),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          (state.produts[i].description
                                                      .toString()
                                                      .length >
                                                  100)
                                              ? state.produts[i].description
                                                      .substring(0, 100) +
                                                  '..'
                                              : state.produts[i].description,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black
                                                  .withOpacity(0.3)),
                                        ),
                                        const Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              NumberFormat.currency(
                                                      locale: 'IDR',
                                                      symbol: 'Rp',
                                                      decimalDigits: 0)
                                                  .format(
                                                      state.produts[i].price),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: ColorsWeplant
                                                      .colorPrimary,
                                                  fontSize: 14),
                                            ),
                                            Text(
                                                'stock: ${state.produts[i].stock.toString()}')
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )),
                      );
                    });
              }
              return const Center(
                child: Text(
                  'Empety Order',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog(OrderModel model) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Target Location',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Address: '),
                Text(
                  '${model.address['address']}',
                ),
                const Text('City: '),
                Text(
                  '${model.address['city']}',
                ),
                const Text('Province: '),
                Text(
                  '${model.address['province']}',
                ),
                const Text('Postal Code: '),
                Text(
                  '${model.address['postal_code']}',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
