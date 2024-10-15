class ListSubOrganizationModel {
  final String id;
  final String name;
  List<ListSubOrganizationModel> subOrganizations;

  ListSubOrganizationModel({
    required this.id,
    required this.name,
    List<ListSubOrganizationModel>? subOrganizations,
  }) : subOrganizations = subOrganizations ?? [];

  factory ListSubOrganizationModel.fromJson(Map<String, dynamic> json) {
    return ListSubOrganizationModel(
      id: json['id'],
      name: json['name'],
      subOrganizations: [],
    );
  }
}
