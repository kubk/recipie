import 'package:recipie/model/recipe.dart';
import 'package:recipie/model/search-result.dart';
import 'package:recipie/service/database-gateway.dart';

class RecipeRepository {
  final DatabaseGateway _gateway;

  RecipeRepository(this._gateway);

  Recipe _mapToRecipe(Map<String, dynamic> map) => Recipe(
        id: map["id"],
        title: map["title"],
        description: map["description"],
        imageUrl: map["imageUrl"],
        categoryId: map["categoryId"],
        ingredients: map["ingredients"],
        isCooked: map["isCooked"],
        recipeUrl: map["recipeUrl"],
      );

  SearchResult _mapToSearchResult(Map<String, dynamic> map) => SearchResult(
        id: map['id'],
        title: map['title'],
        imageUrl: map['imageUrl'],
        type: map['type'],
      );

  Future<List<Recipe>> getRecipes() async {
    final result = await (await _gateway.database).rawQuery(
      '''
      SELECT id, title, description, imageUrl, categoryId, ingredients, isCooked, recipeUrl
      FROM recipe
      ''',
    );

    return result.map(_mapToRecipe).toList();
  }

  Future<List<SearchResult>> getRecipesLike(String title) async {
    if (title.isEmpty) {
      return [];
    }

    final result = await (await _gateway.database).rawQuery(
      '''
      SELECT id, title, imageUrl, "recipe" as type
      FROM recipe
      WHERE title LIKE ?
      UNION
      SELECT id, title, imageUrl, "surprise" as type
      FROM easter
      WHERE title LIKE ?
      ''',
      ['%$title%', '%$title%'],
    );

    return result.map(_mapToSearchResult).toList();
  }

  Future<Recipe> getRecipeById(String recipeId) async {
    final result = await (await _gateway.database).rawQuery(
      '''
      SELECT id, title, description, imageUrl, categoryId, ingredients, isCooked, recipeUrl
      FROM recipe
      WHERE id = ?
      ''',
      [recipeId],
    );

    return result.map(_mapToRecipe).first;
  }

  Future<void> updateRecipe(
    String selectedRecipeId,
    Map<String, dynamic> map,
  ) async {
    final count = await (await _gateway.database).rawUpdate('''
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
    final count = await (await _gateway.database).rawInsert('''
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
