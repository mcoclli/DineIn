import 'package:flutter/material.dart';
import 'package:reservation/core/constants/app_colors.dart';
import 'package:reservation/core/constants/app_string.dart';
import 'package:reservation/core/constants/image_const.dart';
import 'package:reservation/core/extensions/extension.dart';
import 'package:reservation/feature/profile_page/model/menu_item_model.dart';

class MenuCard extends StatelessWidget {
  const MenuCard({
    super.key,
    required this.menuItem,
  });

  final MenuItemModel menuItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: context.dynamicWidth(0.30),
          height: context.dynamicHeight(0.13),
          child: CloudImage(
            name: menuItem.imageUrl,
            type: "menu-item",
          ),
        ),
        SizedBox(width: context.dynamicWidth(0.05)),
        Expanded(
          child: DefaultTextStyle(
            style: const TextStyle(color: AppColors.silverlined),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menuItem.name ?? "Name",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                SizedBox(
                  height: context.dynamicHeight(0.01),
                ),
                Text(
                  menuItem.description ?? "description",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: context.dynamicHeight(0.01),
                ),
                Row(
                  children: [
                    const Text(StringConstant.price),
                    SizedBox(
                      width: context.dynamicWidth(0.02),
                    ),
                    const CircleAvatar(
                      radius: 2,
                      backgroundColor: AppColors.darkGrey,
                    ),
                    const Spacer(),
                    Text(
                      "\$${menuItem.price}",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.california,
                            fontWeight: FontWeight.w500,
                          ),
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
