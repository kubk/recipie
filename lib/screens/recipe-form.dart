import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:recipie/service/local-file-uploader.dart';
import 'package:recipie/service/recipe-notifier.dart';
import 'package:recipie/ui/image-select.dart';
import 'package:recipie/ui/launch-url.dart';
import 'package:recipie/ui/recipe-image.dart';
import 'package:url_launcher/url_launcher.dart';

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
  late TextEditingController recipeUrlController;
  File? _temporaryImage;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController();
    descriptionController = TextEditingController();
    ingredientsController = TextEditingController();
    isCookedController = TextEditingController();
    recipeUrlController = TextEditingController();

    if (context.read<RecipeNotifier>().selectedRecipeId != null) {
      final recipe = context.read<RecipeNotifier>().selectedRecipe;
      titleController.text = recipe.title;
      descriptionController.text = recipe.description;
      ingredientsController.text = recipe.ingredients;
      recipeUrlController.text = recipe.recipeUrl ?? '';
      isCookedController.text = recipe.isCooked.toString();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    ingredientsController.dispose();
    recipeUrlController.dispose();
    isCookedController.dispose();
    ingredientsController.dispose();
    _temporaryImage = null;
    super.dispose();
  }

  _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    final temporaryImage = await LocalFileUploader().upload(File(image.path));
    setState(() {
      _temporaryImage = temporaryImage;
    });
  }

  Widget _buildImage(RecipeNotifier recipeNotifier) {
    if (_temporaryImage != null) {
      return Container(
        height: imageHeight,
        child: Image.file(_temporaryImage!),
      );
    }

    final isImageSaved = recipeNotifier.selectedRecipeId != null &&
        recipeNotifier.selectedRecipe.imageUrl != null;

    if (isImageSaved) {
      return RecipeImage(
        imageUrl: recipeNotifier.selectedRecipe.imageUrl!,
        height: imageHeight,
        onTap: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Замена изображения'),
            content: const Text('Вы уверены, что хотите заменить изображение?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage();
                },
                child: const Text('Заменить'),
              ),
            ],
          ),
        ),
      );
    }

    return ImageSelect(
      onTap: _pickImage,
      imageHeight: imageHeight,
    );
  }

  void _launchURL(url) async {
    if (!(await canLaunch(url))) {
      throw 'Could not launch $url';
    }
    await launch(url);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<RecipeNotifier>(
        builder: (context, recipeNotifier, child) => Scaffold(
          appBar: AppBar(
            title: Text(
              recipeNotifier.selectedRecipeId == null
                  ? 'Создание рецепта'
                  : 'Редактирование рецепта',
            ),
            actions: [
              GestureDetector(
                onTap: () async {
                  await recipeNotifier.submitRecipe({
                    'imageUrl': _temporaryImage == null
                        ? recipeNotifier.selectedRecipe.imageUrl == null
                            ? null
                            : recipeNotifier.selectedRecipe.imageUrl
                        : _temporaryImage!.absolute.path,
                    'title': titleController.value.text,
                    'ingredients': ingredientsController.value.text,
                    'description': descriptionController.value.text,
                    'isCooked': isCookedController.value.text == '1' ? 1 : 0,
                    'categoryId': recipeNotifier.selectedCategoryId,
                    'recipeUrl': recipeUrlController.value.text,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Рецепт сохранён'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context).pop();
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
              _buildImage(recipeNotifier),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
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
                child: Stack(
                  children: [
                    TextFormField(
                      controller: recipeUrlController,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Ссылка',
                      ),
                    ),
                    Positioned(
                      top: 18,
                      right: 0,
                      child: LaunchUrl(onTap: () {
                        _launchURL(recipeUrlController.value.text);
                      }),
                    )
                  ],
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
          ),
        ),
      ),
    );
  }
}
