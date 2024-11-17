class CreateEventCalendarModel {
  final int? from;
  final int? to;
  final String? type;
  final String? content;
  final String? notes;
  final String? color;
  final String? organizationId;
  final List<String>? resources;
  final List<String>? attachments;
  final List<AttendeeModel>? hosts;
  final List<AttendeeModel>? attendeesRequired;
  final List<AttendeeModel>? attendeesNoRequired;

  CreateEventCalendarModel({
    this.from,
    this.to,
    this.type,
    this.content,
    this.notes,
    this.color,
    this.organizationId,
    this.resources,
    this.attachments,
    this.hosts,
    this.attendeesRequired,
    this.attendeesNoRequired,
  });

  factory CreateEventCalendarModel.fromJson(Map<String, dynamic> json) {
    return CreateEventCalendarModel(
      from: json['from'],
      to: json['to'],
      type: json['type'],
      content: json['content'],
      notes: json['notes'],
      color: json['color'],
      organizationId: json['organizationId'],
      resources: json['resources'] != null
          ? List<String>.from(json['resources'])
          : null,
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
      'organizationId': organizationId,
      'resources': resources ?? [],
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
  final String? userId;
  final String? fullName;
  final String? jobTitle;
  final String? organizationId;
  final String? organizationName;

  AttendeeModel({
    this.userId,
    this.fullName,
    this.jobTitle,
    this.organizationId,
    this.organizationName,
  });

  factory AttendeeModel.fromJson(Map<String, dynamic> json) {
    return AttendeeModel(
      userId: json['userId'],
      fullName: json['fullName'],
      jobTitle: json['jobTitle'],
      organizationId: json['organizationId'],
      organizationName: json['organizationName'],
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
