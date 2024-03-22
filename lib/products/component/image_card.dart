import 'package:flutter/material.dart';
import 'package:reservation/core/extensions/extension.dart';
import 'package:reservation/feature/profile_page/model/image_model.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({
    super.key,
    required ImageModel model,
  }) : _model = model;
  final ImageModel _model;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.cardPadding,
      child: _model.imagePath,
    );
  }
}
