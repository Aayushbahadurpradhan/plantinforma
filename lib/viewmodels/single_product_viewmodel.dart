import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/plant_model.dart';
import '../repositories/category_repositories.dart';
import '../repositories/plant_repositories.dart';

class SingleProductViewModel with ChangeNotifier {
  PlantRepository _plantRepository = PlantRepository();
  PlantModel? _plant = PlantModel();
  PlantModel? get plant => _plant;

  Future<void> getProducts(String plantId) async{
    _plant=PlantModel();
    notifyListeners();
    try{
      var response = await _plantRepository.getOneProduct(plantId);
      _plant = response.data();
      notifyListeners();
    }catch(e){
      _plant = null;
      notifyListeners();
    }
  }

  Future<void> addProduct(PlantModel plant) async{
    try{
      var response = await _plantRepository.addProducts(plant: plant);
    }catch(e){
      notifyListeners();
    }
  }

}
