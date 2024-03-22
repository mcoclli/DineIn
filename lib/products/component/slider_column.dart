import 'package:flutter/material.dart';
import 'package:reservation/core/constants/app_colors.dart';
import 'package:reservation/products/component/custom_slider.dart';
import 'package:reservation/core/extensions/extension.dart';

class SliderColumnWidget extends StatefulWidget {
  final String text;
  final double num;
  const SliderColumnWidget({
    super.key,
    required this.text,
    required this.num,
  });

  @override
  State<SliderColumnWidget> createState() => _SliderColumnWidgetState();
}

class _SliderColumnWidgetState extends State<SliderColumnWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.text,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(
          width: context.dynamicWidth(0.02),
        ),
        CustomSlider(
          percentage: widget.num,
        ),
      ],
    );
  }
}
