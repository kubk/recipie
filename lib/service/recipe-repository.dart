import 'package:recipie/model/recipe.dart';
import 'package:recipie/service/database-gateway.dart';

class RecipeRepository {
  final DatabaseGateway gateway;

  RecipeRepository(this.gateway);

  Recipe _mapToModel(Map<String, dynamic> map) => Recipe(
        id: map["id"],
        title: map["title"],
        description: map["description"],
        imageUrl: map["imageUrl"],
        categoryId: map["categoryId"],
        ingredients: map["ingredients"],
        isCooked: map["isCooked"],
        recipeUrl: map["recipeUrl"],
      );

  Future<List<Recipe>> getRecipes() async {
    final result = await (await gateway.database).rawQuery(
      '''
      SELECT id, title, description, imageUrl, categoryId, ingredients, isCooked, isCooked
      FROM recipe
      ''',
    );

    return result.map(_mapToModel).toList();
  }

  Future<List<Recipe>> getRecipesLike(String title) async {
    final result = await (await gateway.database).rawQuery(
      '''
      SELECT id, title, description, imageUrl, categoryId, ingredients, isCooked, isCooked
      FROM recipe
      WHERE title LIKE ?
      ''',
      ['%$title%'],
    );

    return result.map(_mapToModel).toList();
  }

  Future<Recipe> getRecipeById(String recipeId) async {
    final result = await (await gateway.database).rawQuery(
      '''
      SELECT id, title, description, imageUrl, categoryId, ingredients, isCooked, recipeUrl
      FROM recipe
      WHERE id = ?
      ''',
      [recipeId],
    );

    return result.map(_mapToModel).first;
  }

  Future<void> updateRecipe(
    String selectedRecipeId,
    Map<String, dynamic> map,
  ) async {
    final count = await (await gateway.database).rawUpdate('''
      UPDATE recipe
      SET title = ?, imageUrl = ?, description = ?, ingredients = ?, recipeUrl = ?, isCooked = ?
      WHERE recipe.id = ?
    ''', [
      map['title'],
      map['imageUrl'],
      map['description'],
      map['ingredients'],
      map['recipeUrl'],
      map['isCooked'],
      selectedRecipeId,
    ]);

    if (count < 1) {
      throw new Exception("Database error");
    }
  }

  Future<void> createRecipe(Map<String, dynamic> map) async {
    final count = await (await gateway.database).rawInsert('''
      INSERT INTO recipe  (id, title, imageUrl, categoryId, description, ingredients, isCooked, recipeUrl)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ''', [
      map['id'],
      map['title'],
      map["imageUrl"],
      map["categoryId"],
      map['description'],
      map['ingredients'],
      map['isCooked'],
      map['recipeUrl'],
    ]);

    if (count < 1) {
      throw new Exception("Database error");
    }
  }
}
