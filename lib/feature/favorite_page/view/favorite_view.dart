import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reservation/core/constants/app_colors.dart';
import 'package:reservation/core/constants/app_string.dart';
import 'package:reservation/core/extensions/extension.dart';
import 'package:reservation/feature/favorite_page/viewModel/favorite_view_model.dart';
import 'package:reservation/products/component/favorite_card.dart';
import 'package:reservation/products/widgets/app_bar.dart';
import 'package:reservation/products/widgets/bottom_navbar.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    var favoriList = context.read<FavoriteViewModel>().favoriModel;
    return Scaffold(
      bottomNavigationBar: const BottomNavbar(pageid: 3),
      floatingActionButton: _floatingActionButton(context),
      body: Padding(
        padding: context.pagePadding,
        child: Stack(
          children: [
            Padding(
              padding: context.pageTopPadding,
              child: const AppBarWidget(
                color: AppColors.blueMetallic,
              ),
            ),
            Padding(
              padding: context.topPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringConstant.recomendation,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.blueMetallic,
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    flex: 3,
                    child: Consumer(builder: ((context, value, child) {
                      return GridView.builder(
                        itemCount: favoriList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (BuildContext context, index) {
                          return FavoriteCard(
                            model: favoriList[index],
                          );
                        },
                      );
                    })),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _floatingActionButton(BuildContext context) {
    return Padding(
      padding: context.paddingNormalRigth,
      child: SizedBox(
        height: context.dynamicHeight(0.05),
        width: context.dynamicWidth(0.80),
        child: FloatingActionButton.extended(
          backgroundColor: AppColors.palatinateBlue,
          foregroundColor: AppColors.white,
          onPressed: () {},
          label: Text(
            StringConstant.order,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
