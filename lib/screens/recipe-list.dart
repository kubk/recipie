import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:recipie/screens/recipe-form.dart';
import 'package:recipie/service/recipe-notifier.dart';
import 'package:recipie/ui/list-with-previews.dart';

class RecipeList extends StatelessWidget {
  static String route = 'recipe-list';

  const RecipeList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeNotifier>(
      builder: (context, recipeNotifier, child) => Scaffold(
        appBar: AppBar(
          title: Text('Рецепты / ${recipeNotifier.selectedCategory.title}'),
        ),
        body: ListWithPreviews(
          onTap: (recipeId) {
            recipeNotifier.selectRecipe(recipeId);
            Navigator.pushNamed(context, RecipeForm.route);
          },
          items: recipeNotifier.filteredRecipes,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            recipeNotifier.clearRecipeId();
            Navigator.pushNamed(context, RecipeForm.route);
          },
          label: const Text('Добавить рецепт'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}
