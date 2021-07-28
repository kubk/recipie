import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseGateway {
  late Future<Database> database = _createDatabase();

  Future<Database> _createDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'recipe_database9.db'),
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
        await db.execute('''
          CREATE TABLE easter(
            id TEXT PRIMARY KEY,
            title TEXT,
            imageUrl TEXT
          )
        ''');
        _prepareFixtures(db);
      },
      version: 9,
    );
  }

  _prepareFixtures(Database db) async {
    final createCategoriesSql = '''
    INSERT INTO category (id, title) VALUES
    ("103139fd-6a30-43c7-aeae-0663c1925052", "Тортики"),
    ("8743a663-7fc0-4295-bd46-2e297e7260a6", "Пироги"),
    ("dc258b1d-9328-4ff1-9fcf-a1210479b733", "Супы"),
    ("57736646-e051-43c7-86ff-77a16621af55", "Рулеты"),
    ("b3048402-af35-45f5-86b5-723102bcb7bf", "Салаты")
    ''';

    final createRecipesSql = '''
    INSERT INTO recipe (id, title, description, imageUrl, categoryId, ingredients) VALUES
    ("675919ea-83a2-4136-9e66-1482ab4e7be5", "Шоколадный", "Рецепт шоколадного торта - простой, но очень вкусной и элегантной выпечки для тех, кто любит шоколад. И в тесто, и в крем-помадку добавляется какао.", "https://storage.yandexcloud.net/youshka-dev-media/files/2fa249fcb913096e2dbecad3e8beb1e0.jpg", "103139fd-6a30-43c7-aeae-0663c1925052", "Мука пшеничная высшего сорта (360 граммов)
СахарСахар (360 граммов)
Кефир (250 граммов)
Масло сливочное (220 граммов)
Яйца куриные (2 шт)
Какао-порошок (15 граммов)
Разрыхлитель теста (10 граммов)
Пищевые красители (10 граммов)
"),
    ("675919ea-83a2-4136-9e66-1482ab4e7be4", "Красный бархат", "В отдельную емкость наливаем 250 граммов (не миллилитров, а именно граммов) кефира, в которые добавляем 10 граммов жидкого красного красителя (подробнее я писала о нем выше).\n\nВсе тщательно перемешиваем ложкой, вилкой или венчиком. Вообще, гелевые красители очень быстро соединяются с жидкой основой и дают равномерный окрас.", "https://storage.yandexcloud.net/youshka-dev-media/files/4ca769ce42a24a77e132c22002b07ff7.JPG", "103139fd-6a30-43c7-aeae-0663c1925052", "
Мука пшеничная высшего сорта (360 граммов)
СахарСахар (360 граммов)
Кефир (250 граммов)
Масло сливочное (220 граммов)
Яйца куриные (2 шт)
Какао-порошок (15 граммов)
Разрыхлитель теста (10 граммов)
Пищевые красители (10 граммов)
    ")
    ''';

    await db.rawInsert(createCategoriesSql);
    await db.rawInsert(createRecipesSql);
  }
}
