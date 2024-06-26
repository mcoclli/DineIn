import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reservation/core/constants/app_colors.dart';
import 'package:reservation/core/extensions/extension.dart';

class BottomNavbar extends StatefulWidget {
  final int pageid;
  const BottomNavbar({super.key, required this.pageid});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      height: context.dynamicHeight(0.07),
      padding: EdgeInsets.only(top: context.height / 100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          item(
            icon: 'person',
            pageName: "profilePage",
            id: 0,
          ),
          // item(
          //   icon: 'shop',
          //   pageName: "shopPage",
          //   id: 1,
          // ),
          // item(
          //   icon: 'home',
          //   pageName: "homePage",
          //   id: 2,
          // ),
          // item(
          //   icon: 'favorite',
          //   pageName: "favoritePage",
          //   id: 3,
          // ),
          item(
            icon: 'notification',
            pageName: "reservationRequestsPage",
            id: 4,
          ),
        ],
      ),
    );
  }

  Widget item({
    required String icon,
    required String pageName,
    required int id,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pushNamedAndRemoveUntil(
            context, "/$pageName", (route) => false);
      },
      child: SvgPicture.asset(
        'assets/icons/bottom_navbar/$icon.svg',
        height: 25,
        color:
            widget.pageid == id ? AppColors.consumed : AppColors.flataluminum,
      ),
    );
  }
}
