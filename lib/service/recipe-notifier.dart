import 'package:flutter/cupertino.dart';
import 'package:recipie/model/category.dart';
import 'package:recipie/model/recipe.dart';
import 'package:recipie/service/category-repository.dart';
import 'package:recipie/service/recipe-repository.dart';
import 'package:uuid/uuid.dart';

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

  Category get selectedCategory =>
      categories.firstWhere((element) => element.id == selectedCategoryId);

  Recipe get selectedRecipe =>
      recipes.firstWhere((element) => element.id == selectedRecipeId);

  void loadData() {
    _loadCategories();
    _loadRecipes();
  }

  _loadCategories() {
    this.categoryRepository.getCategories().then((value) {
      categories = value;
      notifyListeners();
    });
  }

  _loadRecipes() {
    this.recipeRepository.getRecipes().then((value) {
      recipes = value;
      notifyListeners();
    });
  }

  Future<void> submitRecipe(Map<String, dynamic> form) async {
    if (selectedRecipeId == null) {
      form['id'] = Uuid().v4();
      await this.recipeRepository.createRecipe(form);
    } else {
      await this.recipeRepository.updateRecipe(selectedRecipeId!, form);
    }
    _loadRecipes();
  }

  Future<void> submitCategory(Map<String, String> form) async {
    if (selectedCategoryId == null) {
      form['id'] = Uuid().v4();
      await this.categoryRepository.createCategory(form);
    } else {
      await this.categoryRepository.updateCategory(selectedCategoryId!, form);
    }
    _loadCategories();
  }

  void clearCategoryId() {
    selectedCategoryId = null;
    notifyListeners();
  }

  void clearRecipeId() {
    selectedRecipeId = null;
    notifyListeners();
  }
}
