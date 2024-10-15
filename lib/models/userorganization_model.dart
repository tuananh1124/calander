import 'dart:convert';

class UserorganizationModel {
  final String? id;
  final String? fullName;
  final String? jobTitle;
  final String? organizationId;
  final String? organizationName;
  final String? pathName;
  final List<String>? permissions; // Chỉnh sửa thành danh sách List<String>

  UserorganizationModel({
    this.id,
    this.fullName,
    this.jobTitle,
    this.organizationId,
    this.organizationName,
    this.pathName,
    this.permissions,
  });

  factory UserorganizationModel.fromJson(Map<String, dynamic> json) {
    return UserorganizationModel(
      id: json['id'],
      fullName: json['fullName'],
      jobTitle: json['jobTitle'],
      organizationId:
          json['organizationId'], // Sửa lại ánh xạ đúng organizationId
      organizationName: json['organizationName'],
      pathName: json['pathName'],
      permissions: json['permissions'] != null
          ? List<String>.from(json['permissions'])
          : [],
    );
  }
}
