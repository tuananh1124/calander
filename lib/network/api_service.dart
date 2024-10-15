import 'dart:convert';
import 'package:flutter_calendar/config/ngn_constant.dart';
import 'package:flutter_calendar/models/color_model.dart';
import 'package:flutter_calendar/models/list_root_organization_model.dart';
import 'package:flutter_calendar/models/list_of_user_personal_model.dart';
import 'package:flutter_calendar/models/list_sub_organization_model.dart';
import 'package:flutter_calendar/models/login_model.dart';
import 'package:flutter_calendar/models/type_calendar_model.dart';
import 'package:flutter_calendar/models/userorganization_model.dart';
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

  Future<List<ListofpersonalModel>?> getListOfPersonal(String token) async {
    try {
      final response = await getConnect(getListOfPersonalAPI, token);
      var decodedBody = utf8.decode(response.bodyBytes);

      print(response.statusCode);

      if (response.statusCode == statusOk) {
        var responseData = jsonDecode(decodedBody);
        //print(responseData); // In ra để kiểm tra cấu trúc dữ liệu
        if (responseData is Map) {
          if (responseData.containsKey('result')) {
            var listData = responseData['result'];

            if (listData is List) {
              List<ListofpersonalModel> modelList = listData
                  .map((item) => ListofpersonalModel.fromJson(item))
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

  Future<List<UserorganizationModel>?> getUserOrganization(String token) async {
    final response = await getConnect(getUserOrganizationAPI, token);

    var decodedBody = utf8.decode(response.bodyBytes);
    print(response.statusCode);

    if (response.statusCode == statusOk) {
      var responseData = jsonDecode(decodedBody);
      var result = responseData['result'];

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

      // Fetch sub-organizations for each root organization
      for (var organization in listRootOrganization) {
        organization.subOrganizations =
            await getSubOrganizations(organization.id, token);
      }

      return listRootOrganization;
    } else {
      print(
          'getListRootOrganization request failed with status: ${response.statusCode}');
      return null;
    }
  }

  Future<List<ListSubOrganizationModel>> getSubOrganizations(
      String parentId, String token) async {
    final response = await http.get(
      Uri.parse('$getListSubOrganizationAPI/$parentId/list-sub-organizations'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    var decodedBody = utf8.decode(response.bodyBytes);
    print(response.statusCode);

    if (response.statusCode == 200) {
      var responseData = jsonDecode(decodedBody);
      var result = responseData['result'];

      List<ListSubOrganizationModel> subOrganizations = (result as List)
          .map((item) => ListSubOrganizationModel.fromJson(item))
          .toList();

      // Recursively fetch sub-organizations for each sub-organization
      for (var subOrg in subOrganizations) {
        subOrg.subOrganizations = await getSubOrganizations(subOrg.id, token);
      }

      return subOrganizations;
    } else {
      print(
          'getSubOrganizations request failed with status: ${response.statusCode}');
      return [];
    }
  }

//   final Map<String, List<ListSubOrganizationModel>> _cache = {};
// // Khai báo cache và Set để lưu ID các tổ chức đã xử lý
//   final Set<String> _processedOrganizationIds = {};
//
//   Future<void> getListSubOrganizationsRecursively(
//       String id, String token) async {
//     // Kiểm tra cache trước khi gọi API
//     List<ListSubOrganizationModel>? cachedSubOrgs = _cache[id];
//     if (cachedSubOrgs != null) {
//       // In ra thông tin từ cache
//       for (var subOrg in cachedSubOrgs) {
//         print('Sub Organization (from cache) ID: ${subOrg.id}');
//         print('Sub Organization (from cache) Name: ${subOrg.name}');
//         print('Total Sub Organizations: ${subOrg.total}');
//       }
//       return; // Trả về nếu đã có trong cache
//     }
//
//     if (_processedOrganizationIds.contains(id)) {
//       print('Organization ID $id đã được xử lý, bỏ qua.');
//       return; // Bỏ qua nếu đã xử lý tổ chức này
//     }
//
//     List<ListSubOrganizationModel>? subOrganizations =
//         await getListSubOrganization(id, token, 10);
//
//     if (subOrganizations != null && subOrganizations.isNotEmpty) {
//       // Lưu vào cache
//       _cache[id] = subOrganizations;
//
//       // Đánh dấu tổ chức này là đã xử lý
//       _processedOrganizationIds.add(id);
//
//       // Sử dụng Future.wait để gọi đệ quy song song
//       await Future.wait(subOrganizations.map((subOrg) async {
//         print('Sub Organization ID: ${subOrg.id}');
//         print('Sub Organization Name: ${subOrg.name}');
//         print('Total Sub Organizations: ${subOrg.total}');
//
//         if (subOrg.total != 0 && subOrg.id != null) {
//           await getListSubOrganizationsRecursively(subOrg.id!, token);
//         }
//       }));
//     }
//   }
//
//   Future<List<ListRootOrganizationModel>?> getListRootOrganization(
//       String token) async {
//     final response = await getConnect(getListRootOrganizationAPI, token);
//     var decodedBody = utf8.decode(response.bodyBytes);
//     print(response.statusCode);
//
//     if (response.statusCode == statusOk) {
//       var responseData = jsonDecode(decodedBody);
//       var result = responseData['result'];
//       print('Total root organizations: $result');
//
//       List<ListRootOrganizationModel> organizationList = (result as List)
//           .map((item) =>
//               ListRootOrganizationModel.fromJson(item, responseData['total']))
//           .toList();
//       print('=============================================');
//
//       // Gọi phương thức đệ quy cho tất cả tổ chức gốc
//       await Future.wait(organizationList.map((organization) async {
//         if (organization.id != null) {
//           print('Root Organization ID: ${organization.id}');
//           print('Root Organization Name: ${organization.name}');
//           print('Total Sub Organizations: ${responseData['total']}');
//
//           // Gọi phương thức đệ quy
//           await getListSubOrganizationsRecursively(organization.id!, token);
//         }
//       }));
//
//       return organizationList;
//     } else {
//       print(
//           'getListRootOrganization request failed with status: ${response.statusCode}');
//       return null;
//     }
//   }
//
//   Future<List<ListSubOrganizationModel>?> getListSubOrganization(
//       String id, String token, int count) async {
//     List<ListSubOrganizationModel> subOrganizationList = [];
//     int totalFromResponse = 0;
//
//     do {
//       final response = await getConnect(
//           '$getListSubOrganizationAPI/$id/list-sub-organizations', token);
//       var decodedBody = utf8.decode(response.bodyBytes);
//
//       if (response.statusCode == statusOk) {
//         var responseData = jsonDecode(decodedBody);
//         var result = responseData['result'];
//         totalFromResponse = responseData['total'] ?? 0;
//
//         print(
//             'Processing organization ID: $id, total from response: $totalFromResponse');
//
//         // Kiểm tra nếu kết quả có tồn tại
//         if (result is List && result.isNotEmpty) {
//           for (var org in result) {
//             var subOrg =
//                 ListSubOrganizationModel.fromJson(org, totalFromResponse);
//             subOrganizationList.add(subOrg);
//
//             // In ra tên của tổ chức con đã nhận
//             print(
//                 'Added sub-organization: ID = ${subOrg.id}, Name = ${subOrg.name}');
//           }
//
//           if (totalFromResponse > subOrganizationList.length) {
//             int remainingCount = totalFromResponse - subOrganizationList.length;
//             remainingCount = remainingCount > count ? count : remainingCount;
//
//             print(
//                 'Fetching remaining $remainingCount sub-organizations for organization ID: $id');
//           } else {
//             break;
//           }
//         } else {
//           print('Empty result for organization ID: $id');
//           break;
//         }
//       } else {
//         print('Request failed with status: ${response.statusCode}');
//         break;
//       }
//     } while (totalFromResponse > subOrganizationList.length);
//
//     // In ra danh sách tên của tất cả các tổ chức con đã nhận
//     if (subOrganizationList.isNotEmpty) {
//       print('List of sub-organizations:');
//       for (var subOrg in subOrganizationList) {
//         print('Sub-organization Name: ${subOrg.name}');
//       }
//     } else {
//       print('No sub-organizations found.');
//     }
//
//     return subOrganizationList.isNotEmpty ? subOrganizationList : null;
//   }
}
