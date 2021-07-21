import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:recipie/service/recipe-notifier.dart';
import 'package:recipie/ui/list-with-previews.dart';

class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Рецепты'),
      ),
      body: Consumer<RecipeNotifier>(
        builder: (context, recipeNotifier, child) => ListWithPreviews(
          onTap: (recipeId) {
            recipeNotifier.selectRecipe(recipeId);
            Navigator.pushNamed(context, '/recipe');
          },
          items: recipeNotifier.filteredRecipes,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/recipe-new');
        },
        label: const Text('Добавить рецепт'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
