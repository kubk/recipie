import 'package:recipie/model/category.dart';
import 'package:recipie/service/database-gateway.dart';

class CategoryRepository {
  final DatabaseGateway _db;

  CategoryRepository(this._db);

  Category _mapToModel(Map<String, dynamic> map) => Category(
        id: map["id"],
        title: map["title"],
      );

  Future<List<Category>> getCategories() async {
    final result = await (await _db.database).rawQuery('''
      SELECT id, title
      FROM category
    ''');

    return result.map(_mapToModel).toList();
  }

  Future<void> createCategory(Map<String, dynamic> map) async {
    final count = await (await _db.database).rawInsert('''
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
    final count = await (await _db.database).rawInsert('''
    UPDATE category
    SET title = ?
    WHERE id = ?
    ''', [
      map['title'],
      id,
    ]);
    if (count < 1) {
      throw new Exception("Database error");
    }
  }
}
