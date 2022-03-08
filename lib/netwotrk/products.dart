import 'dart:convert';
import 'dart:io';

import 'package:merchant_app/shared/url.dart';
import 'package:http/http.dart' as http;

class Products {
  final url = Url.url_host;

  Future<bool> postProducts(String id,String name, String des, String light, String
      water, File img1, File img2, File img3,token) async {
    final urlLogin = url + "/products";
    final request = http.MultipartRequest('POST', Uri.parse(urlLogin));
    final map = {
      "merchant_id":id,
      "name": name,
      "description": des,
      "price": '24000',
      "stock": '10',
    };
    request.fields.addAll(map);
    request.headers.addAll({'Authorization':'Bearer ' +token});
    request.files.add(http.MultipartFile('image',
        File(img1.path).readAsBytes().asStream(), File(img1.path).lengthSync(),
        filename: img1.path.split('/').last));
    //img2
    request.files.add(http.MultipartFile('images',
        File(img2.path).readAsBytes().asStream(), File(img2.path).lengthSync(),
        filename: img2.path.split('/').last));
    //img3
    request.files.add(http.MultipartFile('images',
        File(img3.path).readAsBytes().asStream(), File(img3.path).lengthSync(),
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
}
