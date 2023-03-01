import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/favorite_model.dart';
import '../models/plant_model.dart';
import '../models/user_model.dart';
import '../repositories/auth_repositories.dart';
import '../repositories/favorite_repositories.dart';
import '../repositories/plant_repositories.dart';
import '../services/firebase_service.dart';


class AuthViewModel with ChangeNotifier {
  User? _user = FirebaseService.firebaseAuth.currentUser;

  User? get user => _user;

  UserModel? _loggedInUser;
  UserModel? get loggedInUser =>_loggedInUser;


  Future<void> login(String email, String password) async {
    try {
      var response = await AuthRepository().login(email, password);
      _user = response.user;
      _loggedInUser = await AuthRepository().getUserDetail(_user!.uid);
      notifyListeners();
    } catch (err) {
      AuthRepository().logout();
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await AuthRepository().resetPassword(email);
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }


  Future<void> register(UserModel user) async {
    try {
      var response = await AuthRepository().register(user);
      _user = response!.user;
      _loggedInUser = await AuthRepository().getUserDetail(_user!.uid);
      notifyListeners();
    } catch (err) {
      AuthRepository().logout();
      rethrow;
    }
  }


  Future<void> checkLogin() async {
    try {
      _loggedInUser = await AuthRepository().getUserDetail(_user!.uid);
      notifyListeners();
    } catch (err) {
      _user = null;
      AuthRepository().logout();
      rethrow;
    }
  }

  Future<void> logout() async{
    try{
      await AuthRepository().logout();
      _user = null;
      notifyListeners();
    }catch(e){
      rethrow;
    }
  }


  FavoriteRepository _favoriteRepository = FavoriteRepository();
  List<FavoriteModel> _favorites = [];
  List<FavoriteModel> get favorites => _favorites;


  List<PlantModel>? _favoriteProduct;
  List<PlantModel>? get favoriteProduct => _favoriteProduct;

  Future<void> getFavoritesUser() async{
    try{
      var response = await _favoriteRepository.getFavoritesUser(loggedInUser!.userId!);
      _favorites=[];
      for (var element in response) {
        _favorites.add(element.data());
      }
      _favoriteProduct=[];
      if(_favorites.isNotEmpty){

        var productResponse = await PlantRepository().getProductFromList(_favorites.map((e) => e.plantId).toList());
        for (var element in productResponse) {
          _favoriteProduct!.add(element.data());
        }
      }

      notifyListeners();
    }catch(e){
      print(e);
      _favorites = [];
      _favoriteProduct=null;
      notifyListeners();
    }
  }

  Future<void> favoriteAction(FavoriteModel? isFavorite, String productId) async{
    try{
      await _favoriteRepository.favorite(isFavorite, productId, loggedInUser!.userId! );
      await getFavoritesUser();
      notifyListeners();
    }catch(e){
      _favorites = [];
      notifyListeners();
    }
  }


  List<PlantModel>? _myProduct;
  List<PlantModel>? get myProduct => _myProduct;
  Future<void> getMyProducts() async{
    try{
      var productResponse = await PlantRepository().getMyProducts(loggedInUser!.userId!);
      _myProduct=[];
      for (var element in productResponse) {
        _myProduct!.add(element.data());
      }
      notifyListeners();
    }catch(e){
      print(e);
      _myProduct=null;
      notifyListeners();
    }
  }
  Future<void> addMyProduct(PlantModel product)async {
    try{
      await PlantRepository().addProducts(plant: product);

      await getMyProducts();
      notifyListeners();
    }catch(e){

    }
  }
  Future<void> editMyProduct(PlantModel product, String productId)async {
    try{
      await PlantRepository().editProduct(plant: product, plantId: productId);
      await getMyProducts();
      notifyListeners();
    }catch(e){

    }
  }
  Future<void> deleteMyProduct(String productId) async{
    try{
      await PlantRepository().removeProduct(productId, loggedInUser!.userId!);
      await getMyProducts();
      notifyListeners();
    }catch(e){
      print(e);
      _myProduct=null;
      notifyListeners();
    }
  }


}
