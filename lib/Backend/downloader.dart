import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

import 'file_handling.dart';

class Downloader extends FileHandler {
  bool _permitted;
  Future<Directory> _downloads;
  List<DownloadTask> _tasks;

  Downloader() : super('0', '0') {
    _permitted = false;
    _downloads = getExternalStorageDirectory();
    getPermission().then((value) => _permitted = value);
    _initDownloader();
  }

  void _initDownloader() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize(
        debug: true // optional: set false to disable printing logs to console
        );
  }

  Future<String> addDownload(String link) async {
    if (!_permitted) _permitted = await getPermission();

    Directory _downloadLocations = await _downloads;
    final taskId = await FlutterDownloader.enqueue(
      url: link,
      savedDir: _downloadLocations.path,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
    FlutterDownloader.resume(taskId: taskId);
    return taskId;
  }

  Future<List<DownloadTask>> checkDownloads() async {
    _tasks = await FlutterDownloader.loadTasks();
    return _tasks;
  }
}
