import 'dart:convert';

import 'package:merchant_app/model/details_model.dart';
import 'package:merchant_app/model/order_model.dart';
import 'package:merchant_app/model/product_model.dart';
import 'package:merchant_app/shared/url.dart';
import 'package:http/http.dart' as http;

class TransaksiApi {
  final url = Url.url_host;

  Future<List<OrderModel>> getTransaksi(String merchanId, String token) async {
    final urlGetTrans = url + '/merchants/$merchanId/orders';
    final request = await http.get(Uri.parse(urlGetTrans),
        headers: {"Authorization": "Bearer " + token});
    Map<String, dynamic> body = jsonDecode(request.body);

    if (request.statusCode == 200) {
      List products = body['data']['products'];
      List<OrderModel> list = [];
      print(products);
      for (int i = 0; i < products.length; i++) {
        list.add(OrderModel.fromJson(products[i]));
      }

      return list;
    } else {
      print(body);
      throw (request.statusCode.toString());
    }
  }
}
