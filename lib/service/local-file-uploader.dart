import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class LocalFileUploader {
  Future<File> upload(File file) async {
    final String appPath = (await getApplicationDocumentsDirectory()).path;
    final fileName = Uuid().v4();
    final fileExtension = extension(file.path);

    return file.copy('$appPath/$fileName$fileExtension');
  }
}
