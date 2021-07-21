import 'package:recipie/ui/list-with-previews.dart';

class Recipe implements ListItem {
  final String id;
  final String title;
  final String description;
  final String ingredients;
  final int isCooked;
  final String? imageUrl;
  final String categoryId;

  Recipe({
    required this.id,
    required this.title,
    required this.isCooked,
    required this.description,
    required this.ingredients,
    required this.imageUrl,
    required this.categoryId,
  });
}
