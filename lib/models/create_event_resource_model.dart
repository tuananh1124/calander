class CreateEventResourceModel {
  final String? name;
  final String? description;
  final String? id;
  final int? group;

  CreateEventResourceModel({
    this.name,
    this.description,
    this.id,
    this.group,
  });

  factory CreateEventResourceModel.fromJson(Map<String, dynamic> json) {
    return CreateEventResourceModel(
      name: json['name'],
      description: json['description'],
      id: json['id'],
      group: json['group'],
    );
  }
}
