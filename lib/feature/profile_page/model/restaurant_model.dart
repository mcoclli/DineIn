import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reservation/core/util/common_utils.dart';
import 'package:reservation/feature/profile_page/model/availability.dart';
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
  Map<int, Availability> availability = {};
  int slotDurationMin; // defaults for 15min

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
    required this.availability,
    slotDurationMin,
  }) : slotDurationMin = slotDurationMin ?? 15;

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
      availability: ((map['availability'] ?? {}) as Map).map(
          (key, val) => MapEntry(int.parse(key), Availability.fromMap(val))),
      slotDurationMin: map['slotDurationMin'] ?? 15,
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
      'availability': availability
          .map((key, value) => MapEntry(key.toString(), value.toMap())),
      'slotDurationMin': slotDurationMin,
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
      availability: ((data['availability'] ?? {}) as Map).map(
          (key, val) => MapEntry(int.parse(key), Availability.fromMap(val))),
      slotDurationMin: data['slotDurationMin'] ?? 15,
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
      "tables": tables.map((e) => e.toMap()).toList(),
      "availability": availability
          .map((key, value) => MapEntry(key.toString(), value.toMap())),
      "slotDurationMin": slotDurationMin,
    };
  }

  bool isRestaurantAvailable(DateTime dateTime) {
    var availabilityData = availability[dateTime.weekday % 7];
    CommonUtils.log("availabilityData : $availabilityData");
    return availabilityData?.isWithinAvailability(dateTime) ??
        false;
  }
}
