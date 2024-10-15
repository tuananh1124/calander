import 'package:flutter_calendar/models/list_sub_organization_model.dart';

class ListRootOrganizationModel {
  final String id;
  final String name;
  List<ListSubOrganizationModel> subOrganizations;

  ListRootOrganizationModel({
    required this.id,
    required this.name,
    List<ListSubOrganizationModel>? subOrganizations,
  }) : subOrganizations = subOrganizations ?? [];

  factory ListRootOrganizationModel.fromJson(Map<String, dynamic> json) {
    return ListRootOrganizationModel(
      id: json['id'],
      name: json['name'],
      subOrganizations: [],
    );
  }
}
