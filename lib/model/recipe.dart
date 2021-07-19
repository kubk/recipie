import 'package:flutter/cupertino.dart';
import 'package:recipie/ui/list-with-previews.dart';

class Recipe implements ListItem {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String categoryId;

  Recipe(this.id, this.title, this.description, this.imageUrl, this.categoryId);
}