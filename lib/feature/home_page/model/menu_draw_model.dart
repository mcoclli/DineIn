import 'package:flutter/material.dart';
import 'package:reservation/core/constants/app_colors.dart';
import 'package:reservation/core/constants/app_string.dart';
import 'package:reservation/core/util/common_utils.dart';
import 'package:reservation/feature/profile_page/view/profile_view.dart';
import 'package:reservation/products/mixin/validation.dart';

class DrawModel {
  final String title;
  final Widget icon;
  Function()? onClicked;

  DrawModel({
    required this.title,
    required this.icon,
    this.onClicked,
  });
}

class DrawItems {
  late final List<DrawModel> items;
  final BuildContext context;

  DrawItems({required this.context}) {
    items = [
      DrawModel(
        icon: const Icon(
          Icons.home_outlined,
          color: AppColors.russet,
        ),
        title: StringConstant.myHome,
        onClicked: () => {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const ProfilePage()))
        },
      ),
      DrawModel(
        icon: const Icon(
          Icons.search,
          color: AppColors.russet,
        ),
        title: StringConstant.yourOrder,
        onClicked: () => {},
      ),
      DrawModel(
        icon: const Icon(
          Icons.logout,
          color: AppColors.russet,
        ),
        title: StringConstant.logout,
        onClicked: () {
          CommonUtils.log("Logout pressed");
          Validation.signOutWithContext(context);
        },
      ),
    ];
  }
}
