import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String name;
  final String email;
  final String jobTitle;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String password;
  final int followers;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.jobTitle,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.password,
    required this.followers,
  });

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      userId: data["userId"] ?? "",
      name: data["name"] ?? "",
      email: data["email"] ?? "",
      jobTitle: data["jobTitle"] ?? "",
      imageUrl: data["imageUrl"] ?? "",
      createdAt: (data["createTime"] as Timestamp).toDate(),
      updatedAt: (data["updateTime"] as Timestamp).toDate(),
      followers: data["followers"] ?? 0,
      password: data["password"],
    );
  }

  //convert task model to a firebase document
  Map<String, dynamic> toMap() {
    return {
      "userId": "userId",
      "name": name,
      "email": email,
      "jobTitle": jobTitle,
      "imageUrl": imageUrl,
      "createdAt": createdAt,
      "updateTime": updatedAt,
      "password": password,
      "followers": followers
    };
  }
}
