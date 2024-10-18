class ListEventResourceModel {
  final String? id;
  final int? createdTime;
  final int? updatedTime;
  final String? type;
  final String? name;
  final String? description;
  final int? group;
  final Creator? creator;

  ListEventResourceModel({
    this.id,
    this.createdTime,
    this.updatedTime,
    this.type,
    this.name,
    this.description,
    this.group,
    this.creator,
  });

  factory ListEventResourceModel.fromJson(Map<String, dynamic> json) {
    return ListEventResourceModel(
      id: json['id'],
      createdTime: json['createdTime'],
      updatedTime: json['updatedTime'],
      type: json['type'],
      name: json['name'],
      description: json['description'],
      group: json['group'],
      creator:
          json['creator'] != null ? Creator.fromJson(json['creator']) : null,
    );
  }
}

class Creator {
  final String? userId;
  final String? fullName;
  final String? organizationId;
  final String? organizationName;
  final String? type;
  final String? textDisplay;

  Creator({
    this.userId,
    this.fullName,
    this.organizationId,
    this.organizationName,
    this.type,
    this.textDisplay,
  });

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      userId: json['userId'],
      fullName: json['fullName'],
      organizationId: json['organizationId'],
      organizationName: json['organizationName'],
      type: json['type'],
      textDisplay: json['textDisplay'],
    );
  }
}
