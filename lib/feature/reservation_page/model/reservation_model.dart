import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reservation/core/constants/app_string.dart';
import 'package:uuid/uuid.dart';

final List<String> allCategoryMenus = [
  StringConstant.reservaName,
  StringConstant.menuName,
];

class ReservationModel {
  String id;
  String restaurantRef;
  DateTime start;
  int slots;
  List<ReservationMenuItem> menuItems = [];
  String notes;
  String tableId;
  int pax;
  String? customerName;
  String customerContact;
  String status;

  ReservationModel(
      {id,
      required this.restaurantRef,
      required this.start,
      required this.slots,
      notes,
      required this.tableId,
      List<ReservationMenuItem>? menuItems,
      required this.pax,
      customerName,
      required this.customerContact,
      status})
      : id = id ?? const Uuid().v4().toString(),
        notes = notes ?? "NA",
        menuItems = menuItems ?? [],
        customerName = customerName ?? "anonymous",
        status = status ?? "PENDING";

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'restaurantRef': restaurantRef,
      'start': start.toIso8601String(),
      'slots': slots,
      // Convert DateTime to a string
      'menuItems': menuItems.map((item) => item.toMap()).toList(),
      // Convert list of items to a list of maps
      'notes': notes,
      'tableId': tableId,
      'pax': pax,
      'customerName': customerName,
      'customerContact': customerContact,
      'status': status,
    };
  }

  factory ReservationModel.fromMap(Map<String, dynamic> map) {
    return ReservationModel(
      id: map['id'],
      restaurantRef: map['restaurantRef'],
      start: DateTime.parse(map['start']),
      slots: map['slots'] ?? 1,
      // Convert string to DateTime
      menuItems: List<ReservationMenuItem>.from(
        (map['menuItems'] ?? [])
            .map((item) => ReservationMenuItem.fromMap(item)),
      ),
      // Convert list of maps to list of ReservationMenuItems
      notes: map['notes'],
      tableId: map['tableId'] ?? "-1",
      pax: map['pax'] ?? 1,
      customerName: map['customerName'] ?? "anonymous",
      customerContact: map['customerContact'],
      status: map['status'] ?? "PENDING",
    );
  }

  factory ReservationModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};
    return ReservationModel(
      id: snapshot.id,
      restaurantRef: data['restaurantRef'],
      start:
          ((data['start'] ?? Timestamp.fromDate(DateTime.now())) as Timestamp)
              .toDate(),
      slots: data['slots'] ?? 1,
      // Convert list of maps to list of ReservationMenuItems
      menuItems: List<ReservationMenuItem>.from(
        (data['menuItems'] ?? [])
            .map((item) => ReservationMenuItem.fromMap(item)),
      ),
      notes: data['notes'],
      tableId: data['tableId']!,
      pax: data['pax'] ?? 1,
      customerName: data['customerName'] ?? "anonymous",
      customerContact: data['customerContact'] ?? "",
      status: data['status'] ?? "PENDING",
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'restaurantRef': restaurantRef,
      // Convert DateTime to Firestore Timestamp
      'start': Timestamp.fromDate(start),
      'slots': slots,
      'menuItems': menuItems.map((item) => item.toMap()).toList(),
      'notes': notes,
      'tableId': tableId,
      'pax': pax,
      'customerName': customerName,
      'customerContact': customerContact,
      'status': status,
    };
  }
}

class ReservationMenuItem {
  String menuId;
  int qty;

  ReservationMenuItem({
    required this.menuId,
    qty,
  }) : qty = qty ?? 1;

  factory ReservationMenuItem.fromMap(map) {
    return ReservationMenuItem(
      menuId: map['menuId'],
      qty: map['qty'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'menuId': menuId,
      'qty': qty,
    };
  }
}
