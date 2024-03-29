import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? uid;
  String? restaurantRef;
  String? fullName;
  String? profileUrl;

  UserModel({
    this.id,
    this.uid,
    this.restaurantRef,
    this.fullName,
    this.profileUrl,
  });

  factory UserModel.fromMap(map) {
    return UserModel(
      id: map['id'],
      uid: map['uid'],
      restaurantRef: map['restaurantRef'],
      fullName: map['fullName'],
      profileUrl: map['profileUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'restaurantRef': restaurantRef,
      'fullName': fullName,
      'profileUrl': profileUrl,
    };
  }

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};
    return UserModel(
      id: snapshot.id,
      uid: data['uid'],
      restaurantRef: data['restaurantRef'],
      fullName: data['fullName'],
      profileUrl: data['profileUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (uid != null) "uid": uid,
      if (restaurantRef != null) "restaurantRef": restaurantRef,
      if (fullName != null) "fullName": fullName,
      if (profileUrl != null) "profileUrl": profileUrl,
    };
  }
}
