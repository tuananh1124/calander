class CreateEventResourceModel {
  final String? name;
  final String? description;
  final int? group;

  CreateEventResourceModel({
    this.name,
    this.description,
    this.group,
  });

  factory CreateEventResourceModel.fromJson(Map<String, dynamic> json) {
    return CreateEventResourceModel(
      name: json['name'],
      description: json['description'],
      group: json['group'],
    );
  }
}
