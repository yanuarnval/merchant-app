import 'dart:convert';
import 'dart:io';

import 'package:merchant_app/model/user_model.dart';
import 'package:merchant_app/shared/url.dart';
import 'package:http/http.dart' as http;

class UserApi {
  final url = Url.url_host;

  Future<UserModel> PostLogin(String email, String password) async {
    final urlLogin = url + "/auth/merchant";
    final request = await http.post(Uri.parse(urlLogin),
        body: jsonEncode(
          {
            "email": email,
            "password": password,
          },
        ));
    Map<String, dynamic> body = jsonDecode(request.body);
    print(body);
    if (request.statusCode == 200) {
      return UserModel(body['data']['id'], body['data']['token']);
    } else {
      throw (request.statusCode.toString());
    }
  }

  Future<Map<String, dynamic>> getMerchantById(String id,String token) async {
    final urlLogin = url + "/merchants/$id";
    final request = await http.get(
      Uri.parse(urlLogin),
      headers: {
        "Authorization":"Bearer "+token
      }
    );
    Map<String, dynamic> body = jsonDecode(request.body);
    if (request.statusCode == 200) {
      return body;
    } else {
      throw (body);
    }
  }

  Future<Map<String, dynamic>> userRegister(
      String email,
      String name,
      String password,
      String phone,
      String addres,
      String city,
      String province,
      String postalCode,
      File img) async {
    final urlReg = url + '/merchants';
    final request = http.MultipartRequest('POST', Uri.parse(urlReg));
    final map = {
      "email": email,
      "password": password,
      "name": name,
      "phone": phone,
      "addresss": addres,
      "city": city,
      "province": province,
      "postal_code": postalCode,
    };
    request.fields.addAll(map);
    request.files.add(http.MultipartFile('image',
        File(img.path).readAsBytes().asStream(), File(img.path).lengthSync(),
        filename: img.path.split('/').last));
    final response = await request.send();
    final imgLink = await http.Response.fromStream(response);
    final body = jsonDecode(imgLink.body);
    if (response.statusCode == 200) {
      return body;
    } else {
      print(body);
      final e = response.statusCode;
      throw HttpException('$e');
    }
  }
}
