import 'dart:convert';
import 'dart:io';

import 'package:merchant_app/model/product_model.dart';
import 'package:merchant_app/shared/url.dart';
import 'package:http/http.dart' as http;

import '../model/details_model.dart';

class Products {
  final url = Url.url_host;

  Future<bool> deleteProduct(String productId, String token) async {
    final urlId = url + '/products/$productId';
    Map<String, dynamic> result;

    final response = await http.delete(
      Uri.parse(urlId),
      headers: {'Authorization': 'Bearer ' + token},
    );
    result = jsonDecode(response.body);
    print(result);
    if (response.statusCode == 200) {
      return true;
    } else {
      final e = response.statusCode;
      throw HttpException('error code $result');
    }
  }

  Future<DetailsModel> getProductById(String idProduct) async {
    final urlId = url + '/products/$idProduct';
    print(idProduct);
    Map<String, dynamic> result, data;

    final response = await http.get(Uri.parse(urlId));
    result = jsonDecode(response.body);
    if (response.statusCode == 200) {
      data = result['data'];
      return DetailsModel.fromJson(data);
    } else {
      final e = response.statusCode;
      throw HttpException('error code $result');
    }
  }

  Future<bool> updateProducts(
    String productId,
    String name,
    String des,
    int prince,
    int stock,
    img1,
    img2,
    img3,
    token,
    List images,
  ) async {
    final urlGetproducts = url + '/products/$productId';
    final x = await http.put(Uri.parse(urlGetproducts),
        headers: {'Authorization': 'Bearer ' + token},
        body: jsonEncode({
          "name": name,
          'description': des,
          'price': prince,
          'stock': stock
        }));
    if (img1) {
      _updateMainImg(productId, token, img1);
    }

    if (img2 && img3) {
      //delete images
      for (int i = 0; i < 3; i++) {
        final urlDelimg = url + '/products/$productId/${images[i]['id']}';
        await http.delete(
          Uri.parse(urlDelimg),
          headers: {'Authorization': 'Bearer ' + token},
        );
      }
      //images update
      final urlIms = url + '/products/$productId/images';
      final upadateIms = http.MultipartRequest('POST', Uri.parse(urlIms));
      upadateIms.headers.addAll({'Authorization': 'Bearer ' + token});
      upadateIms.files.add(http.MultipartFile.fromBytes(
          'images', (await img1.readAsBytes()),
          filename: img1.path.split('/').last));
      upadateIms.files.add(http.MultipartFile.fromBytes(
          'images', (await img2.readAsBytes()),
          filename: img2.path.split('/').last));
      upadateIms.files.add(http.MultipartFile.fromBytes(
          'images', (await img3.readAsBytes()),
          filename: img3.path.split('/').last));
      final clear = await upadateIms.send();
      if (clear.statusCode == 200) {
        return true;
      } else {
        throw (clear.statusCode.toString());
      }
    }

    if (x.statusCode == 200) {
      return true;
    } else {
      print(jsonDecode(x.body).toString());
      throw (x.statusCode.toString());
    }
  }

  Future<List<ProductModel>> getProducts(
      String token, String merchantId) async {
    final urlGetproducts = url + '/merchants/$merchantId';
    final request = await http.get(
      Uri.parse(urlGetproducts),
      headers: {'Authorization': 'Bearer ' + token},
    );
    Map<String, dynamic> body = jsonDecode(request.body);
    print(body);
    if (request.statusCode == 200 && body['data']['products'] != null) {
      List products = body['data']['products'];
      List<ProductModel> model = [];
      for (int i = 0; i < products.length; i++) {
        model.add(ProductModel.fromJson(products[i]));
      }
      return model;
    } else {
      throw (body);
    }
  }

  Future<bool> postProducts(String id, String name, String des, String prince,
      String stock, File img1, File img2, File img3, token) async {
    final urlLogin = url + "/products";
    final request = http.MultipartRequest('POST', Uri.parse(urlLogin));
    print(id);
    request.fields.addAll(<String, String>{
      "merchant_id": id,
      "name": name,
      "description": des,
      "price": prince,
      "stock": stock,
    });
    request.headers.addAll({'Authorization': 'Bearer ' + token});
    request.files.add(http.MultipartFile.fromBytes(
        'image', (await img1.readAsBytes()),
        filename: img1.path.split('/').last));
    //img2
    request.files.add(http.MultipartFile.fromBytes(
        'images', (await img1.readAsBytes()),
        filename: img1.path.split('/').last));
    //img2
    request.files.add(http.MultipartFile.fromBytes(
        'images', (await img2.readAsBytes()),
        filename: img2.path.split('/').last));
    //img3
    request.files.add(http.MultipartFile.fromBytes(
        'images', (await img3.readAsBytes()),
        filename: img3.path.split('/').last));
    //set
    final response = await request.send();
    final imgLink = await http.Response.fromStream(response);
    final body = jsonDecode(imgLink.body);
    print(body);
    if (response.statusCode == 200) {
      return true;
    } else {
      print(body);
      throw (body);
    }
  }

  Future _updateMainImg(String productId, String token, File img1) async {
    final urlMain = url + '/products/$productId/image';
    final upadateMain = http.MultipartRequest('PATCH', Uri.parse(urlMain));
    upadateMain.headers.addAll({'Authorization': 'Bearer ' + token});
    upadateMain.files.add(http.MultipartFile.fromBytes(
        'image', (await img1.readAsBytes()),
        filename: img1.path.split('/').last));
    await upadateMain.send();
  }
}
