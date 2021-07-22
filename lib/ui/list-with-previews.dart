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
    this.onLongPress,
  }) : super(key: key);

  final Function(String) onTap;
  final Function(String)? onLongPress;
  final List<ListItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(
        child: Center(
          child: Text(
            'Список пуст',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return ListView(
      children: ListTile.divideTiles(
        context: context,
        tiles: items
            .map(
              (item) => ListTile(
                onTap: () {
                  this.onTap(item.id);
                },
                onLongPress: () {
                  if (this.onLongPress != null) {
                    this.onLongPress!(item.id);
                  }
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
