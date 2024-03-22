import 'package:flutter/material.dart';
import 'package:reservation/core/extensions/extension.dart';

class CustomSlider extends StatelessWidget {
  final double percentage;

  const CustomSlider({
    super.key,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.dynamicWidth(0.49),
      height: MediaQuery.of(context).size.height / 80,
      decoration: context.slidermiddelDecoraiton,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            decoration: context.sliderDecoraiton,
            width: (percentage / 100) * 200.0,
          ),
        ],
      ),
    );
  }
}
