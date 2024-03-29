import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reservation/core/constants/image_const.dart';
import 'package:reservation/feature/profile_page/viewModel/profil_view_model.dart';
import 'package:reservation/products/component/login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    Provider.of<ProfileViewModel>(context, listen: false).resetUser();
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
