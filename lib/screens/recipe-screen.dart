import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:recipie/service/recipe-notifier.dart';

class RecipeScreen extends StatelessWidget {
  const RecipeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<RecipeNotifier>(builder: (context, recipeNotifier, child) => Scaffold(
        appBar: AppBar(
          title: Text(recipeNotifier.selectedRecipe.title),
        ),
        body: Container(
          child: Center(
            child: Text(recipeNotifier.selectedRecipe.description),
          ),
        ),
      )),
    );
  }
}
