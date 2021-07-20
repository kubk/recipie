import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseGateway {
  late Future<Database> database = _createDatabase();

  Future<Database> _createDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'recipe_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE category(id TEXT PRIMARY KEY, title TEXT)',
        );
        await db.execute(
          'CREATE TABLE recipe(id TEXT PRIMARY KEY, title TEXT, description TEXT, imageUrl TEXT, categoryId TEXT, FOREIGN KEY(categoryId) REFERENCES category(id))',
        );
      },
      version: 1,
    );
  }

  printDebugInfo() async {
    print(await (await database).query("category"));
    print(await (await database).query("recipe"));
  }
}
