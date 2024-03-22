import 'package:flutter/material.dart';
import 'package:reservation/core/constants/image_const.dart';
import 'package:reservation/products/component/login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            PngImage(name: ImageItems().loginlogoImage),
            const LoginComponent(),
          ],
        ),
      ),
    );
  }
}
