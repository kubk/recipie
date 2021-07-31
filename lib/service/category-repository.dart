import 'package:recipie/model/category.dart';
import 'package:recipie/service/database-gateway.dart';

class CategoryRepository {
  final DatabaseGateway _gateway;

  CategoryRepository(this._gateway);

  Future<List<CategoryWithRecipes>> getCategories() async {
    final result = await (await _gateway.database).rawQuery('''
      SELECT c.id, c.title, COUNT(r.id) as recipeCount
      FROM category c
      LEFT JOIN recipe r ON r.categoryId = c.id 
      GROUP BY c.id
      ORDER BY c.title ASC
    ''');

    return result
        .map(
          (Map<String, dynamic> map) => CategoryWithRecipes(
            id: map['id'],
            title: map['title'],
            recipeCount: map['recipeCount'],
          ),
        )
        .toList();
  }

  Future<void> createCategory(Map<String, dynamic> map) async {
    final count = await (await _gateway.database).rawInsert('''
    INSERT INTO category (id, title)
    VALUES (?, ?);
    ''', [
      map['id'],
      map['title'],
    ]);
    if (count < 1) {
      throw new Exception("Database error");
    }
  }

  Future<void> updateCategory(String id, Map<String, dynamic> map) async {
    await (await _gateway.database).rawInsert('''
    UPDATE category
    SET title = ?
    WHERE id = ?
    ''', [
      map['title'],
      id,
    ]);
  }
}
