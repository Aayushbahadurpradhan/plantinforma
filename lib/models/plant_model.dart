// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

PlantModel? productModelFromJson(String str) => PlantModel.fromJson(json.decode(str));

String productModelToJson(PlantModel? data) => json.encode(data!.toJson());

class PlantModel {
  PlantModel({
    this.id,
    this.userId,
    this.categoryId,
    this.plantName,
    this.temperatura,
    this.plantDescription,
    this.imageUrl,
    this.imagePath,
  });

  String? id;
  String? userId;
  String? categoryId;
  String? plantName;
  num? temperatura;
  String? plantDescription;
  String? imageUrl;
  String? imagePath;

  factory PlantModel.fromJson(Map<String, dynamic> json) => PlantModel(
    id: json["id"],
    userId: json["user_id"],
    categoryId: json["category_id"],
    plantName: json["plantName"],
    temperatura: json["temperatura"].toDouble(),
    plantDescription: json["plantDescription"],
    imageUrl: json["imageUrl"],
    imagePath: json["imagePath"],
  );



  factory PlantModel.fromFirebaseSnapshot(DocumentSnapshot<Map<String, dynamic>> json) => PlantModel(
    id: json.id,
    userId: json["user_id"],
    categoryId: json["category_id"],
    plantName: json["plantName"],
    temperatura: json["temperatura"].toDouble(),
    plantDescription: json["plantDescription"],
    imageUrl: json["imageUrl"],
    imagePath: json["imagePath"],
  );


  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "category_id": categoryId,
    "plantName": plantName,
    "temperatura": temperatura,
    "plantDescription": plantDescription,
    "imageUrl": imageUrl,
    "imagePath": imagePath,
  };
}
