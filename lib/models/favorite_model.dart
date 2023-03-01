// To parse this JSON data, do
//
//     final favoriteModel = favoriteModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

FavoriteModel favoriteModelFromJson(String str) => FavoriteModel.fromJson(json.decode(str));

String favoriteModelToJson(FavoriteModel data) => json.encode(data.toJson());

class FavoriteModel {
  FavoriteModel({
    required this.userId,
    this.id,
    required this.plantId,
  });

  String? id;
  String userId;
  String plantId;

  factory FavoriteModel.fromJson(Map<String, dynamic> json) => FavoriteModel(
    id: json["id"],
    userId: json["user_id"],
    plantId: json["plant_Id"],
  );
  factory FavoriteModel.fromFirebaseSnapshot(DocumentSnapshot<Map<String, dynamic>> json) => FavoriteModel(
    id: json.id,
    userId: json["user_id"],
    plantId: json["plant_Id"],
  );


  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "id": id,
    "plant_Id": plantId,
  };
}
