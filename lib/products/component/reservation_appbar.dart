import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:reservation/core/constants/app_colors.dart';
import 'package:reservation/core/constants/image_const.dart';
import 'package:reservation/core/extensions/extension.dart';
import 'package:reservation/feature/profile_page/model/restaurant_model.dart';

class RestaurantAppBar extends StatelessWidget {
  final RestaurantModel restaurant;
  const RestaurantAppBar({
    super.key, required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [
      CloudImage(name: restaurant.baseImageUrl, type: "restaurant-banner"),
      const PngImage(name: ImageItems.resto4),
      const PngImage(name: ImageItems.resto1),
    ];
    return SliverAppBar(
      expandedHeight: context.dynamicHeight(0.21),
      backgroundColor: AppColors.white,
      elevation: 0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: _stackWidget(list, context),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: AppColors.white,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: AppColors.white,
            child: IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }

  Stack _stackWidget(List<Widget> list, BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 1.0,
            enlargeCenterPage: false,
          ),
          items: list
              .map((item) => SizedBox(
                  height: context.dynamicHeight(0.10),
                  width: MediaQuery.of(context).size.width,
                  child: item))
              .toList(),
        ),
      ],
    );
  }
}
