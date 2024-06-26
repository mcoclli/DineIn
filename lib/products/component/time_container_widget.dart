import 'package:flutter/material.dart';
import 'package:reservation/core/constants/app_colors.dart';
import 'package:reservation/core/extensions/extension.dart';

class TimeContainer extends StatefulWidget {
  const TimeContainer({super.key});

  @override
  State<TimeContainer> createState() => _TimeContainerState();
}

class _TimeContainerState extends State<TimeContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: context.paddingLowHorizontalVertical,
          child: Row(children: [
            const TimeWidget(
              time: '11:00',
            ),
            SizedBox(
              width: context.dynamicWidth(0.03),
            ),
            const TimeWidget(
              time: '11:15',
            ),
            SizedBox(
              width: context.dynamicWidth(0.03),
            ),
            const TimeWidget(
              time: '11:30',
            ),
            SizedBox(
              width: context.dynamicWidth(0.03),
            ),
            const TimeWidget(
              time: '11:45',
            ),
            SizedBox(
              width: context.dynamicWidth(0.03),
            ),
            const TimeWidget(
              time: '12:00',
            ),
            SizedBox(
              width: context.dynamicWidth(0.03),
            ),
            const TimeWidget(
              time: '12:15',
            ),
            SizedBox(
              width: context.dynamicWidth(0.03),
            ),
            const TimeWidget(
              time: '12:30',
            ),
            SizedBox(
              width: context.dynamicWidth(0.03),
            ),
            const TimeWidget(
              time: '12:45',
            ),
            SizedBox(
              width: context.dynamicWidth(0.03),
            ),
          ]),
        ),
      ),
    ]);
  }
}

class TimeWidget extends StatelessWidget {
  final String time;
  const TimeWidget({
    super.key,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.dynamicHeight(0.05),
      width: context.dynamicWidth(0.18),
      decoration: context.timeDecoraiton,
      child: Center(
          child: Text(
        time,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.white,
            ),
      )),
    );
  }
}
