import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reservation/core/util/common_utils.dart';
import 'package:reservation/feature/profile_page/model/restaurant_model.dart';
import 'package:reservation/feature/reservation_page/model/reservation_model.dart';
import 'package:reservation/feature/reservation_page/viewModel/reservation_view_model.dart';
import 'package:reservation/products/component/reservation_card.dart';

class ReservationRequestsPage extends StatefulWidget {
  const ReservationRequestsPage(
      {super.key, required this.currentRestaurant, required this.isFuture});

  final bool isFuture;
  final RestaurantModel currentRestaurant;

  @override
  State<ReservationRequestsPage> createState() =>
      _ReservationRequestsPageState();
}

class _ReservationRequestsPageState extends State<ReservationRequestsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Provider.of<ReservationViewModel>(context, listen: false)
        .loadReservations(widget.currentRestaurant);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (widget.isFuture) {
        CommonUtils.log("Fetching more future reservations");
        context.read<ReservationViewModel>().fetchMoreFutureReservations();
      } else {
        CommonUtils.log("Fetching more past reservations");
        context.read<ReservationViewModel>().fetchMorePastReservations();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ReservationViewModel>(context);

    List<ReservationModel> reservations =
        widget.isFuture ? model.futureReservations : model.pastReservations;
    return reservations.isEmpty
        ? const Center(
            child: Text("No Reservations Yet.."),
          )
        : ListView.builder(
            controller: _scrollController,
            itemCount:
                model.isLoading ? reservations.length + 1 : reservations.length,
            itemBuilder: (context, index) {
              return ReservationCard(
                restaurant: widget.currentRestaurant,
                reservation: reservations[index],
                isFuture: widget.isFuture,
              );
            },
          );
  }
}
