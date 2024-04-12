import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reservation/core/util/common_utils.dart';
import 'package:reservation/feature/profile_page/model/restaurant_model.dart';

class RestaurantsProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<RestaurantModel> _availableRestaurants = List.empty();

  List<RestaurantModel> get availableRestaurants => _availableRestaurants;

  fetchAll({bool forced = false}) async {
    if (!forced && _availableRestaurants.isNotEmpty) {
      CommonUtils.log(
          "The restaurants already loaded and returning the old values [${_availableRestaurants.length}]");
      return;
    }
    CommonUtils.log("Fetching all restaurants");
    await _db
        .collection("restaurants")
        .withConverter<RestaurantModel>(
            fromFirestore: RestaurantModel.fromFirestore,
            toFirestore: (RestaurantModel restaurantModel, options) =>
                restaurantModel.toFirestore())
        .get()
        .then(
      (querySnapshot) {
        _availableRestaurants = querySnapshot.docs.map((e) => e.data()).toList();
        CommonUtils.log(
            "Received restaurants data ${_availableRestaurants.length}");
        notifyListeners();
      },
    );
  }
}
