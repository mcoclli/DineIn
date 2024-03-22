import 'package:flutter/material.dart';
import 'package:reservation/core/extensions/extension.dart';
import 'package:reservation/feature/home_page/model/category_model.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key, required CategoryModel model})
      : _model = model;

  final CategoryModel _model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.pagePaddingRigth,
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            child: _model.imagePath,
          ),
          SizedBox(
            height: context.dynamicHeight(0.01),
          ),
          Text(_model.title),
        ],
      ),
    );
  }
}
