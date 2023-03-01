import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/plant_model.dart';
import '../repositories/plant_repositories.dart';

class PlantViewModel with ChangeNotifier {
  PlantRepository _plantRepository = PlantRepository();
  List<PlantModel> _plants = [];
  List<PlantModel> get plants => _plants;

  Future<void> getProducts() async{
    _plants=[];
    notifyListeners();
    try{
      var response = await _plantRepository.getAllProducts();
      for (var element in response) {
        print(element.id);
        _plants.add(element.data());
      }
      notifyListeners();
    }catch(e){
      print(e);
      _plants = [];
      notifyListeners();
    }
  }


  Future<void> addProduct(PlantModel product) async{
    try{
      var response = await _plantRepository.addProducts(plant: product);
    }catch(e){
      notifyListeners();
    }
  }

}
