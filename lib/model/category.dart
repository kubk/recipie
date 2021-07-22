import 'package:recipie/ui/list-with-previews.dart';

class Category implements ListItem {
  final String id;
  final String title;

  Category({
    required this.id,
    required this.title,
  });
}
