class Recipe {
  final String id;
  final String title;
  final String description;
  final String ingredients;
  final int isCooked;
  final String? imageUrl;
  final String categoryId;
  final String? recipeUrl;

  Recipe({
    required this.id,
    required this.title,
    required this.isCooked,
    required this.description,
    required this.ingredients,
    required this.imageUrl,
    required this.categoryId,
    required this.recipeUrl,
  });
}
