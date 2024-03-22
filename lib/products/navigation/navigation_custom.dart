// import 'package:flutter/material.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:reservation/core/constants/app_string.dart';
// import 'package:reservation/core/util/common_utils.dart';
// import 'package:reservation/feature/favorite_page/view/favorite_view.dart';
// import 'package:reservation/feature/home_page/view/home_view.dart';
// import 'package:reservation/feature/notification_page/view/notification_view.dart';
// import 'package:reservation/feature/profile_page/view/profile_view.dart';
// import 'package:reservation/feature/reservation_page/view/reservation_view.dart';
// import 'package:reservation/main.dart';

// mixin NavigatorCustom<T extends MainApp> on Widget {
//   Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
//     List<String> filtered = routeSettings.name!.split("/");
//     CommonUtils.log("in nav mixin ==> ${filtered[1]}");
//     switch (filtered[1]) {
//       case "/":
//         return PageTransition(
//           child: const HomePage(),
//           type: PageTransitionType.fade,
//           settings: routeSettings,
//           reverseDuration: const Duration(seconds: 0),
//         );
//       case StringConstant.profil:
//         return PageTransition(
//           child: const ProfilePage(),
//           type: PageTransitionType.fade,
//           settings: routeSettings,
//           reverseDuration: const Duration(seconds: 0),
//         );
//       case StringConstant.shop:
//         return PageTransition(
//           child: const ReservationsPage(),
//           type: PageTransitionType.fade,
//           settings: routeSettings,
//           reverseDuration: const Duration(seconds: 0),
//         );
//       case StringConstant.home:
//         return PageTransition(
//           child: const HomePage(),
//           type: PageTransitionType.fade,
//           settings: routeSettings,
//           reverseDuration: const Duration(seconds: 0),
//         );

//       case StringConstant.favorite:
//         return PageTransition(
//           child: const FavoritePage(),
//           type: PageTransitionType.fade,
//           settings: routeSettings,
//           reverseDuration: const Duration(seconds: 0),
//         );
//       case StringConstant.notification:
//         return PageTransition(
//           child: const NotificationPage(),
//           type: PageTransitionType.fade,
//           settings: routeSettings,
//           reverseDuration: const Duration(seconds: 0),
//         );
//     }
//     return null;
//   }
// }
