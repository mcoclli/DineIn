import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reservation/feature/profile_page/model/menu_item_model.dart';
import 'package:reservation/feature/profile_page/model/table_model.dart';

class RestaurantModel {
  String? id;
  String? name;
  final String? restaurantRef;
  String? baseImageUrl;
  String? cuisine;
  String? meanCost;
  String? address;
  List<MenuItemModel> menuItems = [];
  int? maxConsecutiveSlots = 2;
  List<TableModel> tables = [];

  RestaurantModel({
    this.id,
    this.name,
    this.restaurantRef,
    this.baseImageUrl,
    this.cuisine,
    this.meanCost,
    this.address,
    required this.menuItems,
    this.maxConsecutiveSlots,
    required this.tables,
  });

  factory RestaurantModel.fromMap(map) {
    return RestaurantModel(
      name: map['name'],
      restaurantRef: map['restaurantRef'],
      baseImageUrl: map['baseImageUrl'],
      cuisine: map['cuisine'],
      meanCost: map['meanCost'],
      address: map['address'],
      menuItems: ((map['menuItems'] ?? []) as List)
          .map((field) => MenuItemModel.fromMap(field))
          .toList(),
      maxConsecutiveSlots: map['maxConsecutiveSlots'],
      tables: ((map['tables'] ?? []) as List)
          .map((field) => TableModel.fromMap(field))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'restaurantRef': restaurantRef,
      'baseImageUrl': baseImageUrl,
      'cuisine': cuisine,
      'meanCost': meanCost,
      'address': address,
      'menuItems': menuItems.map((element) => element.toMap()),
      'maxConsecutiveSlots': maxConsecutiveSlots,
      'tables': tables.map((element) => element.toMap()),
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
      cuisine: data['cuisine'],
      meanCost: data['meanCost'],
      address: data['address'],
      menuItems: ((data['menuItems'] ?? []) as List)
          .map((e) => MenuItemModel.fromMap(e as Map<String, dynamic>))
          .toList(growable: true),
      maxConsecutiveSlots: data['maxConsecutiveSlots'],
      tables: ((data['tables'] ?? []) as List)
          .map((e) => TableModel.fromMap(e as Map<String, dynamic>))
          .toList(growable: true),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (restaurantRef != null) "restaurantRef": restaurantRef,
      if (baseImageUrl != null) "baseImageUrl": baseImageUrl,
      if (cuisine != null) "cuisine": cuisine,
      if (meanCost != null) "meanCost": meanCost,
      if (address != null) "address": address,
      "menuItems": menuItems.map((e) => e.toMap()).toList(),
      if (maxConsecutiveSlots != null)
        "maxConsecutiveSlots": maxConsecutiveSlots,
    };
  }
}
