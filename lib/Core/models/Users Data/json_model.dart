import 'package:flutter/cupertino.dart';

class Users {
  final String name;
  final String email;
  final String phone;
  final String profileImageUrl;
  final String userid;

  Users(
      {required this.name,
      required this.email,
      required this.phone,
      required this.profileImageUrl,
      required this.userid});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      profileImageUrl: json['profileImageUrl'],
      userid: json['userid'],
    );
  }
}

class UserModels extends ChangeNotifier {
  String? name;
  String? email;
  String? phone;
  String? profileImageUrl;
  String? userid;

  UserModels({
    this.email,
    this.name,
    this.phone,
    this.userid,
    this.profileImageUrl,
  });

  UserModels.fromJson(json) {
    // userLongitude = json['longitude'];
    email = json['email'];
    userid = json['userid'];

    name = json['name'];
    phone = json['phone'];
    profileImageUrl = json['profileImageUrl'];
  }

  toJson() {
    return {
      'email': email,
      'name': name,
      'userid': userid,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
    };
  }
}
