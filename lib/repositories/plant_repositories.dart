import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/plant_model.dart';
import '../services/firebase_service.dart';

class PlantRepository {
  CollectionReference<PlantModel> plantRef = FirebaseService.db.collection("plants").withConverter<PlantModel>(
        fromFirestore: (snapshot, _) {
          return PlantModel.fromFirebaseSnapshot(snapshot);
        },
        toFirestore: (model, _) => model.toJson(),
      );

  Future<List<QueryDocumentSnapshot<PlantModel>>> getAllProducts() async {
    try {
      final response = await plantRef.get();
      var plants = response.docs;
      return plants;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<List<QueryDocumentSnapshot<PlantModel>>> getProductByCategory(String id) async {
    try {
      final response = await plantRef.where("category_id", isEqualTo: id.toString()).get();
      var plants = response.docs;
      return plants;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<List<QueryDocumentSnapshot<PlantModel>>> getProductFromList(List<String> plantIds) async {
    try {
      final response = await plantRef.where(FieldPath.documentId, whereIn: plantIds).get();
      var plants = response.docs;
      return plants;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<List<QueryDocumentSnapshot<PlantModel>>> getMyProducts(String userId) async {
    try {
      final response = await plantRef.where("user_id", isEqualTo: userId).get();
      var plants = response.docs;
      return plants;
    } catch (err) {
      print(err);
      rethrow;
    }
  }


  Future<bool> removeProduct(String plantId, String userId) async {
    try {
      final response = await plantRef.doc(plantId).get();
      if(response.data()!.userId !=  userId){
        return false;
      }
      await plantRef.doc(plantId).delete();
      return true;
    } catch (err) {
      print(err);
      rethrow;
    }
  }



  Future<DocumentSnapshot<PlantModel>> getOneProduct(String id) async {
    try {
      final response = await plantRef.doc(id).get();
      if (!response.exists) {
        throw Exception("Plant doesnot exists");
      }
      return response;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<bool?> addProducts({required PlantModel plant}) async {
    try {
      final response = await plantRef.add(plant);
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool?> editProduct({required PlantModel plant, required String plantId}) async {
    try {
      final response = await plantRef.doc(plantId).set(plant);
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool?> favorites({required PlantModel plant}) async {
    try {
      final response = await plantRef.add(plant);
      return true;
    } catch (err) {
      return false;
      rethrow;
    }
  }
}
