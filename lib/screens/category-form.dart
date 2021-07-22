import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:recipie/screens/category-list-screen.dart';
import 'package:recipie/service/recipe-notifier.dart';

class CategoryForm extends StatefulWidget {
  static String route = 'category-form';

  const CategoryForm({Key? key}) : super(key: key);

  @override
  _CategoryFormState createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final TextEditingController titleController = TextEditingController();
  bool _isSaveVisible = false;

  @override
  void initState() {
    super.initState();

    if (context.read<RecipeNotifier>().selectedCategoryId != null) {
      final category = context.read<RecipeNotifier>().selectedCategory;
      titleController.text = category.title;
    } else {
      titleController.text = '';
    }

    titleController.addListener(() {
      final isEmpty = titleController.value.text.isEmpty;
      final isSaveVisible = !isEmpty;
      if (isSaveVisible != _isSaveVisible) {
        setState(() {
          _isSaveVisible = isSaveVisible;
        });
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeNotifier>(
      builder: (context, recipeNotifier, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            recipeNotifier.selectedCategoryId == null
                ? 'Создание категории'
                : 'Редактирование категории',
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                await recipeNotifier.submitCategory({
                  "title": titleController.value.text,
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Категория сохранёна')),
                );
                Navigator.of(context).pushNamed(CategoryList.route);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: _isSaveVisible
                    ? Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 24.0,
                      )
                    : null,
              ),
            )
          ],
        ),
        body: ListView(
          children: [
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
          ],
        ),
      ),
    );
  }
}
