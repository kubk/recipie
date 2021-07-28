import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:recipie/screens/easter-egg.dart';
import 'package:recipie/screens/recipe-form.dart';
import 'package:recipie/service/recipe-notifier.dart';
import 'package:recipie/service/recipe-repository.dart';

class Search extends StatefulWidget {
  static String route = 'search';

  Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<SearchResult> _recipes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Consumer<RecipeNotifier>(
        builder: (context, recipeNotifier, child) => Stack(
          fit: StackFit.expand,
          children: [
            FloatingSearchAppBar(
              body: ListView(
                children: ListTile.divideTiles(
                  context: context,
                  tiles: _recipes
                      .map(
                        (e) => ListTile(
                          onTap: () {
                            if (e.type == 'surprise') {
                              recipeNotifier.selectSurprise(e);
                              Navigator.pushNamed(context, EasterEgg.route);
                            } else {
                              recipeNotifier.selectRecipe(e.id);
                              Navigator.pushNamed(context, RecipeForm.route);
                            }
                          },
                          title: Text(e.title),
                        ),
                      )
                      .toList(),
                ).toList(),
              ),
              onQueryChanged: (query) {
                recipeNotifier.getRecipesLike(query).then((recipes) {
                  setState(() {
                    _recipes = recipes;
                  });
                });
              },
              alwaysOpened: true,
              hint: 'Поиск рецептов...',
              transitionDuration: const Duration(milliseconds: 600),
              transitionCurve: Curves.easeInOut,
              debounceDelay: const Duration(milliseconds: 500),
              actions: [
                FloatingSearchBarAction(
                  showIfOpened: false,
                  child: CircularButton(
                    icon: const Icon(
                      Icons.search,
                    ),
                    onPressed: () {},
                  ),
                ),
                FloatingSearchBarAction.searchToClear(
                  showIfClosed: false,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
