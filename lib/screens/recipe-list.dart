import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:recipie/screens/recipe-form.dart';
import 'package:recipie/screens/search.dart';
import 'package:recipie/service/recipe-notifier.dart';

class RecipeList extends StatelessWidget {
  static String route = 'recipe-list';

  const RecipeList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeNotifier>(
      builder: (context, recipeNotifier, child) => Scaffold(
        appBar: AppBar(
          title: Text('Рецепты / ${recipeNotifier.selectedCategory.title}'),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(Search.route);
                },
                child: Icon(Icons.search),
              ),
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (recipeNotifier.filteredRecipes.isEmpty) {
              return Container(
                child: Center(
                  child: Text(
                    'Список пуст',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              );
            }

            return GridView.count(
              restorationId: 'recipesId',
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              padding: EdgeInsets.all(8),
              childAspectRatio: 1,
              children: recipeNotifier.filteredRecipes
                  .map(
                    (e) => GestureDetector(
                      onTap: () {
                        recipeNotifier.selectRecipe(e.id);
                        Navigator.pushNamed(context, RecipeForm.route);
                      },
                      child: GridTile(
                        footer: Material(
                          color: Colors.transparent,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(4)),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: GridTileBar(
                            backgroundColor: Colors.black45,
                            title: Text(e.title),
                            subtitle: Text(
                              e.isCooked == 1
                                  ? 'Приготовлен'
                                  : 'Не приготовлен',
                            ),
                          ),
                        ),
                        child: Material(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: e.imageUrl != null
                                ? (e.imageUrl!.startsWith('http'))
                                    ? CachedNetworkImage(
                                        imageUrl: e.imageUrl!,
                                        fit: BoxFit.fitHeight,
                                        placeholder: (context, url) =>
                                            Container(
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        // height: height,
                                        // width: height,
                                        child: Image.file(
                                          File(e.imageUrl!),
                                          fit: BoxFit.fitHeight,
                                        ),
                                      )
                                : null),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
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
