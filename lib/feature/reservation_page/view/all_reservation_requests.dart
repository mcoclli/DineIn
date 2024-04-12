import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reservation/feature/profile_page/viewModel/restaurant_view_model.dart';
import 'package:reservation/feature/reservation_page/view/reservation_requests_view.dart';
import 'package:reservation/products/widgets/bottom_navbar.dart';

class AllReservationRequests extends StatelessWidget {
  const AllReservationRequests({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurantState = Provider.of<RestaurantViewModel>(context);
    var currentRestaurant = restaurantState.currentRestaurant;
    return Scaffold(
      bottomNavigationBar: const BottomNavbar(pageid: 4),
      body: currentRestaurant == null
          ? const CircularProgressIndicator()
          : DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Reservations'),
                  bottom: const TabBar(
                    tabs: [
                      Tab(text: 'Upcoming'),
                      Tab(text: 'Past'),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    ReservationRequestsPage(currentRestaurant: currentRestaurant, isFuture: true),
                    ReservationRequestsPage(currentRestaurant: currentRestaurant, isFuture: false),
                  ],
                ),
              ),
            ),
    );
  }
}
