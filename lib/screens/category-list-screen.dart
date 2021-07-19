import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:recipie/store/recipe-store.dart';
import '../ui/list-with-previews.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Категории'),
      ),
      body: Consumer<RecipeStore>(
        builder: (context, recipeStore, child) => ListWithPreviews(
          onTap: (categoryId) {
            recipeStore.selectCategory(categoryId);
            Navigator.pushNamed(context, '/recipes');
          },
          items: recipeStore.categories,
        ),
      ),
    );
  }
}
