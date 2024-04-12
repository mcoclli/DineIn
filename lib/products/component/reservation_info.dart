import 'package:flutter/material.dart';
import 'package:reservation/core/constants/app_colors.dart';
import 'package:reservation/core/extensions/extension.dart';
import 'package:reservation/feature/profile_page/model/restaurant_model.dart';

class RestaurantInfo extends StatelessWidget {
  final RestaurantModel restaurant;

  const RestaurantInfo({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            restaurant.name ?? "Restaurant",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: AppColors.blueMetallic),
          ),
          SizedBox(
            height: context.dynamicHeight(0.01),
          ),
          Row(
            children: [
              const Icon(Icons.local_atm),
              SizedBox(
                width: context.dynamicWidth(0.03),
              ),
              Text(
                restaurant.meanCost ?? "mean cost",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.silverlined,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                width: context.dynamicWidth(0.03),
              ),
              const Icon(Icons.restaurant),
              SizedBox(
                width: context.dynamicWidth(0.03),
              ),
              Text(
                restaurant.cuisine ?? "cuisine",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.silverlined,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          SizedBox(
            height: context.dynamicHeight(0.01),
          ),
          Row(
            children: [
              const Icon(Icons.location_on_outlined),
              SizedBox(
                width: context.dynamicWidth(0.03),
              ),
              Text(
                restaurant.address ?? "location",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.silverlined,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
