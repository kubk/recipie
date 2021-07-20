import 'package:flutter/cupertino.dart';
import 'package:recipie/model/category.dart';
import 'package:recipie/model/recipe.dart';
import 'package:recipie/service/category-repository.dart';
import 'package:recipie/service/recipe-repository.dart';

class RecipeNotifier extends ChangeNotifier {
  final CategoryRepository categoryRepository;
  final RecipeRepository recipeRepository;

  RecipeNotifier(this.categoryRepository, this.recipeRepository);

  List<Category> categories = [];
  List<Recipe> recipes = [];

  String? selectedCategoryId;
  String? selectedRecipeId;

  selectCategory(String categoryId) {
    this.selectedCategoryId = categoryId;
  }

  selectRecipe(String recipeId) {
    this.selectedRecipeId = recipeId;
  }

  List<Recipe> get filteredRecipes => recipes
      .where((element) => element.categoryId == selectedCategoryId)
      .toList();

  Recipe get selectedRecipe =>
      recipes.firstWhere((element) => element.id == selectedRecipeId);

  void loadRecipes() async {
    this.categoryRepository.getCategories().then((value) {
      categories = value;
      notifyListeners();
    });

    this.recipeRepository.getRecipes().then((value) {
      recipes = value;
      notifyListeners();
    });
  }
}
