import 'package:flutter/material.dart';
import 'package:reservation/core/util/common_utils.dart';
import 'package:reservation/feature/home_page/model/menu_draw_model.dart';
import 'package:reservation/feature/profile_page/model/image_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../login_register_page/model/users_model.dart';

class ProfileViewModel extends ChangeNotifier {
  late final List<ImageModel> _items = ImageModelItems().items;
  List<ImageModel> get imgModel => _items;

  bool menuOpenMi = false;
  menuOpenClose() {
    menuOpenMi = !menuOpenMi;
    notifyListeners();
  }

  late final List<DrawModel> _drawItem;
  List<DrawModel> drawModel(BuildContext context) {
    try {
      _drawItem.isEmpty;
    } catch (e) {
      _drawItem = DrawItems(context: context).items;
    }
    return _drawItem;
  }

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

  final _maxRetries = 5;
  final _retryDelay = const Duration(milliseconds: 600);

  Future<bool> fetchUserModelWithRetry(
      {int attempt = 0, bool forced = false}) async {
    CommonUtils.log("Trying to get user data. attempt $attempt");
    bool success = await fetchUserModel();
    if (success) {
      return true; // Success, return true
    } else if (attempt < _maxRetries) {
      // Wait for a bit before retrying
      await Future.delayed(_retryDelay);
      // Recursively retry with incremented retry count
      return fetchUserModelWithRetry(attempt: attempt + 1);
    } else {
      return false; // Max retries reached, return false
    }
  }

  Future<bool> fetchUserModel({bool forced = false}) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      CommonUtils.log("Authenticated user is null. returning");
      return false;
    }
    if (!forced && _loggedInUser.restaurantRef != null) {
      CommonUtils.log(
          "The user is already loaded and returning the old value $_loggedInUser");
      return true;
    }
    return await _db
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
        return true;
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
