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
      );

  Future<List<Recipe>> getRecipes() async {
    final result = await (await _db.database).rawQuery(
      "SELECT id, title, description, imageUrl, categoryId FROM recipe",
    );

    return result.map(_mapToModel).toList();
  }
}
