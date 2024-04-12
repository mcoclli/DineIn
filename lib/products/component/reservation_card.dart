import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reservation/feature/profile_page/model/restaurant_model.dart';
import 'package:reservation/feature/reservation_page/model/reservation_model.dart';
import 'package:reservation/feature/reservation_page/viewModel/reservation_view_model.dart';

class ReservationCard extends StatelessWidget {
  final RestaurantModel restaurant;
  final ReservationModel reservation;
  final bool isFuture;

  const ReservationCard(
      {super.key, required this.reservation, required this.isFuture, required  this.restaurant});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd hh:mm');
    final duration = reservation.slots * 15;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () {
          showReservationDetails(context, reservation);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reservation on ${dateFormat.format(reservation.start)}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text('Duration: $duration minutes'),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Pax: ${reservation.pax}'),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showReservationDetails(
      BuildContext context, ReservationModel reservation) {
    final dateFormat = DateFormat(
        'yyyy-MM-dd hh:mm'); // Ensure you've imported 'package:intl/intl.dart';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            color: reservation.status == 'ACCEPTED'
                ? Colors.greenAccent
                : (reservation.status == 'REJECTED'
                    ? Colors.redAccent
                    : Colors.orangeAccent),
            child: const Text('Reservation Details'),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Date: ${dateFormat.format(reservation.start)}'),
                Text('Duration: ${reservation.slots * 15} minutes'),
                Text('Customer Contact: ${reservation.customerContact}'),
                Text('Pax: ${reservation.pax}'),
                Text('Notes: ${reservation.notes}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                context
                    .read<ReservationViewModel>()
                    .updateStatus(restaurant, reservation, 'ACCEPTED');
                Navigator.of(context).pop();
              },
              child: const Text('Accept'),
            ),
            TextButton(
              onPressed: () async {
                context
                    .read<ReservationViewModel>()
                    .updateStatus(restaurant, reservation, 'REJECTED');
                Navigator.of(context).pop();
              },
              child: const Text('Reject'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
