import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:reservation/feature/home_page/model/restaurants_provider.dart';
import 'package:reservation/feature/home_page/viewModel/home_view_model.dart';
import 'package:reservation/feature/login_register_page/viewModel/login_view_model.dart';
import 'package:reservation/feature/profile_page/viewModel/profil_view_model.dart';
import 'package:reservation/feature/profile_page/viewModel/restaurant_view_model.dart';
import 'package:reservation/feature/reservation_page/viewModel/reservation_view_model.dart';

class MultiProviderInit {
  final List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => ReservationViewModel()),
    ChangeNotifierProvider(create: (_) => ProfileViewModel()),
    ChangeNotifierProvider(create: (_) => RestaurantViewModel()),
    ChangeNotifierProvider(create: (_) => LoginViewModel()),
    ChangeNotifierProvider(create: (_) => HomeViewModel()),
    ChangeNotifierProvider(create: (_) => RestaurantsProvider()),
  ];
}
