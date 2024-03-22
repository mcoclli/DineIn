import 'package:flutter/material.dart';
import 'package:reservation/core/constants/app_colors.dart';
import 'package:reservation/core/extensions/extension.dart';
import 'package:reservation/core/util/common_utils.dart';
import 'package:reservation/feature/home_page/model/menu_draw_model.dart';

class MenuList extends StatelessWidget {
  const MenuList({super.key, required DrawModel model}) : _model = model;

  final DrawModel _model;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.middlePadding,
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () {
            CommonUtils.log("Pressed : ${_model.onClicked}");
            _model.onClicked!();
          },
          icon: _model.icon,
          label: Text(
            _model.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.white,
                ),
          ),
        ),
      ),
    );
  }
}
