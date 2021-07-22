import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:recipie/screens/category-form.dart';
import 'package:recipie/screens/recipe-list-screen.dart';
import 'package:recipie/service/recipe-notifier.dart';
import '../ui/list-with-previews.dart';

class CategoryList extends StatelessWidget {
  static String route = 'categories';

  const CategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Категории'),
      ),
      body: Consumer<RecipeNotifier>(
        builder: (context, recipeNotifier, child) => ListWithPreviews(
          onTap: (categoryId) {
            recipeNotifier.selectCategory(categoryId);
            Navigator.pushNamed(context, RecipeList.route);
          },
          onLongPress: (categoryId) {
            recipeNotifier.selectCategory(categoryId);
            Navigator.pushNamed(context, CategoryForm.route);
          },
          items: recipeNotifier.categories,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<RecipeNotifier>().clearCategoryId();
          Navigator.pushNamed(context, CategoryForm.route);
        },
        label: const Text('Добавить категорию'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
