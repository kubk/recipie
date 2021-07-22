import 'package:recipie/model/recipe.dart';
import 'package:recipie/service/database-gateway.dart';

class RecipeRepository {
  final DatabaseGateway _db;

  RecipeRepository(this._db);

  Recipe _mapToModel(Map<String, dynamic> map) => Recipe(
        id: map["id"],
        title: map["title"],
        description: map["description"],
        imageUrl: map["imageUrl"],
        categoryId: map["categoryId"],
        ingredients: map["ingredients"],
        isCooked: map["isCooked"],
      );

  Future<List<Recipe>> getRecipes() async {
    final result = await (await _db.database).rawQuery(
      '''
      SELECT id, title, description, imageUrl, categoryId, ingredients, isCooked
      FROM recipe
      ''',
    );

    return result.map(_mapToModel).toList();
  }

  Future<Recipe> getRecipeById(String recipeId) async {
    final result = await (await _db.database).rawQuery(
      '''
      SELECT id, title, description, imageUrl, categoryId, ingredients, isCooked
      FROM recipe
      WHERE id = ?
      ''',
      [recipeId],
    );

    return result.map(_mapToModel).first;
  }

  Future<void> updateRecipe(
      String selectedRecipeId, Map<String, dynamic> map) async {
    final count = await (await _db.database).rawUpdate('''
      UPDATE recipe
      SET title = ?, description = ?, ingredients = ?
      WHERE recipe.id = ?
    ''', [
      map['title'],
      map['description'],
      map['ingredients'],
      selectedRecipeId,
    ]);

    if (count < 1) {
      throw new Exception("Database error");
    }
  }
}
