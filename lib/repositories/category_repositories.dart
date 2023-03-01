import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/category_model.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class CategoryRepository{
  CollectionReference<CategoryModel> categoryRef = FirebaseService.db.collection("categories")
      .withConverter<CategoryModel>(
    fromFirestore: (snapshot, _) {
      return CategoryModel.fromFirebaseSnapshot(snapshot);
    },
    toFirestore: (model, _) => model.toJson(),
  );
    Future<List<QueryDocumentSnapshot<CategoryModel>>> getCategories() async {
    try {
      var data = await categoryRef.get();
      bool hasData = data.docs.isNotEmpty;
      if(!hasData){
        makeCategory().forEach((element) async {
          await categoryRef.add(element);
        });
      }
      final response = await categoryRef.get();
      var category = response.docs;
      return category;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<DocumentSnapshot<CategoryModel>>  getCategory(String categoryId) async {
      try{
        print(categoryId);
        final response = await categoryRef.doc(categoryId).get();
        return response;
      }catch(e){
        rethrow;
      }
  }

  List<CategoryModel> makeCategory(){
      return [
        CategoryModel(categoryName: "Air Plants", status: "active", imageUrl: "https://cdn.shopify.com/s/files/1/0047/9730/0847/products/nurserylive-g-plants-air-plant-tillandsia-ionantha-guatemala-medium-plant_600x600.jpg?v=1637660144"),
        CategoryModel(categoryName: "Aquatic Plants", status: "active", imageUrl: "https://cdn.shopify.com/s/files/1/0047/9730/0847/products/nurserylive-water-lily-any-color-plant_464x464.jpg?v=1634230964"),
        CategoryModel(categoryName: "Bamboo plants", status: "active", imageUrl: "https://cdn.shopify.com/s/files/1/0047/9730/0847/products/nurserylive-plants-2-lucky-bamboo-stalks-a-symbol-of-love-gift-plant-16968448082060_464x464.jpg?v=1634207136"),
        CategoryModel(categoryName: "Fruit Plants", status: "active", imageUrl: "https://cdn.shopify.com/s/files/1/0047/9730/0847/products/nurserylive-mango-tree-kesar-grafted-plant_464x464.jpg?v=1634223741"),
        CategoryModel(categoryName: "Ground Cover ", status: "active", imageUrl: "https://cdn.shopify.com/s/files/1/0047/9730/0847/products/nurserylive-portulaca-oleracea-10-o-clock-yellow-plant_464x464.jpg?v=1634226677"),
        CategoryModel(categoryName: "Conifer Plants", status: "active", imageUrl: "https://cdn.shopify.com/s/files/1/0047/9730/0847/products/nurserylive-g-cypress-green-plant_464x464.jpg?v=1655469301"),
      ];
  }



}