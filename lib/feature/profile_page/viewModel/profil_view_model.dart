import 'package:flutter/material.dart';
import 'package:reservation/core/util/common_utils.dart';
import 'package:reservation/feature/profile_page/model/image_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../login_register_page/model/users_model.dart';

class ProfileViewModel extends ChangeNotifier {
  late final List<ImageModel> _items = ImageModelItems().items;
  List<ImageModel> get imgModel => _items;

  User? user = FirebaseAuth.instance.currentUser;
  UserModel _loggedInUser = UserModel();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  UserModel get loggedInUser => _loggedInUser;

  profileToList(ImageModel imgModel) {
    _items.contains(imgModel);
    notifyListeners();
  }

  resetUser() {
    CommonUtils.log("Resetting the user");
    _loggedInUser = UserModel();
  }

  fetchUserModel({bool forced = false}) async {
    if (!forced && _loggedInUser.restaurantRef != null) {
      CommonUtils.log(
          "The user is already loaded and returning the old value $_loggedInUser");
      return;
    }
    _db.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    await _db
        .collection("users")
        .where("uid", isEqualTo: user!.uid)
        .limit(1)
        .withConverter<UserModel>(
            fromFirestore: UserModel.fromFirestore,
            toFirestore: (UserModel userModel, options) =>
                userModel.toFirestore())
        .get()
        .then(
      (querySnapshot) {
        _loggedInUser = querySnapshot.docs.first.data();
        notifyListeners();
      },
    );
  }

  Future<void> updateUserProfile(UserModel updatedUser) async {
    _db.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    await _db
        .collection("users")
        .doc(_loggedInUser.id)
        .update(updatedUser.toMap())
        .then((value) async {
      CommonUtils.log("User data updated..");
      await fetchUserModel(forced: true);
    });
  }
}
