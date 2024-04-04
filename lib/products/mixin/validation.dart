import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reservation/core/constants/app_string.dart';
import 'package:reservation/core/util/common_utils.dart';
import 'package:reservation/feature/login_register_page/view/login_view.dart';
import 'package:reservation/feature/profile_page/view/profile_view.dart';
import 'package:reservation/main.dart';
import 'package:reservation/products/widgets/text_form_field.dart';

final fullNameEditingController = TextEditingController();
final emailEditingController = TextEditingController();
final passwordEditingController = TextEditingController();
final confirmPasswordEditingController = TextEditingController();

mixin Validation<T extends StatefulWidget> on State<T> {
  static final _auth = FirebaseAuth.instance;
  String? errorMessage;
  final formKey = GlobalKey<FormState>();
  bool isChecked = false;

  final fullNameField = AuthTextField(
    controller: fullNameEditingController,
    validator: (value) {
      RegExp regex = RegExp(r'^.{3,}$');
      if (value!.isEmpty) {
        return ("First Name cannot be Empty");
      }
      if (!regex.hasMatch(value)) {
        return ("Enter Valid name(Min. 3 Character)");
      }
      return null;
    },
    onSaved: (value) {
      fullNameEditingController.text = value!;
    },
    changeObscureCallBack: () {},
    hintText: StringConstant.fullName,
  );

  final emailField = AuthTextField(
    controller: emailEditingController,
    hintText: StringConstant.emailAdress,
    changeObscureCallBack: () {},
    validator: (value) {
      if (value!.isEmpty) {
        return ("Please Enter Your Email");
      }

      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
        return ("Please Enter a valid email");
      }
      return null;
    },
    onSaved: (value) {
      fullNameEditingController.text = value!;
    },
    isObsecure: false,
  );

  final passwordField = AuthTextField(
    controller: passwordEditingController,
    hintText: StringConstant.password,
    isObsecure: true,
    changeObscureCallBack: () {},
    validator: (value) {
      RegExp regex = RegExp(r'^.{6,}$');
      if (value!.isEmpty) {
        return ("Password is required for login");
      }
      if (!regex.hasMatch(value)) {
        return ("Enter Valid Password(Min. 6 Character)");
      }
      return null;
    },
    onSaved: (value) {
      fullNameEditingController.text = value!;
    },
  );

  void signIn(String email, String password) async {
    if (formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then(
              (uid) => {
                Fluttertoast.showToast(msg: "Login successful..."),
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const ProfilePage())),
              },
            );
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "INVALID_LOGIN_CREDENTIALS":
            errorMessage = "Your login credentials are wrong. Please retry";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(
          msg: errorMessage!,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    }
  }

  static Future<void> signOutWithContext(BuildContext context) async {
    try {
      await _auth.signOut().then(
            (value) => {
              Fluttertoast.showToast(msg: "Logout successful..."),
              CommonUtils.log(
                  "context is [${navigatorKey.currentState?.context}]"),
              navigatorKey.currentState!.pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
              )
            },
          );
    } on FirebaseAuthException catch (error) {
      CommonUtils.log("Error occurred. ${error.message}");
      Fluttertoast.showToast(
        msg: "An undefined Error happened.",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut().then(
            (value) => {
              Fluttertoast.showToast(msg: "Logout successful..."),
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              )
            },
          );
    } on FirebaseAuthException catch (error) {
      CommonUtils.log("Error occurred. ${error.message}");
      Fluttertoast.showToast(
        msg: "An undefined Error happened.",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }
}
