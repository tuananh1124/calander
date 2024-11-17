import 'dart:convert';
import 'package:flutter_calendar/config/ngn_constant.dart';
import 'package:flutter_calendar/models/color_model.dart';
import 'package:flutter_calendar/models/create_event_calendar_model.dart';
import 'package:flutter_calendar/models/create_event_resource_model.dart';
import 'package:flutter_calendar/models/list_event_resource_model.dart';
import 'package:flutter_calendar/models/list_root_organization_model.dart';
import 'package:flutter_calendar/models/list_event_calendar_model.dart';
import 'package:flutter_calendar/models/list_sub_organization_model.dart';
import 'package:flutter_calendar/models/login_model.dart';
import 'package:flutter_calendar/models/type_calendar_model.dart';
import 'package:flutter_calendar/models/user_organization_model.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class ApiProvider {
  late Response response;
  String connErr = 'Please check your internet connection and try again';

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

  // DELETE request with error handling
  Future<Response> deleteConnect(String url, String token) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      return await delete(Uri.parse(url), headers: headers);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> putConnect(String url, String body, String token) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      return await put(Uri.parse(url), headers: headers, body: body);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<LoginModel?> login(
      String username, String password, String token) async {
    var postData = {'username': username, 'password': password};

    response = await postConnect(loginAPI, postData, token);
    print(response.statusCode);
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
      //print(result);

      List<String> colorCodes = List<String>.from(result);

      return ColorModel.fromColorList(colorCodes);
    } else {
      print('getColor request failed with status: ${response.statusCode}');
      return null;
    }
  }

  Future<List<TypeCalendarModel>?> getType(String token) async {
    final response = await getConnect(getTypeAPI, token);

    var decodedBody = utf8.decode(response.bodyBytes);
    print(response.statusCode);

    if (response.statusCode == statusOk) {
      var responseData = jsonDecode(decodedBody);
      var result = responseData['result'];
      // print(responseData);

      List<TypeCalendarModel> typeCalendarList = (result as List)
          .map((item) => TypeCalendarModel.fromJson(item))
          .toList();

      return typeCalendarList;
    } else {
      print('getType request failed with status: ${response.statusCode}');
      return null;
    }
  }

  Future<List<ListSubOrganizationModel>?> getListSubSearchOrganization(
      String token) async {
    final response = await getConnect(getListSubSearchOrganizationAPI, token);

    var decodedBody = utf8.decode(response.bodyBytes);
    print(response.statusCode);

    if (response.statusCode == statusOk) {
      var responseData = jsonDecode(decodedBody);
      var result = responseData['result'];

      List<ListSubOrganizationModel> subOrganizationList = (result as List)
          .map((item) => ListSubOrganizationModel.fromJson(item))
          .toList();

      return subOrganizationList;
    } else {
      print(
          'getListSubOrganization request failed with status: ${response.statusCode}');
      return null;
    }
  }

  Future<List<UserorganizationModel>?> getUserOrganization(String token) async {
    final response = await getConnect(getUserOrganizationAPI, token);

    var decodedBody = utf8.decode(response.bodyBytes);
    print(response.statusCode);

    if (response.statusCode == statusOk) {
      var responseData = jsonDecode(decodedBody);
      var result = responseData['result'];
      //print(responseData);
      if (result['users'] is List) {
        List users = result['users'];

        List<UserorganizationModel> userList = users.map((user) {
          return UserorganizationModel.fromJson(user);
        }).toList();

        return userList;
      } else {
        print('result["users"] is not a List.');
        return null;
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
      return null;
    }
  }

  Future<List<ListRootOrganizationModel>?> getListRootOrganization(
      String token) async {
    final response = await http.get(
      Uri.parse(getListRootOrganizationAPI),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    var decodedBody = utf8.decode(response.bodyBytes);
    print(response.statusCode);

    if (response.statusCode == 200) {
      var responseData = jsonDecode(decodedBody);
      var result = responseData['result'];

      List<ListRootOrganizationModel> listRootOrganization = (result as List)
          .map((item) => ListRootOrganizationModel.fromJson(item))
          .toList();

      // Đệ quy để lấy tất cả các tổ chức con
      for (var organization in listRootOrganization) {
        await _fetchSubOrganizations(organization, token);
      }

      return listRootOrganization;
    } else {
      print(
          'getListRootOrganization request failed with status: ${response.statusCode}');
      return null;
    }
  }

  Future<void> _fetchSubOrganizations(
      ListRootOrganizationModel organization, String token) async {
    if (organization.subOrganizations.isNotEmpty) {
      for (var subOrg in organization.subOrganizations) {
        await _fetchSubOrganizations(subOrg, token);
      }
    }
  }

  Future<List<ListEventcalendarModel>?> getListEveneCalendar(
      String token) async {
    try {
      final response = await getConnect(getListEveneCalendarAPI, token);
      var decodedBody = utf8.decode(response.bodyBytes);

      print(response.statusCode);

      if (response.statusCode == statusOk) {
        var responseData = jsonDecode(decodedBody);
        //print(responseData); // In ra để kiểm tra cấu trúc dữ liệu
        if (responseData is Map) {
          if (responseData.containsKey('result')) {
            var listData = responseData['result'];

            if (listData is List) {
              List<ListEventcalendarModel> modelList = listData
                  .map((item) => ListEventcalendarModel.fromJson(item))
                  .toList();
              return modelList;
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching personal list: $e');
      return null; // Trả về null trong trường hợp có lỗi
    }
  }

  Future<List<ListEventcalendarModel>?> getListOfPersonalEveneCalendar(
      String token) async {
    try {
      final response =
          await getConnect(getListOfPersonalEveneCalendarAPI, token);
      var decodedBody = utf8.decode(response.bodyBytes);

      print(response.statusCode);

      if (response.statusCode == statusOk) {
        var responseData = jsonDecode(decodedBody);
        //print(responseData); // In ra để kiểm tra cấu trúc dữ liệu
        if (responseData is Map) {
          if (responseData.containsKey('result')) {
            var listData = responseData['result'];

            if (listData is List) {
              List<ListEventcalendarModel> modelList = listData
                  .map((item) => ListEventcalendarModel.fromJson(item))
                  .toList();
              return modelList;
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching personal list: $e');
      return null; // Trả về null trong trường hợp có lỗi
    }
  }

  Future<List<ListEventResourceModel>?> getListEventResource(
      String token) async {
    try {
      final response = await getConnect(getListEventResourceAPI, token);
      var decodedBody = utf8.decode(response.bodyBytes);

      if (response.statusCode == statusOk) {
        var responseData = jsonDecode(decodedBody);

        if (responseData is Map && responseData.containsKey('result')) {
          var listData = responseData['result'];

          if (listData is List) {
            List<ListEventResourceModel> modelList = listData
                .map((item) => ListEventResourceModel.fromJson(item))
                .toList();
            return modelList;
          }
        }
      } else {
        print('Error: Unexpected status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching event resources: $e');
    }
    return null; // Return null in case of an error or unexpected response
  }

  Future<List<ListEventResourceModel>?> getListOfPersonalEventResource(
      String token) async {
    try {
      final response =
          await getConnect(getListOfPersonalEventResourceAPI, token);
      var decodedBody = utf8.decode(response.bodyBytes);

      if (response.statusCode == statusOk) {
        var responseData = jsonDecode(decodedBody);

        if (responseData is Map && responseData.containsKey('result')) {
          var listData = responseData['result'];

          if (listData is List) {
            List<ListEventResourceModel> modelList = listData
                .map((item) => ListEventResourceModel.fromJson(item))
                .toList();
            return modelList;
          }
        }
      } else {
        print('Error: Unexpected status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching event resources: $e');
    }
    return null; // Return null in case of an error or unexpected response
  }

  Future<CreateEventCalendarModel?> createEventCalendar(
      String token, CreateEventCalendarModel event) async {
    try {
      final response = await http.post(
        Uri.parse('$serverURL/website/event-calendar'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(event.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['result'] != null) {
          return CreateEventCalendarModel.fromJson(responseData['result']);
        }
      }
      return null;
    } catch (e) {
      print('Error creating event: $e');
      return null;
    }
  }

  Future<CreateEventResourceModel?> createEventResource(
      String name,
      String description,
      int group,
      String type,
      String organizationId,
      String token) async {
    var postData = {
      'name': name,
      'description': description,
      'group': group,
      'type': type,
      'organizationId': organizationId,
    };

    try {
      final response =
          await postConnect(createEventResourceAPI, postData, token);

      if (response.statusCode == statusOk) {
        var responseData = jsonDecode(utf8.decode(response.bodyBytes));
        // Lấy data từ key "result"
        var result = responseData['result'];
        return CreateEventResourceModel.fromJson(result);
      }
      return null;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<CreateEventResourceModel?> createEventResource_Personal(
      String name,
      String description,
      int group,
      String type,
      String organizationId,
      String token) async {
    var postData = {
      'name': name,
      'description': description,
      'group': group,
      'type': type,
      'organizationId': organizationId,
    };

    try {
      final response =
          await postConnect(createEventResource_PersonalAPI, postData, token);

      if (response.statusCode == statusOk) {
        var responseData = jsonDecode(utf8.decode(response.bodyBytes));
        // Lấy data từ key "result"
        var result = responseData['result'];
        return CreateEventResourceModel.fromJson(result);
      }
      return null;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<bool> deleteEventResource(String id, String token) async {
    try {
      String url = '$serverURL/website/event-resource/$id';

      final response = await deleteConnect(url, token);

      if (response.statusCode == statusOk) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> deleteEventCalendar(String id, String token) async {
    try {
      String url = '$serverURL/website/event-calendar/$id';

      final response = await deleteConnect(url, token);

      if (response.statusCode == statusOk) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<CreateEventResourceModel?> updateEventResource({
    required String id,
    required String name,
    required String description,
    required String token,
  }) async {
    final String updateUrl = '$serverURL/website/event-resource/$id';

    var postData = {
      'name': name,
      'description': description,
      'group': 0,
    };

    try {
      final response = await putConnect(
        updateUrl,
        jsonEncode(postData),
        token,
      );

      if (response.statusCode == statusOk) {
        var responseData = jsonDecode(utf8.decode(response.bodyBytes));
        var result = responseData['result'];
        return CreateEventResourceModel.fromJson(result);
      }
      return null;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
