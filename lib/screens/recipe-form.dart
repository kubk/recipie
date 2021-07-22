import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:recipie/service/recipe-notifier.dart';

final double imageHeight = 310;

class RecipeForm extends StatefulWidget {
  static String route = 'recipe-form';

  @override
  _RecipeFormState createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final ingredientsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final recipe = context.read<RecipeNotifier>().selectedRecipe;
    titleController.text = recipe.title;
    descriptionController.text = recipe.description;
    ingredientsController.text = recipe.ingredients;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    ingredientsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<RecipeNotifier>(
        builder: (context, recipeNotifier, child) => Scaffold(
          appBar: AppBar(
            title: Text(recipeNotifier.selectedRecipe.title),
            actions: [
              GestureDetector(
                onTap: () async {
                  await recipeNotifier.submitRecipe({
                    "title": titleController.value.text,
                    "ingredients": ingredientsController.value.text,
                    "description": descriptionController.value.text,
                  });
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Рецепт сохранён')));
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 24.0,
                  ),
                ),
              ),
            ],
          ),
          body: ListView(
            children: [
              if (recipeNotifier.selectedRecipe.imageUrl != null)
                CachedNetworkImage(
                  imageUrl: recipeNotifier.selectedRecipe.imageUrl!,
                  height: imageHeight,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Container(
                    height: imageHeight,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextFormField(
                  controller: titleController,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Название',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextFormField(
                  controller: ingredientsController,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 12,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Ингредиенты',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextFormField(
                  controller: descriptionController,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 12,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Описание',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
