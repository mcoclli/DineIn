import 'package:flutter/material.dart';
import 'package:reservation/core/constants/app_colors.dart';
import 'package:reservation/core/constants/app_string.dart';
import 'package:reservation/core/constants/image_const.dart';
import 'package:reservation/core/extensions/extension.dart';
import 'package:reservation/core/util/common_utils.dart';
import 'package:reservation/feature/profile_page/model/menu_item_model.dart';

class MenuItemCard extends StatefulWidget {
  const MenuItemCard({
    super.key,
    required this.itemModel,
    this.updateFunction,
    this.imageRefreshFunction,
  });

  final MenuItemModel itemModel;
  final void Function(MenuItemModel itemModel)? updateFunction;
  final void Function()? imageRefreshFunction;

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
    _nameController.text = widget.itemModel.name ?? "";
    _descriptionController.text = widget.itemModel.description ?? "";
    _priceController.text = "${widget.itemModel.price ?? 0.0}";
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              SizedBox(
                width: context.dynamicWidth(0.30),
                height: context.dynamicHeight(0.14),
                child: CloudImage(
                    name: widget.itemModel.imageUrl,
                    type: 'menu-item',
                    isUploadAllowed: true,
                    refreshFunction: () async {
                      CommonUtils.log("refreshing the model for restaurant");
                      if (widget.imageRefreshFunction != null) {
                        widget.imageRefreshFunction!();
                      }
                    }),
              ),
              _isEditing
                  ? Center(
                      child: SizedBox(
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FloatingActionButton(
                              onPressed: () {
                                widget.itemModel.name = _nameController.text;
                                widget.itemModel.description =
                                    _descriptionController.text;
                                widget.itemModel.price =
                                    double.parse(_priceController.text);
                                if (widget.updateFunction != null) {
                                  widget.updateFunction!(widget.itemModel);
                                }
                                setState(() {
                                  _isEditing = false;
                                });
                              },
                              child: const Icon(Icons.save),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            FloatingActionButton(
                              onPressed: () {
                                _nameController.text =
                                    widget.itemModel.name ?? "";
                                _descriptionController.text =
                                    widget.itemModel.description ?? "";
                                _priceController.text =
                                    "${widget.itemModel.price}";
                                setState(() {
                                  _isEditing = false;
                                });
                              },
                              child: const Icon(Icons.undo),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container()
            ],
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
                            widget.itemModel.name ?? "Item Name",
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
                            widget.itemModel.description ?? "Item Description",
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
                                  "\$${widget.itemModel.price ?? 0.0}",
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
