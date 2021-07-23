import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:recipie/service/recipe-notifier.dart';

class EasterEgg extends StatelessWidget {
  static String route = 'easter-egg';

  const EasterEgg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Сюрприз'),
      ),
      body: Consumer<RecipeNotifier>(
        builder: (context, value, child) => ListView(
          children: [
            CachedNetworkImage(imageUrl: value.selectedSurprise!.imageUrl!),
            Padding(
              padding: EdgeInsets.only(top: 18),
              child: Center(
                child: Text(
                  value.selectedSurprise!.title,
                  style: TextStyle(fontSize: 24),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
