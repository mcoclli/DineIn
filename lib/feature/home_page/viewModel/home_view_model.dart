import 'package:flutter/material.dart';
import 'package:reservation/feature/home_page/model/category_model.dart';
import 'package:reservation/feature/home_page/model/favorite_model.dart';
import 'package:reservation/feature/home_page/model/menu_draw_model.dart';

class HomeViewModel extends ChangeNotifier {
  late final List<CategoryModel> _catItem = CategoryItems().items;
  List<CategoryModel> get catModel => _catItem;

  late final List<HomeFavoriteModel> _favItem = HomeFavoriteItems().items;
  List<HomeFavoriteModel> get favModel => _favItem;

  late final List<DrawModel> _drawItem;
  List<DrawModel> drawModel(BuildContext context) {
    try {
      _drawItem.isEmpty;
    } catch (e) {
      _drawItem = DrawItems(context: context).items;
    }
    return _drawItem;
  }

  categoryToList(CategoryModel catModel) {
    _catItem.contains(catModel);
    notifyListeners();
  }

  favoriteToList(HomeFavoriteModel favModel) {
    _favItem.contains(favModel);
    notifyListeners();
  }

  drawToList(DrawModel drawModel) {
    _drawItem.contains(drawModel);
    notifyListeners();
  }

  bool menuOpenMi = false;
  menuOpenClose() {
    menuOpenMi = !menuOpenMi;
    notifyListeners();
  }
}
