import 'package:flutter/cupertino.dart';
import 'package:recipie/model/category.dart';
import 'package:recipie/model/recipe.dart';
import 'package:recipie/service/category-repository.dart';
import 'package:recipie/service/recipe-repository.dart';

class RecipeNotifier extends ChangeNotifier {
  final CategoryRepository categoryRepository;
  final RecipeRepository recipeRepository;

  TextEditingController? titleController;
  TextEditingController? descriptionController;
  TextEditingController? ingredientsController;

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
    final recipe = selectedRecipe;

    disposeForm();
    titleController = TextEditingController(text: recipe.title);
    descriptionController = TextEditingController(text: recipe.description);
    ingredientsController = TextEditingController(text: recipe.ingredients);
  }

  disposeForm() {
    titleController?.dispose();
    descriptionController?.dispose();
    ingredientsController?.dispose();
  }

  List<Recipe> get filteredRecipes => recipes
      .where((element) => element.categoryId == selectedCategoryId)
      .toList();

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

  Future<void> submitRecipe() async {
    await this.recipeRepository.updateRecipe(selectedRecipeId!, {
      "title": titleController!.value.text,
      "ingredients": ingredientsController!.value.text,
      "description": descriptionController!.value.text,
    });
    _loadRecipes();
  }
}
