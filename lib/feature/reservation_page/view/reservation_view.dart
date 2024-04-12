import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reservation/core/constants/app_colors.dart';
import 'package:reservation/core/constants/app_string.dart';
import 'package:reservation/core/extensions/extension.dart';
import 'package:reservation/core/util/common_utils.dart';
import 'package:reservation/feature/profile_page/model/menu_item_model.dart';
import 'package:reservation/feature/profile_page/model/restaurant_model.dart';
import 'package:reservation/feature/reservation_page/model/reservation_model.dart';
import 'package:reservation/feature/reservation_page/viewModel/reservation_view_model.dart';
import 'package:reservation/main.dart';
import 'package:reservation/products/component/animated_fab.dart';
import 'package:reservation/products/component/menu_title.dart';
import 'package:reservation/products/component/menu_title_card.dart';
import 'package:reservation/products/component/person_date_time_widget.dart';
import 'package:reservation/products/component/reservation_appbar.dart';
import 'package:reservation/products/component/reservation_info.dart';
import 'package:reservation/products/component/table_item_card.dart';
import 'package:reservation/products/widgets/bottom_navbar.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({super.key, required this.model});

  final RestaurantModel model;

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool processingRequest = false;

  List<ReservationModel>? reservations;
  String? _selectedTableId;
  final Map<String, int> _menuItemQty = {};

  @override
  void initState() {
    super.initState();
    Provider.of<ReservationViewModel>(context, listen: false)
        .fetchReservations(widget.model, forced: true);
    _selectedTableId = widget.model.tables.firstOrNull?.id;
    processingRequest = false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    reservations =
        Provider.of<ReservationViewModel>(context).currentReservations;

    return Stack(
      children: [
        Scaffold(
          bottomNavigationBar: const BottomNavbar(pageid: 1),
          backgroundColor: AppColors.white,
          body: Consumer(
            builder: ((context, value, child) {
              return CustomScrollView(
                slivers: [
                  RestaurantAppBar(
                    restaurant: widget.model,
                  ),
                  SliverToBoxAdapter(
                    child: RestaurantInfo(
                      restaurant: widget.model,
                    ),
                  ),
                  SliverPadding(
                    padding: context.paddingLowHorizontal,
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, categoryIndex) {
                          return Column(
                            children: [
                              PersonDateTimeWidget(
                                currentRestaurant: widget.model,
                              ),
                              SizedBox(
                                height: context.dynamicHeight(0.03),
                              ),
                              // _reservationCategory(categoryIndex, context),
                              _tables(categoryIndex, context),
                              _menuCategory(categoryIndex, context),
                            ],
                          );
                        },
                        childCount: 1,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
          floatingActionButton: AnimatedFAB(
            tapFunction: () {
              CommonUtils.log("Requesting the reservation");
              _showInputAlert();
            },
          ),
        ),
        if (processingRequest) ...[
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.7), // Semi-transparent overlay
            ),
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth:
                        6, // Increase stroke width for an enhanced look
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      "Processing...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ],
    );
  }

  MenuCategoryItem _menuCategory(int categoryIndex, BuildContext context) {
    var menuList = widget.model.menuItems;
    return MenuCategoryItem(
      title: StringConstant.menuName,
      items: List.generate(
        menuList.length,
        (index) {
          var menuItem = menuList[index];
          return Padding(
            padding: context.pagePaddingBottom,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                MenuCard(menuItem: menuItem),
                _buildCounter(menuItem),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCounter(MenuItemModel menuItem) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.greenAccent,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              var qty = _menuItemQty[menuItem.id] ?? 0;
              if (qty > 0) {
                setState(() {
                  qty--;
                  _menuItemQty[menuItem.id] = qty;
                  // widget.onCountChanged(_count);
                });
              }
              if (qty <= 0) {
                _menuItemQty.remove(menuItem.id);
              }
            },
            child: const Icon(Icons.remove, color: Colors.red),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('${_menuItemQty[menuItem.id] ?? 0}'),
          ),
          InkWell(
            onTap: () {
              setState(() {
                var qty = _menuItemQty[menuItem.id] ?? 0;
                setState(() {
                  qty++;
                  _menuItemQty[menuItem.id] = qty;
                  // widget.onCountChanged(_count);
                });
              });
            },
            child: const Icon(Icons.add, color: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _tables(int categoryIndex, BuildContext context) {
    var tables = widget.model.tables;
    return MenuCategoryItem(
      title: StringConstant.tableName,
      items: List.generate(
        tables.length,
        (index) {
          bool isSelected = tables[index].id == _selectedTableId;
          return Container(
            margin: const EdgeInsets.all(4), // Margin for shadow visibility
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              // Circular edges for the glowing effect
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.green
                            .withOpacity(0.5), // Green glowing effect
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: const Offset(0, 0),
                      ),
                    ]
                  : [],
            ),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                TableItemCard(
                  model: tables[index],
                  allowEditing: false,
                ),
                GestureDetector(
                  onTap: () {
                    CommonUtils.log("Tapped on table");
                    var tableId = tables[index].id;
                    setState(() {
                      _selectedTableId =
                          tableId; // Update the selected table's ID
                    });
                    context.read<ReservationViewModel>().setTableId(tableId);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    // Adjust the margin as needed
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green : Colors.grey,
                      // Green background for the tick mark
                      shape: BoxShape.circle, // Circular shape
                    ),
                    child: const Icon(
                      Icons.check, // Tick mark icon
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showInputAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                  ),
                ),
                TextField(
                  controller: _contactController,
                  decoration: const InputDecoration(
                    hintText: 'Contact Number',
                  ),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    hintText: 'Notes (Optional)',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () async {
                // Validate contact number
                String contactNumber = _contactController.text;
                if (_isValidMobileNumber(contactNumber)) {
                  Navigator.of(context).pop();
                  setState(() {
                    processingRequest = true;
                  });
                  CommonUtils.log(
                      "Requesting reservation $contactNumber, ${_nameController.text}, ${_notesController.text}");
                  await context
                      .read<ReservationViewModel>()
                      .makeReservation(
                        _menuItemQty,
                        _nameController.text,
                        contactNumber,
                        _notesController.text,
                      )
                      .then((value) {
                    CommonUtils.log("Reservation request completed.");
                    setState(() {
                      processingRequest = false;
                    });
                    navigatorKey.currentState!.pop();
                  });
                } else {
                  // Show error for invalid contact number
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid contact number.'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  bool _isValidMobileNumber(String number) {
    // Basic validation for a mobile number
    RegExp regex = RegExp(r'^\+?(\d{10,15})$');
    return regex.hasMatch(number);
  }
}
