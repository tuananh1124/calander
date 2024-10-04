import 'dart:convert';
import 'package:flutter_calendar/config/ngn_constant.dart';
import 'package:flutter_calendar/models/color_model.dart';
import 'package:flutter_calendar/models/login_model.dart';
import 'package:http/http.dart';

class ApiProvider {
  late Response response;
  String connErr = 'Please check your internet connection and try again';

  // GET request with error handling
  Future<Response> getConnect(String url, String token) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      return await get(Uri.parse(url), headers: headers);
    } catch (e) {
      throw e.toString();
    }
  }

  // POST request with error handling
  Future<Response> postConnect(
      String url, Map<String, dynamic> map, String token) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final uri = Uri.parse(url);
    var body = jsonEncode(map);
    try {
      return await post(
        uri,
        headers: headers,
        body: utf8.encode(body), // Sử dụng UTF-8 encoding cho body
      );
    } catch (e) {
      throw e.toString();
    }
  }

  Future<LoginModel?> login(
      String username, String password, String token) async {
    var postData = {'username': username, 'password': password};

    response = await postConnect(loginAPI, postData, token);

    var decodedBody = utf8.decode(response.bodyBytes);
    print(decodedBody);

    if (response.statusCode == statusOk) {
      var responseData = jsonDecode(decodedBody);

      var result = responseData['result'];

      LoginModel model = LoginModel.fromJson(result);

      return model;
    } else {
      print('Login API failed with status: ${response.statusCode}');
      return null;
    }
  }

  Future<ColorModel?> getColor(String token) async {
    final response = await getConnect(getColorAPI, token);

    var decodedBody = utf8.decode(response.bodyBytes);
    print(response.statusCode);

    if (response.statusCode == statusOk) {
      var responseData = jsonDecode(decodedBody);
      var result = responseData['result'];
      print(result);

      List<String> colorCodes = List<String>.from(result);

      return ColorModel.fromColorList(colorCodes);
    } else {
      print('getColor request failed with status: ${response.statusCode}');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getListOfPersonal(String token) async {
    final response = await getConnect(getListOfPersonalAPI, token);

    var decodedBody = utf8.decode(response.bodyBytes);
    print(response.statusCode);

    if (response.statusCode == statusOk) {
      var responseData = jsonDecode(decodedBody);
      var result = responseData;

      if (result is List) {
        List<Map<String, dynamic>> personalList = result
            .map<Map<String, dynamic>>(
                (item) => Map<String, dynamic>.from(item))
            .toList();

        return personalList;
      } else {
        return []; // Trả về danh sách rỗng nếu không phải danh sách
      }
    } else {
      print(
          'getListOfPersonal request failed with status: ${response.statusCode}');
      return []; // Trả về danh sách rỗng thay vì null
    }
  }
}
