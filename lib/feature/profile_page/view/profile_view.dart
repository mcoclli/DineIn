import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reservation/core/constants/app_colors.dart';
import 'package:reservation/core/constants/app_string.dart';
import 'package:reservation/core/constants/image_const.dart';
import 'package:reservation/core/extensions/extension.dart';
import 'package:reservation/core/util/common_utils.dart';
import 'package:reservation/feature/login_register_page/model/users_model.dart';
import 'package:reservation/feature/profile_page/view/restaurant_view.dart';
import 'package:reservation/products/component/table_item_card.dart';
import 'package:reservation/feature/profile_page/viewModel/profil_view_model.dart';
import 'package:reservation/feature/profile_page/viewModel/restaurant_view_model.dart';
import 'package:reservation/products/widgets/bottom_navbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _fullNameController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // Fetch the user profile
    CommonUtils.log("Start fetching user data");
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
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var profileProvider = Provider.of<ProfileViewModel>(context);
    var loggedInUser = profileProvider.loggedInUser;
    final restaurantState = Provider.of<RestaurantViewModel>(context);
    // Ensure the restaurant is fetched after the user is loaded
    if (profileProvider.loggedInUser.restaurantRef != null &&
        restaurantState.currentRestaurant == null) {
      restaurantState
          .fetchRestaurantModel(profileProvider.loggedInUser.restaurantRef!);
    }
    _fullNameController.text = profileProvider.loggedInUser.fullName ?? '';
    return Scaffold(
      bottomNavigationBar: const BottomNavbar(pageid: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _stackWidget(context, profileProvider, restaurantState),
            _adminText(context, loggedInUser),
            const RestaurantView(),
          ],
        ),
      ),
      floatingActionButton: _isEditing
          ? FloatingActionButton(
              onPressed: () {
                final newFullName = _fullNameController.text.trim();
                if (newFullName.isNotEmpty) {
                  // Update profile in Firestore and locally
                  loggedInUser.fullName = newFullName;
                }
                profileProvider.updateUserProfile(loggedInUser);
                setState(() {
                  _isEditing = false;
                });
              },
              child: const Icon(Icons.save),
            )
          : null,
    );
  }

  Padding _adminText(BuildContext context, UserModel loggedInUser) {
    return Padding(
      padding: context.pagePadding,
      child: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.06,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Consumer(
                builder: ((context, value, child) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                    child: _isEditing
                        ? TextFormField(
                            controller: _fullNameController,
                            autofocus: true,
                          )
                        : Text(
                            '${loggedInUser.fullName}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                    color: AppColors.blueMetallic,
                                    fontWeight: FontWeight.bold),
                          ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stack _stackWidget(BuildContext context, ProfileViewModel profileProvider,
      RestaurantViewModel restaurantState) {
    var loggedInUser = profileProvider.loggedInUser;
    var restaurant = restaurantState.currentRestaurant;
    return Stack(
      children: [
        Padding(
          padding: context.pageTopPadding,
          child: CloudImage(
            name: restaurant?.baseImageUrl,
            type: 'restaurant-banner',
            isUploadAllowed: true,
            refreshFunction: () async {
              CommonUtils.log(
                  "refreshing the model for ${restaurant!.restaurantRef}");
              restaurantState.fetchRestaurantModel(restaurant.restaurantRef!,
                  forced: true);
            },
          ),
        ),
        Padding(
          padding: context.pagePaddingTopLef,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 0),
                      color: Colors.black38,
                      blurRadius: 10)
                ]),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 60,
              child: ClipOval(
                child: CloudImage(
                  name: loggedInUser.profileUrl,
                  type: 'profile-pic',
                  isUploadAllowed: true,
                  refreshFunction: () async {
                    CommonUtils.log("refreshing the model for user");
                    profileProvider.fetchUserModel(forced: true);
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
