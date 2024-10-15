import 'dart:convert';

class TypeCalendarModel {
  final String? key;
  final String? name;

  TypeCalendarModel({
    this.key,
    this.name,
  });

  factory TypeCalendarModel.fromJson(Map<String, dynamic> json) {
    return TypeCalendarModel(
      key: json['key'],
      name: json['name'],
    );
  }
}
