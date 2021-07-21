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
    final result = await (await _db.database).rawQuery(
      "SELECT id, title FROM category",
    );

    return result.map(_mapToModel).toList();
  }
}
