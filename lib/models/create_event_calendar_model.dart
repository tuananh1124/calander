class CreateEventCalendarModel {
  final String? id;
  final int? createdTime;
  final int? updatedTime;
  final int? from;
  final int? to;
  final String? type;
  final String? content;
  final String? notes;
  final String? color;
  final String? subcolor;
  final List<String>? resources;
  final List<String>? attachments;
  final List<AttendeeModel>? hosts;
  final List<AttendeeModel>? attendeesRequired;
  final List<AttendeeModel>? attendeesNoRequired;
  final CreatorModel? creator;
  final String? organizationId; // Thêm trường này
  CreateEventCalendarModel({
    this.id,
    this.createdTime,
    this.updatedTime,
    this.from,
    this.to,
    this.type,
    this.content,
    this.notes,
    this.color,
    this.subcolor,
    this.resources,
    this.attachments,
    this.hosts,
    this.attendeesRequired,
    this.attendeesNoRequired,
    this.creator,
    this.organizationId, // Thêm vào constructor
  });

  factory CreateEventCalendarModel.fromJson(Map<String, dynamic> json) {
    return CreateEventCalendarModel(
      id: json['id'],
      createdTime: json['createdTime'],
      updatedTime: json['updatedTime'],
      from: json['from'],
      to: json['to'],
      type: json['type'],
      content: json['content'],
      notes: json['notes'],
      color: json['color'],
      subcolor: json['subcolor'],
      resources: (json['resources'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      attachments: json['attachments'] != null
          ? List<String>.from(json['attachments'])
          : null,
      hosts: json['hosts'] != null
          ? (json['hosts'] as List)
              .map((h) => AttendeeModel.fromJson(h))
              .toList()
          : null,
      attendeesRequired: json['attendeesRequired'] != null
          ? (json['attendeesRequired'] as List)
              .map((a) => AttendeeModel.fromJson(a))
              .toList()
          : null,
      attendeesNoRequired: json['attendeesNoRequired'] != null
          ? (json['attendeesNoRequired'] as List)
              .map((a) => AttendeeModel.fromJson(a))
              .toList()
          : null,
      creator: json['creator'] != null
          ? CreatorModel.fromJson(json['creator'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
      'type': type,
      'content': content,
      'notes': notes,
      'color': color,
      'organizationId': organizationId, // Thêm vào JSON
      'resources': resources?.map((e) => e.toString()).toList() ??
          [], // Đảm bảo chuyển đổi sang String
      'attachments': attachments ?? [],
      'hosts': hosts?.map((h) => h.toJson()).toList() ?? [],
      'attendeesRequired':
          attendeesRequired?.map((a) => a.toJson()).toList() ?? [],
      'attendeesNoRequired':
          attendeesNoRequired?.map((a) => a.toJson()).toList() ?? [],
    };
  }
}

class AttendeeModel {
  final String? type;
  final String? userId;
  final String? fullName;
  final String? jobTitle;
  final String? organizationId;
  final String? organizationName;
  final String? status;
  final String? notes;
  final int? createdTime;
  final int? confirmedTime;
  final int? delegacyTime;
  final List<dynamic>? historiesDelegacy;

  AttendeeModel({
    this.type,
    this.userId,
    this.fullName,
    this.jobTitle,
    this.organizationId,
    this.organizationName,
    this.status,
    this.notes,
    this.createdTime,
    this.confirmedTime,
    this.delegacyTime,
    this.historiesDelegacy,
  });

  factory AttendeeModel.fromJson(Map<String, dynamic> json) {
    return AttendeeModel(
      type: json['type'],
      userId: json['userId'],
      fullName: json['fullName'],
      jobTitle: json['jobTitle'],
      organizationId: json['organizationId'],
      organizationName: json['organizationName'],
      status: json['status'],
      notes: json['notes'],
      createdTime: json['createdTime'],
      confirmedTime: json['confirmedTime'],
      delegacyTime: json['delegacyTime'],
      historiesDelegacy: json['historiesDelegacy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'jobTitle': jobTitle,
      'organizationId': organizationId,
      'organizationName': organizationName,
    };
  }
}

class CreatorModel {
  final String? userId;
  final String? fullName;
  final String? organizationId;
  final String? organizationName;
  final String? type;
  final String? textDisplay;

  CreatorModel({
    this.userId,
    this.fullName,
    this.organizationId,
    this.organizationName,
    this.type,
    this.textDisplay,
  });

  factory CreatorModel.fromJson(Map<String, dynamic> json) {
    return CreatorModel(
      userId: json['userId'],
      fullName: json['fullName'],
      organizationId: json['organizationId'],
      organizationName: json['organizationName'],
      type: json['type'],
      textDisplay: json['textDisplay'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'organizationId': organizationId,
      'organizationName': organizationName,
      'type': type,
      'textDisplay': textDisplay,
    };
  }
}
