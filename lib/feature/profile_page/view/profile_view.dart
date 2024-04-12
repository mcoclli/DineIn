import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reservation/core/constants/app_colors.dart';
import 'package:reservation/core/constants/image_const.dart';
import 'package:reservation/core/extensions/extension.dart';
import 'package:reservation/core/util/common_utils.dart';
import 'package:reservation/feature/login_register_page/model/users_model.dart';
import 'package:reservation/feature/profile_page/view/restaurant_view.dart';
import 'package:reservation/feature/profile_page/viewModel/profil_view_model.dart';
import 'package:reservation/feature/profile_page/viewModel/restaurant_view_model.dart';
import 'package:reservation/products/component/menu_list.dart';
import 'package:reservation/products/widgets/bottom_navbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late double screenHeight, screenWidth;
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  late Animation<double> scaleMenuAnimation;
  late Animation<Offset> menuOffsetAnimation;
  final TextEditingController _fullNameController = TextEditingController();
  bool _isEditing = false;

  final Duration duration = const Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    // Fetch the user profile
    CommonUtils.log("Start fetching user data");
    final profileState = Provider.of<ProfileViewModel>(context, listen: false);
    profileState.fetchUserModelWithRetry().then((success) {
      CommonUtils.log("User data fetched, getting restaurant. success : $success");
      // After fetching the user, fetch the restaurant
      Provider.of<RestaurantViewModel>(context, listen: false)
          .fetchRestaurantModel(profileState.loggedInUser.restaurantRef!);
    });
    controller = AnimationController(vsync: this, duration: duration);
    scaleAnimation = Tween(begin: 1.0, end: 0.6).animate(controller);
    scaleMenuAnimation = Tween(begin: 0.0, end: 1.0).animate(controller);
    menuOffsetAnimation =
        Tween(begin: const Offset(-1, 0), end: const Offset(0, 0))
            .animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));
    controller.reset();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

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
      bottomNavigationBar: context.watch<ProfileViewModel>().menuOpenMi == false
          ? const BottomNavbar(pageid: 0)
          : SafeArea(
        child: Stack(
          children: <Widget>[
            menuOlustur(context),
            dashBoardOlustur(context, profileProvider, restaurantState),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            menuOlustur(context),
            dashBoardOlustur(context, profileProvider, restaurantState),
          ],
        ),
      ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       _stackWidget(context, profileProvider, restaurantState),
      //       _adminText(context, loggedInUser),
      //       const RestaurantView(),
      //     ],
      //   ),
      // ),
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

  Widget dashBoardOlustur(BuildContext context, ProfileViewModel profileProvider, RestaurantViewModel restaurantState) {
    var loggedInUser = profileProvider.loggedInUser;
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      left: context.watch<ProfileViewModel>().menuOpenMi ? 0.26 * screenWidth : 0,
      right: context.watch<ProfileViewModel>().menuOpenMi ? -0.26 * screenWidth : 0,
      bottom: 0,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Material(
          borderRadius: context.watch<ProfileViewModel>().menuOpenMi
              ? context.radiusAll
              : null,
          elevation: 0,
          child: Padding(
            padding: context.pagePadding,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _appBar(context, restaurantState),
                  _stackWidget(context, profileProvider, restaurantState),
                  _adminText(context, loggedInUser),
                  const RestaurantView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget menuOlustur(BuildContext context) {
    var drawList = context.read<ProfileViewModel>().drawModel(context);
    var loggedInUser = Provider.of<ProfileViewModel>(context).loggedInUser;
    return SlideTransition(
      position: menuOffsetAnimation,
      child: ScaleTransition(
        scale: scaleMenuAnimation,
        child: Container(
          color: AppColors.california,
          child: Column(
            children: [
              Padding(
                padding: context.dashPadding,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.white,
                      radius: 60,
                      child: ClipOval(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: CloudImage(
                          name: loggedInUser.profileUrl,
                          type: 'profile-pic',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: context.dynamicWidth(0.03),
                    ),
                    Consumer(builder: ((context, value, child) {
                      return Text(
                        '${context.read<ProfileViewModel>().loggedInUser.fullName}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold),
                      );
                    }))
                  ],
                ),
              ),
              SizedBox(
                height: context.dynamicHeight(0.1),
              ),
              Expanded(
                child: Consumer(
                  builder: ((context, value, child) {
                    return ListView.builder(
                        itemCount: drawList.length,
                        itemBuilder: (context, index) {
                          return MenuList(
                            model: drawList[index],
                          );
                        });
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container _appBar(BuildContext context, RestaurantViewModel restaurantState) {
    return Container(
      color: Colors.transparent,
      padding: context.pagePaddingRigth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Consumer(
            builder: ((context, value, child) {
              return InkWell(
                  onTap: () {
                    if (context.read<ProfileViewModel>().menuOpenMi) {
                      controller.reverse();
                    } else {
                      controller.forward();
                    }
                    context.read<ProfileViewModel>().menuOpenClose();
                  },
                  child: SvgImage(name: ImageItems().menu));
            }),
          ),
          const SizedBox(width: 8,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.location_on_outlined,
                  color: AppColors.metropolitan.withOpacity(0.2)),
              SizedBox(
                width: context.dynamicWidth(0.75),
                child: Text(
                  "${restaurantState.currentRestaurant?.address}",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.anon,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
