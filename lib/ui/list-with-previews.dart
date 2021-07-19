import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class ListItem {
  final String id;
  final String title;

  ListItem(this.id, this.title);
}

class ListWithPreviews extends StatelessWidget {
  const ListWithPreviews({
    Key? key,
    required this.onTap,
    required this.items,
  }) : super(key: key);

  final Function(String) onTap;
  final List<ListItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: ListTile.divideTiles(
        context: context,
        tiles: items
            .map(
              (item) => ListTile(
                onTap: () {
                  this.onTap(item.id);
                },
                title: Text(
                  item.title,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
            .toList(),
      ).toList(),
    );
  }
}
