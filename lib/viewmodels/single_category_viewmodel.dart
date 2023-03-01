import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/plant_model.dart';
import '../repositories/category_repositories.dart';
import '../repositories/plant_repositories.dart';

class SingleCategoryViewModel with ChangeNotifier {
  CategoryRepository _categoryRepository = CategoryRepository();
  PlantRepository _plantRepository = PlantRepository();
  CategoryModel? _category = CategoryModel();
  CategoryModel? get category => _category;
  List<PlantModel> _plants = [];
  List<PlantModel> get plants => _plants;

  Future<void> getProductByCategory(String categoryId) async{
    _category=CategoryModel();
    _plants=[];
    notifyListeners();
    try{
      print(categoryId);
      var response = await _categoryRepository.getCategory(categoryId);
      _category = response.data();
      var productResponse = await _plantRepository.getProductByCategory(categoryId);
      for (var element in productResponse) {
        _plants.add(element.data());
      }

      notifyListeners();
    }catch(e){
      _category = null;
      notifyListeners();
    }
  }

}
