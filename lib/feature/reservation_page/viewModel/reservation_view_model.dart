import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reservation/core/util/common_utils.dart';
import 'package:reservation/feature/profile_page/model/restaurant_model.dart';
import 'package:reservation/feature/reservation_page/model/reservation_model.dart';

class ReservationViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<ReservationModel>? _reservations;

  List<ReservationModel> futureReservations = [];
  List<ReservationModel> pastReservations = [];
  bool isLoading = true;

  late String _restaurantRef;
  DateTime reservationStart = DateTime.now().add(const Duration(hours: 1));
  int pax = 1;
  int slots = 1;
  String tableId = "";

  setReservationStart(DateTime dateTime) {
    reservationStart = dateTime;
  }

  setPax(int pax) {
    this.pax = pax;
  }

  setSlots(int slots) {
    this.slots = slots;
  }

  setTableId(String tableId) {
    this.tableId = tableId;
  }

  notifyAll() {
    notifyListeners();
  }

  List<ReservationModel>? get currentReservations => _reservations;

  fetchReservations(RestaurantModel restaurant, {bool forced = false}) async {
    if (!forced && _reservations != null) {
      CommonUtils.log(
          "The restaurant is already loaded and returning the old value ${_reservations?.length}");
      return;
    }
    _restaurantRef = restaurant.restaurantRef!;
    CommonUtils.log("Fetching restaurant for $_restaurantRef");
    // _db.settings = const Settings(
    //   cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    // );
    var startTime = DateTime.now().subtract(
        Duration(minutes: (15 * (restaurant.maxConsecutiveSlots ?? 2))));
    await _db
        .collection("reservations")
        .where("restaurantRef", isEqualTo: _restaurantRef)
        .where("start", isGreaterThanOrEqualTo: Timestamp.fromDate(startTime))
        .withConverter<ReservationModel>(
            fromFirestore: ReservationModel.fromFirestore,
            toFirestore: (ReservationModel reservationModel, options) =>
                reservationModel.toFirestore())
        .get()
        .then(
      (querySnapshot) {
        _reservations = querySnapshot.docs.map((e) => e.data()).toList();
        CommonUtils.log("Received reservations data ${_reservations?.length}");
        notifyListeners();
      },
    );
  }

  Future<ReservationModel?> makeReservation(Map<String, int> menu,
      String customerName, String customerContact, String? notes) async {
    try {
      ReservationModel reservation = ReservationModel(
          restaurantRef: _restaurantRef,
          start: reservationStart,
          slots: slots,
          menuItems: menu.entries
              .map((e) => ReservationMenuItem(menuId: e.key, qty: e.value))
              .toList(),
          notes: notes,
          tableId: tableId,
          pax: pax,
          customerName: customerName,
          customerContact: customerContact);
      CommonUtils.log("Creating $reservation");
      DocumentReference ref = await _db
          .collection('reservations')
          .withConverter<ReservationModel>(
              fromFirestore: ReservationModel.fromFirestore,
              toFirestore: (ReservationModel reservationModel, options) =>
                  reservationModel.toFirestore())
          .add(reservation);
      DocumentSnapshot snapshot = await ref.get();
      if (snapshot.exists) {
        return snapshot.data() as ReservationModel;
      }
    } catch (e) {
      CommonUtils.log("Error occurred ${e.toString()}");
      return null;
    }
    return null;
  }

  Future<void> updateStatus(RestaurantModel restaurant,ReservationModel reservation, String status) async {
    try {
      CommonUtils.log(
          "Updating status to [$status] of reservation ${reservation.id}");
      await _db
          .collection('reservations')
          .doc(reservation.id)
          .update({'status': status}).then((_) {
            CommonUtils.log("Updated... ");
            loadReservations(restaurant);
      });
    } catch (e) {
      CommonUtils.log("Error occurred ${e.toString()}");
    }
  }

  DocumentSnapshot? lastDocumentFuture; // For pagination
  DocumentSnapshot? lastDocumentPast; // For pagination

  // Initial fetch method
  Future<void> loadReservations(RestaurantModel restaurant) async {
    _restaurantRef = restaurant.restaurantRef!;

    // Fetch future reservations
    var futureQuery = _db
        .collection('reservations')
        .where("restaurantRef", isEqualTo: restaurant.restaurantRef)
        .where('start', isGreaterThan: Timestamp.fromDate(DateTime.now()))
        .orderBy('start', descending: false)
        .limit(10)
        .withConverter<ReservationModel>(
            fromFirestore: ReservationModel.fromFirestore,
            toFirestore: (ReservationModel reservationModel, options) =>
                reservationModel.toFirestore());

    var futureSnapshot = await futureQuery.get();
    CommonUtils.log("Reservations loaded : ${futureSnapshot.docs.length}");
    futureReservations = futureSnapshot.docs.map((e) => e.data()).toList();

    // Fetch past reservations
    var pastQuery = _db
        .collection('reservations')
        .where("restaurantRef", isEqualTo: restaurant.restaurantRef)
        .where('start', isLessThan: Timestamp.fromDate(DateTime.now()))
        .orderBy('start', descending: true)
        .limit(10)
        .withConverter<ReservationModel>(
            fromFirestore: ReservationModel.fromFirestore,
            toFirestore: (ReservationModel reservationModel, options) =>
                reservationModel.toFirestore());

    var pastSnapshot = await pastQuery.get();
    pastReservations = pastSnapshot.docs.map((e) => e.data()).toList();

    if (futureSnapshot.docs.isNotEmpty) {
      lastDocumentFuture = futureSnapshot.docs.last;
    }
    if (pastSnapshot.docs.isNotEmpty) {
      lastDocumentPast = pastSnapshot.docs.last;
    }

    isLoading = false;
    notifyListeners();
  }

  // Pagination fetch method
  Future<void> fetchMoreFutureReservations() async {
    if (isLoading || lastDocumentFuture == null) return;

    isLoading = true;
    notifyListeners();

    // Example for future reservations pagination
    var futureQuery = _db
        .collection('reservations')
        .where("restaurantRef", isEqualTo: _restaurantRef)
        .where('start', isGreaterThan: Timestamp.fromDate(DateTime.now()))
        .orderBy('start', descending: false)
        .startAfterDocument(lastDocumentFuture!)
        .limit(10)
        .withConverter<ReservationModel>(
            fromFirestore: ReservationModel.fromFirestore,
            toFirestore: (ReservationModel reservationModel, options) =>
                reservationModel.toFirestore());

    var futureSnapshot = await futureQuery.get();
    var newReservations = futureSnapshot.docs.map((e) => e.data()).toList();
    futureReservations.addAll(newReservations);

    if (futureSnapshot.docs.isNotEmpty) {
      lastDocumentFuture = futureSnapshot.docs.last;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMorePastReservations() async {
    if (isLoading || lastDocumentPast == null) return;

    CommonUtils.log("Loading more future ones");

    isLoading = true;
    notifyListeners();

    // Example for past reservations pagination
    var futureQuery = _db
        .collection('reservations')
        .where("restaurantRef", isEqualTo: _restaurantRef)
        .where('start', isLessThan: Timestamp.fromDate(DateTime.now()))
        .orderBy('start', descending: true)
        .startAfterDocument(lastDocumentPast!)
        .limit(10)
        .withConverter<ReservationModel>(
            fromFirestore: ReservationModel.fromFirestore,
            toFirestore: (ReservationModel reservationModel, options) =>
                reservationModel.toFirestore());

    var snapshot = await futureQuery.get();
    var newReservations = snapshot.docs.map((e) => e.data()).toList();
    pastReservations.addAll(newReservations);

    if (snapshot.docs.isNotEmpty) {
      lastDocumentPast = snapshot.docs.last;
    }

    isLoading = false;
    notifyListeners();
  }
}
