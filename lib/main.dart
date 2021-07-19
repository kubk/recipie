import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipie/screens/recipe-list-screen.dart';
import 'package:recipie/screens/recipe-screen.dart';
import 'package:recipie/store/recipe-store.dart';
import 'screens/category-list-screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RecipeStore>(create: (_) => RecipeStore()),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}



