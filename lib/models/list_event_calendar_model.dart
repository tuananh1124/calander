import 'dart:convert';

class ListEventcalendarModel {
  final String? id;
  final int? createdTime;
  final int? updatedTime;
  final String? type;
  final int? from;
  final int? to;
  final String? content;
  final String? notes;
  final String? color;
  final List<Host>? hosts; // Chuyển thành List<Host> thay vì String
  final List<dynamic>? attendeesRequired;
  final List<dynamic>? attendeesNoRequired;
  final List<dynamic>? resources;
  final List<dynamic>? attachments;
  final Creator? creator;

  ListEventcalendarModel({
    this.id,
    this.createdTime,
    this.updatedTime,
    this.type,
    this.from,
    this.to,
    this.content,
    this.notes,
    this.color,
    this.hosts, // Sửa lại kiểu
    this.attendeesRequired,
    this.attendeesNoRequired,
    this.resources,
    this.attachments,
    this.creator,
  });

  factory ListEventcalendarModel.fromJson(Map<String, dynamic> json) {
    return ListEventcalendarModel(
      id: json['id'],
      createdTime: json['createdTime'],
      updatedTime: json['updatedTime'],
      type: json['type'],
      from: json['from'],
      to: json['to'],
      content: json['content'],
      notes: json['notes'],
      color: json['color'],
      hosts: (json['hosts'] as List<dynamic>?)
          ?.map((host) => Host.fromJson(host))
          .toList(), // Sửa lại cách xử lý danh sách hosts
      attendeesRequired: json['attendeesRequired'] as List<dynamic>?,
      attendeesNoRequired: json['attendeesNoRequired'] as List<dynamic>?,
      resources: json['resources'] as List<dynamic>?,
      attachments: json['attachments'] as List<dynamic>?,
      creator:
          json['creator'] != null ? Creator.fromJson(json['creator']) : null,
    );
  }
}

class Host {
  final String? userId;
  final String? fullName;
  final String? jobTitle;
  final String? organizationId;
  final String? organizationName;
  final String? status;
  final int? confirmedTime;
  final String? notes;

  Host({
    this.userId,
    this.fullName,
    this.jobTitle,
    this.organizationId,
    this.organizationName,
    this.status,
    this.confirmedTime,
    this.notes,
  });

  factory Host.fromJson(Map<String, dynamic> json) {
    return Host(
      userId: json['userId'],
      fullName: json['fullName'],
      jobTitle: json['jobTitle'],
      organizationId: json['organizationId'],
      organizationName: json['organizationName'],
      status: json['status'],
      confirmedTime: json['confirmedTime'],
      notes: json['notes'],
    );
  }
}

class Creator {
  final String? userId;
  final String? fullName;
  final String? organizationId;
  final String? organizationName;
  final String? type;

  Creator({
    this.userId,
    this.fullName,
    this.organizationId,
    this.organizationName,
    this.type,
  });

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      userId: json['userId'],
      fullName: json['fullName'],
      organizationId: json['organizationId'],
      organizationName: json['organizationName'],
      type: json['type'],
    );
  }
}
