import 'package:flutter/cupertino.dart';
import 'package:recipie/model/category.dart';
import 'package:recipie/model/recipe.dart';

class RecipeStore extends ChangeNotifier {
  List<Category> categories = [
    Category('1', 'Супы'),
    Category('2', 'Торты'),
    Category('3', 'Рулеты'),
    Category('4', 'Пироги'),
  ];

  List<Recipe> recipes = [
    Recipe('1', 'Красный бархат', 'Красный нежный торт', '', '2'),
  ];

  String? selectedCategoryId;
  String? selectedRecipeId;

  List<Recipe> get filteredRecipes => recipes
      .where((element) => element.categoryId == selectedCategoryId)
      .toList();

  Recipe get selectedRecipe =>
      recipes.firstWhere((element) => element.id == selectedRecipeId);

  selectCategory(String categoryId) {
    this.selectedCategoryId = categoryId;
  }

  selectRecipe(String recipeId) {
    this.selectedRecipeId = recipeId;
  }
}
