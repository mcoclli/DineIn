import 'package:flutter/material.dart';
import 'package:reservation/core/constants/duration_items.dart';
import 'package:reservation/core/constants/image_const.dart';
import 'package:reservation/feature/login_register_page/view/login_view.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(DurationItems.durationNormal(), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Stack(children: [
      Center(
        child: LottieImage(
          name: ImageItems.knife,
        ),
      ),
    ]));
  }
}
