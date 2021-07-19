import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:recipie/store/recipe-store.dart';
import 'package:recipie/ui/list-with-previews.dart';

class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Рецепты'),
      ),
      body: Consumer<RecipeStore>(
        builder: (context, recipeStore, child) => ListWithPreviews(
          onTap: (recipeId) {
            recipeStore.selectRecipe(recipeId);
            Navigator.pushNamed(context, '/recipe');
          },
          items: recipeStore.filteredRecipes,
        ),
      ),
    );
  }
}
