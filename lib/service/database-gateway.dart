import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseGateway {
  late Future<Database> database = _createDatabase();

  Future<Database> _createDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'recipe_database6.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE category(id TEXT PRIMARY KEY, title TEXT)',
        );
        await db.execute(
          '''
          CREATE TABLE recipe(
            id TEXT PRIMARY KEY,
            isCooked INTEGER DEFAULT 0,
            title TEXT,
            description TEXT,
            ingredients TEXT,
            imageUrl TEXT,
            categoryId TEXT,
            recipeUrl TEXT,
            FOREIGN KEY(categoryId) REFERENCES category(id)
          )
          ''',
        );
      },
      version: 6,
    );
  }
}
