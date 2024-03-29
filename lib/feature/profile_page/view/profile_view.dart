import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reservation/core/constants/app_colors.dart';
import 'package:reservation/core/constants/app_string.dart';
import 'package:reservation/core/constants/image_const.dart';
import 'package:reservation/core/extensions/extension.dart';
import 'package:reservation/feature/login_register_page/model/users_model.dart';
import 'package:reservation/feature/profile_page/model/restaurant_model.dart';
import 'package:reservation/feature/profile_page/viewModel/profil_view_model.dart';
import 'package:reservation/feature/profile_page/viewModel/restaurant_view_model.dart';
import 'package:reservation/products/component/image_card.dart';
import 'package:reservation/products/widgets/bottom_navbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileViewModel>().fetchUserModel();
  }

  @override
  Widget build(BuildContext context) {
    var profileProvider = Provider.of<ProfileViewModel>(context);
    var loggedInUser = profileProvider.loggedInUser;
    Provider.of<RestaurantViewModel>(context)
        .fetchRestaurantModel(profileProvider);
    var restaurant = context.read<RestaurantViewModel>().currentRestaurant;
    return Scaffold(
      bottomNavigationBar: const BottomNavbar(pageid: 0),
      body: SingleChildScrollView(
          child: Column(
        children: [
          _stackWidget(context, loggedInUser, restaurant),
          _adminText(context, loggedInUser),
          _restaurantDetails(context, restaurant),
          _reviews(context),
        ],
      )),
    );
  }

  Padding _adminText(BuildContext context, UserModel loggedInUser) {
    return Padding(
      padding: context.pagePadding,
      child: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Consumer(
                builder: ((context, value, child) {
                  return Text(
                    '${loggedInUser.fullName}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.blueMetallic,
                        fontWeight: FontWeight.bold),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _reviews(BuildContext context) {
    return Padding(
      padding: context.pagePadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            StringConstant.review,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.blueMetallic, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: context.dynamicHeight(0.02),
          ),
          SizedBox(
            width: context.dynamicWidth(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const PngImage(name: ImageItems.logImage),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringConstant.hello,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.blueMetallic,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: context.dynamicWidth(0.8),
                      child: Text(
                        StringConstant.text,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.silverlined,
                                ),
                      ),
                    ),
                    SizedBox(
                      height: context.dynamicHeight(0.01),
                    ),
                    Row(children: [
                      for (int i = 0; i < 5; i++)
                        Icon(Icons.star,
                            size: 20,
                            color: i == 4
                                ? AppColors.darkGrey
                                : AppColors.california),
                      SizedBox(
                        width: context.dynamicWidth(0.03),
                      ),
                      Text(
                        StringConstant.number,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.darkGrey,
                            fontWeight: FontWeight.bold),
                      ),
                    ]),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Padding _restaurantDetails(
      BuildContext context, RestaurantModel? restaurant) {
    var imgList = context.read<ProfileViewModel>().imgModel;

    return Padding(
      padding: context.pagePadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "${restaurant?.name}",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.blueMetallic, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: context.dynamicHeight(0.4),
            child: Consumer(
              builder: (context, value, child) {
                return GridView.builder(
                  itemCount: imgList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ImageCard(
                        model: imgList[index],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Stack _stackWidget(BuildContext context, UserModel loggedInUser,
      RestaurantModel? restaurant) {
    return Stack(
      children: [
        Padding(
          padding: context.pageTopPadding,
          child: CloudImage(
            name: restaurant?.baseImageUrl,
            type: 'restaurant-banner',
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
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
