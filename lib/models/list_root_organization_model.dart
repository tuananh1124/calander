class ListRootOrganizationModel {
  final String id;
  final String name;
  final String parentId;
  final String path;
  final List<ListRootOrganizationModel> subOrganizations;

  ListRootOrganizationModel({
    required this.id,
    required this.name,
    required this.parentId,
    required this.path,
    List<ListRootOrganizationModel>? subOrganizations,
  }) : subOrganizations = subOrganizations ?? [];

  factory ListRootOrganizationModel.fromJson(Map<String, dynamic> json) {
    return ListRootOrganizationModel(
      id: json['id'],
      name: json['name'],
      parentId: json['parentId'],
      path: json['path'],
      subOrganizations: (json['subOrganizations'] as List<dynamic>?)
              ?.map((subOrg) => ListRootOrganizationModel.fromJson(subOrg))
              .toList() ??
          [],
    );
  }
}
