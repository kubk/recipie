import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:recipie/store/recipe-store.dart';

class RecipeScreen extends StatelessWidget {
  const RecipeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<RecipeStore>(builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text(value.selectedRecipe.title),
        ),
        body: Container(
          child: Center(
            child: Text(value.selectedRecipe.description),
          ),
        ),
      )),
    );
  }
}
