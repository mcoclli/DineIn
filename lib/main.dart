import 'package:cached_firestorage/cached_firestorage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reservation/core/constants/app_string.dart';
import 'package:reservation/core/util/common_utils.dart';
import 'package:reservation/feature/favorite_page/view/favorite_view.dart';
import 'package:reservation/feature/notification_page/view/notification_view.dart';
import 'package:reservation/feature/profile_page/view/profile_view.dart';
import 'package:reservation/feature/reservation_page/view/reservation_view.dart';
import 'package:reservation/feature/splash_page/view/splash_view.dart';
import 'package:reservation/firebase_options.dart';
import 'package:reservation/products/global/global.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) async {
    CachedFirestorage.instance.cacheTimeout = 30;
    CommonUtils.log("Firebase app initialized $value");
  });
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  get onGenerateRoute => null;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: MultiProviderInit().providers,
      child: MaterialApp(
          title: StringConstant.main,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.orange,
          ),
          initialRoute: '/',
          routes: {
            "/": (context) => const SplashPage(),
            "/profilePage": (context) => const ProfilePage(),
            "/notificationPage": (context) => const NotificationPage(),
            "/favoritePage": (context) => const FavoritePage(),
            "/shopPage": (context) => const ReservationsPage()
          },
          onGenerateRoute: onGenerateRoute),
    );
  }
}
