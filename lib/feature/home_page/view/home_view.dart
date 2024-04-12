import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reservation/core/constants/app_colors.dart';
import 'package:reservation/core/constants/app_string.dart';
import 'package:reservation/core/extensions/extension.dart';
import 'package:reservation/feature/home_page/model/restaurants_provider.dart';
import 'package:reservation/feature/home_page/viewModel/home_view_model.dart';
import 'package:reservation/products/component/category_widget.dart';
import 'package:reservation/products/component/open_rest_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    Provider.of<RestaurantsProvider>(context, listen: false).fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: context.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: context.dynamicHeight(0.3),
                child: Column(
                  children: [
                    _textFormField(context),
                    Expanded(
                      flex: 2,
                      child: _categoryListView(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              SingleChildScrollView(
                child: SizedBox(
                  height: context.dynamicHeight(0.535),
                  child: Column(
                    children: [
                      // Text(
                      //   StringConstant.favrestaurat,
                      //   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      //       color: AppColors.blueMetallic,
                      //       fontWeight: FontWeight.bold),
                      // ),
                      // SizedBox(
                      //   height: context.dynamicHeight(0.01),
                      // ),
                      // Expanded(
                      //   flex: 1,
                      //   child: _favoriteListView(),
                      // ),
                      SizedBox(
                        height: context.dynamicHeight(0.01),
                      ),
                      _openRestaurant(context),
                      SizedBox(
                        height: context.dynamicHeight(0.02),
                      ),
                      Expanded(
                        child: _openListView(),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Consumer<Object?> _openListView() {
    var restaurants =
        Provider.of<RestaurantsProvider>(context).availableRestaurants;
    return Consumer(
      builder: ((context, value, child) {
        return ListView.builder(
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              return OpenRestWidget(model: restaurants[index]);
            });
      }),
    );
  }

  Consumer<Object?> _categoryListView() {
    var catList = context.read<HomeViewModel>().catModel;
    return Consumer(
      builder: ((context, value, child) {
        return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: catList.length,
            itemBuilder: (context, index) {
              return CategoryWidget(model: catList[index]);
            });
      }),
    );
  }

  Widget _openRestaurant(BuildContext context) {
    return Text(
      StringConstant.open,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: AppColors.blueMetallic, fontWeight: FontWeight.bold),
    );
  }

  Column _textFormField(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: context.likePadding,
          child: Text(
            StringConstant.likeEat,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.blueMetallic, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: context.pagePaddingAll,
          decoration: context.boxDecoraiton,
          child: Padding(
            padding: context.pagePaddingRigth,
            child: TextFormField(
                cursorColor: AppColors.california,
                decoration: const InputDecoration(
                  hintText: StringConstant.enter,
                  border: InputBorder.none,
                  suffixIcon: Icon(
                    Icons.search,
                    color: AppColors.california,
                  ),
                )),
          ),
        ),
      ],
    );
  }
}
