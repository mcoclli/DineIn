import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantModel {
  String? id;
  String? name;
  final String? restaurantRef;
  String? baseImageUrl;

  RestaurantModel({this.id, this.name, this.restaurantRef, this.baseImageUrl});

  factory RestaurantModel.fromMap(map) {
    return RestaurantModel(
      name: map['name'],
      restaurantRef: map['restaurantRef'],
      baseImageUrl: map['baseImageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'restaurantRef': restaurantRef,
      'baseImageUrl': baseImageUrl,
    };
  }

  factory RestaurantModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};
    return RestaurantModel(
      id: snapshot.id,
      name: data['name'],
      restaurantRef: data['restaurantRef'],
      baseImageUrl: data['baseImageUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (restaurantRef != null) "restaurantRef": restaurantRef,
      if (baseImageUrl != null) "baseImageUrl": baseImageUrl,
    };
  }
}
