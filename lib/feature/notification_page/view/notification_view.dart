import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reservation/core/constants/app_colors.dart';
import 'package:reservation/core/constants/app_string.dart';
import 'package:reservation/core/constants/image_const.dart';
import 'package:reservation/core/extensions/extension.dart';
import 'package:reservation/feature/notification_page/viewModel/notification_view_model.dart';
import 'package:reservation/products/component/notification_card.dart';
import 'package:reservation/products/widgets/app_bar.dart';
import 'package:reservation/products/widgets/bottom_navbar.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    var ntfList = context.read<NotificationViewModel>().ntfModel;
    return Scaffold(
      bottomNavigationBar: const BottomNavbar(pageid: 4),
      body: Column(
        children: [
          Stack(
            children: [
              const PngImage(name: ImageItems.stackImage),
              Padding(
                padding: context.pageTopPadding,
                child: const AppBarWidget(
                  color: AppColors.white,
                ),
              ),
              Padding(
                padding: context.pagePaddingTopLeft,
                child: Text(
                  StringConstant.notificationTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Expanded(
            child: Consumer(
              builder: ((context, value, child) {
                return ListView.builder(
                    itemCount: ntfList.length,
                    itemBuilder: (context, index) {
                      return NotificationCard(model: ntfList[index]);
                    });
              }),
            ),
          )
        ],
      ),
    );
  }
}
