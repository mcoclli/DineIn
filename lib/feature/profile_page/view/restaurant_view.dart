import 'package:cached_firestorage/cached_firestorage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:reservation/core/constants/app_colors.dart';
import 'package:reservation/core/extensions/extension.dart';
import 'package:reservation/core/util/common_utils.dart';
import 'package:reservation/feature/profile_page/model/restaurant_model.dart';
import 'package:reservation/feature/profile_page/viewModel/profil_view_model.dart';
import 'package:reservation/feature/profile_page/viewModel/restaurant_view_model.dart';
import 'package:reservation/products/component/availability_editor.dart';
import 'package:reservation/products/component/closable_widget.dart';
import 'package:reservation/products/component/menu_item_card.dart';
import 'package:reservation/products/component/table_item_card.dart';

class RestaurantView extends StatefulWidget {
  const RestaurantView({super.key});

  @override
  State<RestaurantView> createState() => _RestaurantViewState();
}

class _RestaurantViewState extends State<RestaurantView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cuisineController = TextEditingController();
  final TextEditingController _meanCostController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _slotsController = TextEditingController();
  bool _isEditing = false;
  bool _isMenuChanged = false;
  bool _isTablesChanged = false;
  bool _isAvailabilityChanged = false;

  @override
  void initState() {
    super.initState();
    final profileState = Provider.of<ProfileViewModel>(context, listen: false);
    profileState.fetchUserModel().then((_) {
      CommonUtils.log("User data fetched, getting restaurant");
      // After fetching the user, fetch the restaurant
      Provider.of<RestaurantViewModel>(context, listen: false)
          .fetchRestaurantModel(profileState.loggedInUser.restaurantRef!);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cuisineController.dispose();
    _meanCostController.dispose();
    _addressController.dispose();
    _slotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var profileProvider = Provider.of<ProfileViewModel>(context, listen: false);
    final restaurantState = Provider.of<RestaurantViewModel>(context);
    // Ensure the restaurant is fetched after the user is loaded
    if (profileProvider.loggedInUser.restaurantRef != null &&
        restaurantState.currentRestaurant == null) {
      restaurantState
          .fetchRestaurantModel(profileProvider.loggedInUser.restaurantRef!);
    }
    var restaurant = restaurantState.currentRestaurant;
    _nameController.text = restaurant?.name ?? '';
    _cuisineController.text = restaurant?.cuisine ?? '';
    _meanCostController.text = restaurant?.meanCost ?? '';
    _addressController.text = restaurant?.address ?? '';
    _slotsController.text = "${restaurant?.maxConsecutiveSlots ?? 1}";
    if (restaurant != null) {
      return Padding(
        padding: context.pagePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _isEditing
                ? Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FloatingActionButton(
                          onPressed: () {
                            _executeDataUpdate(restaurant, restaurantState);
                          },
                          child: const Icon(Icons.save),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            setState(() {
                              _isEditing = false;
                            });
                          },
                          child: const Icon(Icons.undo),
                        ),
                      ],
                    ),
                  )
                : Container(),
            Center(
              child: GestureDetector(
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
                        "${restaurant.name}",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                color: AppColors.blueMetallic,
                                fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            Row(
              children: [
                const Icon(Icons.local_atm),
                SizedBox(
                  width: context.dynamicWidth(0.03),
                ),
                SizedBox(
                  width: context.dynamicWidth(0.8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                    child: _isEditing
                        ? TextFormField(
                            controller: _meanCostController,
                            autofocus: true,
                          )
                        : Text(
                            "${restaurant.meanCost}",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppColors.silverlined,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                  ),
                ),
                SizedBox(
                  width: context.dynamicWidth(0.03),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.restaurant),
                SizedBox(
                  width: context.dynamicWidth(0.03),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  child: SizedBox(
                    height: 25,
                    width: context.dynamicWidth(0.8),
                    child: _isEditing
                        ? TextFormField(
                            controller: _cuisineController,
                            autofocus: true,
                          )
                        : Text(
                            "${restaurant.cuisine}",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppColors.silverlined,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.location_on_outlined),
                SizedBox(
                  width: context.dynamicWidth(0.03),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  child: SizedBox(
                    height: 25,
                    width: context.dynamicWidth(0.8),
                    child: _isEditing
                        ? TextFormField(
                            controller: _addressController,
                            autofocus: true,
                          )
                        : Text(
                            "${restaurant.address}",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppColors.silverlined,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "Consecutive Slots",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.silverlined,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(
                  width: context.dynamicWidth(0.03),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  child: SizedBox(
                    height: 25,
                    width: context.dynamicWidth(0.5),
                    child: _isEditing
                        ? TextFormField(
                            controller: _slotsController,
                            autofocus: true,
                          )
                        : Text(
                            "${restaurant.maxConsecutiveSlots}",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppColors.silverlined,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: context.paddingNormalVertical,
                  child: Row(
                    children: [
                      Text(
                        "Menu",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.black,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(width: 20),
                      _isMenuChanged
                          ? GestureDetector(
                              onTap: () {
                                CommonUtils.log("Saving menu items");
                                restaurantState.updateRestaurant(
                                    restaurantState.currentRestaurant!);
                                setState(() {
                                  _isMenuChanged = false;
                                });
                              },
                              child: const Icon(Icons.save),
                            )
                          : Container(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ...(restaurant.menuItems ?? []).map((item) {
                  return Padding(
                    padding: context.pagePaddingBottom,
                    child: ClosableWidget(
                      closeFunction: () async {
                        CommonUtils.log(
                            "Removing menu item ${item.id} from menu");
                        restaurantState.removeMenuItem(item.id);
                        FirebaseStorage.instance
                            .ref(item.imageUrl!)
                            .delete()
                            .then((value) async {
                          CommonUtils.log(
                              "Image was deleted for url ${item.imageUrl}");
                          await DefaultCacheManager()
                              .removeFile(item.imageUrl!)
                              .then((value) {
                            CachedFirestorage.instance
                                .removeCacheEntry(mapKey: item.imageUrl!);
                          });
                        });

                        setState(() {
                          _isMenuChanged = true;
                        });
                      },
                      child: MenuItemCard(
                        itemModel: item,
                        updateFunction: (itemModel) {
                          restaurantState.updateMenuItem(itemModel);
                          setState(() {
                            _isMenuChanged = true;
                          });
                        },
                        imageRefreshFunction: () {
                          restaurantState.fetchRestaurantModel(
                            profileProvider.loggedInUser.restaurantRef!,
                            forced: true,
                          );
                        },
                      ),
                    ),
                  );
                }),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: CircleAvatar(
                    radius: 20, // Adjust the size of the button
                    backgroundColor: Colors.blue, // Button color
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        CommonUtils.log("Adding new menu item");
                        restaurantState.addEmptyMenuItem();
                        setState(() {
                          _isEditing = false;
                          _isMenuChanged = true;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: context.paddingNormalVertical,
                  child: Row(
                    children: [
                      Text(
                        "Table",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.black,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(width: 20),
                      _isTablesChanged
                          ? GestureDetector(
                              onTap: () {
                                CommonUtils.log("Saving table items");
                                restaurantState.updateRestaurant(
                                    restaurantState.currentRestaurant!);
                                setState(() {
                                  _isTablesChanged = false;
                                });
                              },
                              child: const Icon(Icons.save),
                            )
                          : Container(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ...(restaurant.tables ?? []).map((item) {
                  return Padding(
                    padding: context.pagePaddingBottom,
                    child: ClosableWidget(
                      closeFunction: () async {
                        CommonUtils.log("Removing table ${item.id}");
                        restaurantState.removeTable(item.id);
                        setState(() {
                          _isTablesChanged = true;
                        });
                      },
                      child: TableItemCard(
                        model: item,
                        updateFunction: (itemModel) {
                          restaurantState.updateTable(itemModel);
                          setState(() {
                            _isTablesChanged = true;
                          });
                        },
                      ),
                    ),
                  );
                }),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: CircleAvatar(
                    radius: 20, // Adjust the size of the button
                    backgroundColor: Colors.blue, // Button color
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        CommonUtils.log("Adding new table");
                        restaurantState.addEmptyTable();
                        setState(
                          () {
                            _isEditing = false;
                            _isTablesChanged = true;
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: context.paddingNormalVertical,
                  child: Row(
                    children: [
                      Text(
                        "Availability",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.black,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(width: 20),
                      _isAvailabilityChanged
                          ? GestureDetector(
                              onTap: () {
                                CommonUtils.log("Saving availability");
                                restaurantState.updateRestaurant(
                                    restaurantState.currentRestaurant!);
                                setState(() {
                                  _isAvailabilityChanged = false;
                                });
                              },
                              child: const Icon(Icons.save),
                            )
                          : Container(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                AvailabilityEditor(
                  availability: restaurant.availability,
                  updateFunction: () {
                    setState(() {
                      _isAvailabilityChanged = true;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return const CircularProgressIndicator.adaptive();
    }
  }

  void _executeDataUpdate(
      RestaurantModel restaurant, RestaurantViewModel restaurantState) {
    final displayName = _nameController.text.trim();
    final cuisine = _cuisineController.text.trim();
    final meanCost = _meanCostController.text.trim();
    final address = _addressController.text.trim();
    if (displayName.isNotEmpty) {
      restaurant.name = displayName;
    }
    if (cuisine.isNotEmpty) {
      restaurant.cuisine = cuisine;
    }
    if (meanCost.isNotEmpty) {
      restaurant.meanCost = meanCost;
    }
    if (address.isNotEmpty) {
      restaurant.address = address;
    }
    restaurantState.updateRestaurant(restaurant);
    setState(() {
      _isEditing = false;
    });
  }
}
