import 'dart:io';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';


class FileHandler {
  Future<File> _file;
  String _filename;
  bool _permitted, _prExisting;

  bool exists() {
    return _prExisting;
  }

  bool permissionGiven() {
    return _permitted;
  }

  Future<bool> getPermission() async {
    PermissionStatus permissionResult = await SimplePermissions.requestPermission(Permission. WriteExternalStorage);
    if (permissionResult == PermissionStatus.authorized){
      // code of read or write file in external storage (SD card)
      return true;
    }
    else return false;
  }

  FileHandler(String name) {
    getPermission().then((value) => _permitted = value);
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
    if (!_permitted)
      _permitted = await getPermission();

    return thisFile.writeAsString(S);
  }

  Future<String> readContent() async {
    try {
      // Read the file
      final File thisFile = await _localFile(_filename);
      if (!_permitted)
        _permitted = await getPermission();

      final Future<String> contents = thisFile.readAsString();
      return contents;
    } catch (e) {
      // If there is an error reading, return a default String
      return 'Error';
    }
  }
}
