class ListSubOrganizationModel {
  final String id;
  final String name;

  ListSubOrganizationModel({
    required this.id,
    required this.name,
  });

  factory ListSubOrganizationModel.fromJson(Map<String, dynamic> json) {
    return ListSubOrganizationModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
