import 'package:flutter/material.dart';
import 'package:reservation/core/util/common_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reservation/feature/profile_page/model/restaurant_model.dart';
import 'package:reservation/feature/profile_page/viewModel/profil_view_model.dart';

class RestaurantViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  RestaurantModel? _currentRestaurent;

  RestaurantModel? get currentRestaurant => _currentRestaurent;

  fetchRestaurantModel(ProfileViewModel profileProvider) async {
    var user = profileProvider.loggedInUser;
    if (user.restaurantRef != null) {
      _doFetchRestaurant(user.restaurantRef!);
    }
  }

  _doFetchRestaurant(String restaurantRef) async {
    if (_currentRestaurent != null) {
      CommonUtils.log(
          "The restaurant is already loaded and returning the old value $_currentRestaurent");
      return;
    }
    CommonUtils.log("Fetching restaurant for $restaurantRef");
    await _db
        .collection("restaurants")
        .where("restaurantRef", isEqualTo: restaurantRef)
        .limit(1)
        .withConverter<RestaurantModel>(
            fromFirestore: RestaurantModel.fromFirestore,
            toFirestore: (RestaurantModel restaurantModel, options) =>
                restaurantModel.toFirestore())
        .get()
        .then(
      (querySnapshot) {
        _currentRestaurent = querySnapshot.docs.first.data();
        CommonUtils.log("Received restaurant data $_currentRestaurent");
        notifyListeners();
      },
    );
  }

  updateRestaurant(RestaurantModel updated) async {
    await _db
        .collection("restaurant")
        .doc(updated.id)
        .update(updated.toMap())
        .then((value) {
      CommonUtils.log("Updating the data");
      _doFetchRestaurant(updated.restaurantRef!);
    });
  }
}