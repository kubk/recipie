import 'package:recipie/service/database-gateway.dart';

class FixtureGenerator {
  final DatabaseGateway db;

  FixtureGenerator(this.db);

  prepareFixtures() async {
    final createCategoriesSql = '''
    INSERT INTO category (id, title) VALUES
    ("103139fd-6a30-43c7-aeae-0663c1925052", "Тортики"),
    ("8743a663-7fc0-4295-bd46-2e297e7260a6", "Пироги"),
    ("dc258b1d-9328-4ff1-9fcf-a1210479b733", "Супы"),
    ("57736646-e051-43c7-86ff-77a16621af55", "Рулеты"),
    ("b3048402-af35-45f5-86b5-723102bcb7bf", "Салаты")
    ''';

    final createRecipesSql = '''
    INSERT INTO recipe (id, title, description, imageUrl, categoryId) VALUES
    ("675919ea-83a2-4136-9e66-1482ab4e7be5", "Шоколадный", "Описание шоколадного торта", "https://storage.yandexcloud.net/youshka-dev-media/files/2fa249fcb913096e2dbecad3e8beb1e0.jpg", "103139fd-6a30-43c7-aeae-0663c1925052"),
    ("675919ea-83a2-4136-9e66-1482ab4e7be4", "Красный бархат", "Описание шоколадного торта", "https://storage.yandexcloud.net/youshka-dev-media/files/4ca769ce42a24a77e132c22002b07ff7.JPG", "103139fd-6a30-43c7-aeae-0663c1925052"),
    ("675919ea-83a2-4136-9e66-1482ab4e7be3", "Медовик", "Описание шоколадного торта", "https://storage.yandexcloud.net/youshka-dev-media/files/3f731ae9f657a0d9d9886e3e4cc3cd59.JPG", "103139fd-6a30-43c7-aeae-0663c1925052")
    ''';

    (await db.database).rawInsert(createCategoriesSql);
    (await db.database).rawInsert(createRecipesSql);
  }
}
