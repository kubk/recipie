import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:recipie/screens/recipe-list.dart';
import 'package:recipie/service/local-file-uploader.dart';
import 'package:recipie/service/recipe-notifier.dart';

final double imageHeight = 310;

class RecipeForm extends StatefulWidget {
  static String route = 'recipe-form';

  @override
  _RecipeFormState createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController ingredientsController;
  late TextEditingController isCookedController;
  File? _temporaryImage;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController();
    descriptionController = TextEditingController();
    ingredientsController = TextEditingController();
    isCookedController = TextEditingController();

    if (context.read<RecipeNotifier>().selectedRecipeId != null) {
      final recipe = context.read<RecipeNotifier>().selectedRecipe;
      titleController.text = recipe.title;
      descriptionController.text = recipe.description;
      ingredientsController.text = recipe.ingredients;
      print(recipe.isCooked);
      isCookedController.text = recipe.isCooked.toString();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    ingredientsController.dispose();
    _temporaryImage = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<RecipeNotifier>(
        builder: (context, recipeNotifier, child) => Scaffold(
          appBar: AppBar(
            title: Text(
              recipeNotifier.selectedRecipeId != null
                  ? 'Редактирование рецепта'
                  : 'Создание рецепта',
            ),
            actions: [
              GestureDetector(
                onTap: () async {
                  await recipeNotifier.submitRecipe({
                    "imageUrl": recipeNotifier.selectedRecipeId == null
                        ? _temporaryImage == null
                            ? null
                            : _temporaryImage!.absolute.path
                        : recipeNotifier.selectedRecipe.imageUrl,
                    "title": titleController.value.text,
                    "ingredients": ingredientsController.value.text,
                    "description": descriptionController.value.text,
                    "isCooked": isCookedController.value.text == '1' ? 1 : 0,
                    "categoryId": recipeNotifier.selectedCategoryId,
                    "recipeUrl": null,
                  });
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Рецепт сохранён')));
                  Navigator.of(context).pushNamed(RecipeList.route);
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
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isImageSaved = recipeNotifier.selectedRecipeId != null &&
                  recipeNotifier.selectedRecipe.imageUrl != null;
              final isImageUploadedUrl = isImageSaved &&
                  recipeNotifier.selectedRecipe.imageUrl!.startsWith('http');
              final isImageUploadedLocal = isImageSaved &&
                  !recipeNotifier.selectedRecipe.imageUrl!.startsWith('http');

              return ListView(
                children: [
                  if (recipeNotifier.selectedRecipeId == null &&
                      _temporaryImage == null)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: GestureDetector(
                        onTap: () async {
                          final image = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (image == null) {
                            return;
                          }
                          final temporaryImage = await LocalFileUploader()
                              .upload(File(image.path));
                          setState(() {
                            _temporaryImage = temporaryImage;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          height: imageHeight,
                          child: Center(
                            child: Icon(Icons.add_a_photo, size: 48),
                          ),
                        ),
                      ),
                    ),
                  if (isImageUploadedLocal)
                    Container(
                      height: imageHeight,
                      child: Image.file(
                          File(recipeNotifier.selectedRecipe.imageUrl!)),
                    ),
                  if (_temporaryImage != null)
                    Container(
                      height: imageHeight,
                      child: Image.file(_temporaryImage!),
                    ),
                  if (isImageUploadedUrl)
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: const Text('Приготовлен'),
                      value: isCookedController.text == '1',
                      onChanged: (bool value) {
                        setState(() {
                          isCookedController.text = value ? '1' : '0';
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 60)
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
