import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileHandler {
  Future<File> _file;
  String _filename;
  bool _prExisting;

  bool exists(){
    return _prExisting;
  }

  FileHandler(String name) {
    this._filename = name;
    this._file = _localFile(_filename);
    this._prExisting = false;
  }

  Future<String> get _localPath async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _localFile(String name) async {
    final String path = await _localPath;
    final File thisFile = File('$path/$name');
    _prExisting = await thisFile.exists();
    return thisFile;
  }

  Future<File> writeContent(String S) async {
    // Write the file
    final File thisFile = await _file;
    return thisFile.writeAsString(S);
  }

  Future<String> readContent() async {
    try {
      // Read the file
      final File thisFile = await _localFile(_filename);
      final Future<String> contents = thisFile.readAsString();
      return contents;
    } catch (e) {
      // If there is an error reading, return a default String
      return 'Error';
    }
  }
}
