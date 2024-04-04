import 'package:flutter/material.dart';
import 'package:reservation/core/constants/app_colors.dart';
import 'package:reservation/core/constants/app_string.dart';
import 'package:reservation/core/constants/image_const.dart';
import 'package:reservation/core/extensions/extension.dart';

class MenuItemCard extends StatefulWidget {
  const MenuItemCard({
    super.key,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.price,
  });

  final String name, description;
  final String? imageUrl;
  final double price;

  @override
  State<MenuItemCard> createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  bool _isEditing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _nameController.text = widget.name;
    _descriptionController.text = widget.description;
    _priceController.text = "${widget.price}";
    return SizedBox(
      height: context.dynamicHeight(0.2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: context.dynamicWidth(0.30),
            height: context.dynamicHeight(0.14),
            child: CloudImage(
              name: widget.imageUrl,
              type: 'menu-item',
            ),
          ),
          SizedBox(width: context.dynamicWidth(0.05)),
          Expanded(
            child: DefaultTextStyle(
              style: const TextStyle(color: AppColors.silverlined),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                    child: _isEditing
                        ? TextFormField(
                            controller: _nameController,
                            autofocus: true,
                          )
                        : Text(
                            widget.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                  ),
                  SizedBox(
                    height: context.dynamicHeight(0.01),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                    child: _isEditing
                        ? TextFormField(
                            controller: _descriptionController,
                            autofocus: true,
                          )
                        : Text(
                            widget.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                  ),
                  SizedBox(
                    height: context.dynamicHeight(0.01),
                  ),
                  Row(
                    children: [
                      const Text(StringConstant.price),
                      SizedBox(
                        width: context.dynamicWidth(0.02),
                      ),
                      SizedBox(
                        width: context.dynamicWidth(0.02),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: context.dynamicWidth(0.4),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isEditing = true;
                            });
                          },
                          child: _isEditing
                              ? TextFormField(
                                  controller: _priceController,
                                  autofocus: true,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                )
                              : Text(
                                  "\$${widget.price}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: AppColors.california,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
