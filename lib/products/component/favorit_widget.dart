import 'package:flutter/material.dart';
import 'package:reservation/core/extensions/extension.dart';
import 'package:reservation/feature/home_page/model/favorite_model.dart';

class FavoriteWidget extends StatelessWidget {
  const FavoriteWidget({super.key, required HomeFavoriteModel model})
      : _model = model;

  final HomeFavoriteModel _model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.pagePaddingRigth,
      child: Column(
        children: [
          Container(
            height: context.dynamicHeight(0.20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
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
