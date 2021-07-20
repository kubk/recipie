import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipie/screens/recipe-list-screen.dart';
import 'package:recipie/screens/recipe-screen.dart';
import 'package:recipie/service/category-repository.dart';
import 'package:recipie/service/database-gateway.dart';
import 'package:recipie/service/recipe-repository.dart';
import 'package:recipie/service/recipe-notifier.dart';
import 'screens/category-list-screen.dart';

void main() {
  final database = DatabaseGateway();
  final categoryRepository = CategoryRepository(database);
  final recipeRepository = RecipeRepository(database);
  final recipeNotifier = RecipeNotifier(categoryRepository, recipeRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<RecipeNotifier>(create: (_) => recipeNotifier),
      ],
      child: App(
        recipeNotifier: recipeNotifier,
      ),
    ),
  );
}

class App extends StatefulWidget {
  final RecipeNotifier recipeNotifier;

  const App({Key? key, required this.recipeNotifier}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    widget.recipeNotifier.loadRecipes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MaterialApp(
        initialRoute: '/categories',
        routes: {
          '/categories': (context) => CategoryListScreen(),
          '/recipes': (context) => RecipeListScreen(),
          '/recipe': (context) => RecipeScreen(),
        },
      ),
    );
  }
}
