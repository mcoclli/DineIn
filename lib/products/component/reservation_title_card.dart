import 'package:flutter/material.dart';
import 'package:reservation/core/constants/app_colors.dart';
import 'package:reservation/core/extensions/extension.dart';

class ReservationCard extends StatelessWidget {
  const ReservationCard({
    super.key,
    required this.image,
    required this.name,
    required this.title,
    required this.price,
  });

  final String image, title, name;
  final double price;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DefaultTextStyle(
            style: const TextStyle(color: AppColors.silverlined),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Padding(
                  padding: context.paddingLowVertical,
                  child: Text(
                    name,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
