import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListItem {
  final String id;
  final String title;
  final String? subtitle;

  ListItem({
    required this.id,
    required this.title,
    this.subtitle,
  });
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
                subtitle: item.subtitle == null ? null : Text(item.subtitle!),
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
