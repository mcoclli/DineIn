import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reservation/core/constants/image_const.dart';
import 'package:reservation/feature/profile_page/viewModel/profil_view_model.dart';
import 'package:reservation/products/component/login.dart';
import 'register_page.dart'; // Import the RegisterPage

class LoginPage extends StatefulWidget {
  const LoginPage({required Key key}) : super(key: key);

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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const LoginComponent(),
                const SizedBox(height: 20), // Add spacing between login and register
                ElevatedButton(
                  onPressed: () {
                    // Navigate to register page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage(key: Key('register_page_key'))),
                    );
                  },
                  child: Text('Register'), // This line adds the "Register" button
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
