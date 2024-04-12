import 'package:flutter/material.dart';
import 'package:reservation/core/constants/app_colors.dart';
import 'package:reservation/core/constants/app_string.dart';
import 'package:reservation/core/constants/image_const.dart';
import 'package:reservation/core/extensions/extension.dart';
import 'package:reservation/core/util/common_utils.dart';
import 'package:reservation/feature/profile_page/model/restaurant_model.dart';
import 'package:reservation/feature/reservation_page/view/reservation_view.dart';

class OpenRestWidget extends StatelessWidget {
  const OpenRestWidget({super.key, required RestaurantModel model})
      : _model = model;

  final RestaurantModel _model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CommonUtils.log("clicked on ${_model.restaurantRef}");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReservationsPage(
              model: _model,
            ),
          ),
        );
      },
      child: Container(
        height: context.dynamicHeight(0.14),
        width: context.dynamicWidth(0.80),
        decoration: context.boxDecoraiton,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              width: 150,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: CloudImage(
                      name: _model.baseImageUrl, type: "restaurant-banner"),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: context.dynamicWidth(0.6),
                  child: Text(
                    _model.name ?? "Restaurant Name",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.blueMetallic,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: context.dynamicHeight(0.01),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on_outlined,
                        color: Colors.black26),
                    SizedBox(
                      width: context.dynamicWidth(0.5),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _model.address ?? "Location",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color: AppColors.black.withOpacity(0.2),
                                  fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: context.dynamicHeight(0.01),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(_model.cuisine ?? "Cuisine"),
                    SizedBox(
                      width: context.dynamicWidth(0.03),
                    ),
                    SizedBox(
                      width: context.dynamicWidth(0.03),
                    ),
                    const Icon(
                      Icons.call,
                      size: 20,
                    ),
                    SizedBox(
                      width: context.dynamicWidth(0.02),
                    ),
                    const Text(StringConstant.contact),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
