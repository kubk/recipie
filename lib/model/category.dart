class Category {
  final String id;
  final String title;

  Category({
    required this.id,
    required this.title,
  });
}

class CategoryWithRecipes {
  final String id;
  final String title;
  final int recipeCount;

  CategoryWithRecipes({
    required this.id,
    required this.title,
    required this.recipeCount,
  });
}
