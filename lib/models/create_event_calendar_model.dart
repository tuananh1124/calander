import 'dart:convert';

class CreateEventCalendarModel {
  final String? id;
  final String? createdTime;
  final String? updatedTime;
  final String? type;
  final String? content;
  final String? notes;
  final String? color;
  final String? subcolor;
  final String? organizationId; // Add this line
  final int? from; // Add this line
  final int? to; // Add this line
  final List<Host>? hosts;
  final List<Attendee>? attendeesRequired;
  final List<Attendee>? attendeesNoRequired;
  final Creator? creator;

  CreateEventCalendarModel({
    this.id,
    this.createdTime,
    this.updatedTime,
    this.type,
    this.content,
    this.notes,
    this.color,
    this.subcolor,
    this.organizationId, // Add this line
    this.from, // Add this line
    this.to, // Add this line
    this.hosts,
    this.attendeesRequired,
    this.attendeesNoRequired,
    this.creator,
  });

  factory CreateEventCalendarModel.fromJson(Map<String, dynamic> json) {
    return CreateEventCalendarModel(
      id: json['id'],
      createdTime: json['createdTime'].toString(),
      updatedTime: json['updatedTime'].toString(),
      type: json['type'],
      content: json['content'],
      notes: json['notes'],
      color: json['color'],
      subcolor: json['subcolor'],
      organizationId: json['organizationId'], // Add this line
      from: json['from'], // Add this line
      to: json['to'], // Add this line
      hosts: (json['hosts'] as List<dynamic>?)
          ?.map((host) => Host.fromJson(host))
          .toList(),
      attendeesRequired: (json['attendeesRequired'] as List<dynamic>?)
          ?.map((attendee) => Attendee.fromJson(attendee))
          .toList(),
      attendeesNoRequired: (json['attendeesNoRequired'] as List<dynamic>?)
          ?.map((attendee) => Attendee.fromJson(attendee))
          .toList(),
      creator:
          json['creator'] != null ? Creator.fromJson(json['creator']) : null,
    );
  }
}

class Host {
  final String? userId;
  final String? fullName;
  final String? organizationName;

  Host({this.userId, this.fullName, this.organizationName});

  factory Host.fromJson(Map<String, dynamic> json) {
    return Host(
      userId: json['userId'],
      fullName: json['fullName'],
      organizationName: json['organizationName'],
    );
  }
}

class Attendee {
  final String? userId;
  final String? fullName;
  final String? organizationName;

  Attendee({this.userId, this.fullName, this.organizationName});

  factory Attendee.fromJson(Map<String, dynamic> json) {
    return Attendee(
      userId: json['userId'],
      fullName: json['fullName'],
      organizationName: json['organizationName'],
    );
  }
}

class Creator {
  final String? userId;
  final String? fullName;
  final String? organizationName;

  Creator({this.userId, this.fullName, this.organizationName});

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      userId: json['userId'],
      fullName: json['fullName'],
      organizationName: json['organizationName'],
    );
  }
}
