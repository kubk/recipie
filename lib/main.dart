import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipie/screens/category-form.dart';
import 'package:recipie/screens/recipe-list-screen.dart';
import 'package:recipie/screens/recipe-form.dart';
import 'package:recipie/service/category-repository.dart';
import 'package:recipie/service/database-gateway.dart';
import 'package:recipie/service/fixture-generator.dart';
import 'package:recipie/service/recipe-repository.dart';
import 'package:recipie/service/recipe-notifier.dart';
import 'screens/category-list-screen.dart';

void main() {
  final database = DatabaseGateway();
  final categoryRepository = CategoryRepository(database);
  final recipeRepository = RecipeRepository(database);
  final recipeNotifier = RecipeNotifier(categoryRepository, recipeRepository);
  final fixtureGenerator = FixtureGenerator(database);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<RecipeNotifier>(create: (_) => recipeNotifier),
        Provider(create: (_) => fixtureGenerator),
      ],
      child: App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    context.read<RecipeNotifier>().loadData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: CategoryList.route,
        routes: {
          CategoryList.route: (context) => CategoryList(),
          CategoryForm.route: (context) => CategoryForm(),
          RecipeList.route: (context) => RecipeList(),
          RecipeForm.route: (context) => RecipeForm(),
        },
      ),
    );
  }
}
