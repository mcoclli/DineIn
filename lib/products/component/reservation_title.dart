import 'package:flutter/material.dart';
import 'package:reservation/core/constants/app_colors.dart';
import 'package:reservation/core/constants/app_string.dart';
import 'package:reservation/products/component/time_container_widget.dart';
import 'package:reservation/core/extensions/extension.dart';

class ReservationCategoryItem extends StatelessWidget {
  const ReservationCategoryItem({
    super.key,
    required this.title,
    required this.items,
  });

  final String title;
  final List items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            const Icon(
              Icons.date_range_outlined,
              color: AppColors.outoftheblue,
            ),
            SizedBox(
              width: context.dynamicWidth(0.03),
            ),
            Text(
              StringConstant.book,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.outoftheblue,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const TimeContainer(),
        ...items,
      ],
    );
  }
}
