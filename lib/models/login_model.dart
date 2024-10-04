import 'dart:convert';

class LoginModel {
  final String? id;
  final String? email;
  final String? phone;
  final String? username;
  final String? fullName;
  final String? token;
  final String? colors; // Add token if returned by the server

  LoginModel({
    this.id,
    this.email,
    this.phone,
    this.username,
    this.fullName,
    this.token,
    this.colors,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      id: json['id'],
      email: json['email'],
      phone: json['phone'],
      username: json['username'],
      fullName: json['fullName'],
      token: json['loginToken'],
      colors: json['colors'],
    );
  }
}

class User {
  static String? id;
  static String? email;
  static String? phone;
  static String? username;
  static String? fullName;
  static String? token;
  static String? colors;
}
