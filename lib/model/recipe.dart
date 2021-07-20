import 'package:recipie/ui/list-with-previews.dart';

class Recipe implements ListItem {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String categoryId;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.categoryId,
  });
}
