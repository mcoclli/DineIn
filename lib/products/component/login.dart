import 'package:flutter/material.dart';
import 'package:reservation/core/constants/app_colors.dart';
import 'package:reservation/core/constants/app_string.dart';
import 'package:reservation/core/extensions/extension.dart';
import 'package:reservation/core/util/common_utils.dart';
import 'package:reservation/products/mixin/validation.dart';

class LoginComponent extends StatefulWidget {
  const LoginComponent({super.key});

  @override
  State<LoginComponent> createState() => _LoginComponentState();
}

class _LoginComponentState extends State<LoginComponent> with Validation {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: context.dynamicHeight(0.16),
        ),
        Container(
          padding: context.pagePaddingLetfTopRigth,
          child: Text(
            StringConstant.loginHeader,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.blueMetallic,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        SizedBox(
          height: context.dynamicHeight(0.08),
        ),
        Container(
          // height: context.dynamicHeight(0.45),
          width: context.dynamicWidth(0.85),
          decoration: context.boxDecoraiton,
          child: Padding(
            padding: context.largePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  StringConstant.loginText,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.silverlined,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(
                  height: context.dynamicHeight(0.02),
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      emailField,
                      passwordField,
                    ],
                  ),
                ),
                SizedBox(
                  height: context.dynamicHeight(0.07),
                ),
                Material(
                  child: Container(
                    color: AppColors.palatinateBlue,
                    height: context.dynamicHeight(0.06),
                    width: context.dynamicWidth(0.60),
                    child: MaterialButton(
                      onPressed: () {
                        var email = emailEditingController.text;
                        var password = passwordEditingController.text;
                        CommonUtils.log(
                            "Signing in with email : $email, password : $password");
                        signIn(email, password);
                        emailEditingController.clear();
                        passwordEditingController.clear();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            StringConstant.continu,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: context.dynamicWidth(0.03),
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            color: AppColors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
