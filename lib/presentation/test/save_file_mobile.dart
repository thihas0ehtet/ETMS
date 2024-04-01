import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart' as open_file;

///To save the pdf file in the device
Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  String? path;
  Directory? directory;
  if (Platform.isIOS) {
    directory = await getApplicationDocumentsDirectory();
  } else if(Platform.isAndroid) {
    directory = Directory('/storage/emulated/0/Download');
    if (!await directory.exists()){
      directory = await getExternalStorageDirectory();
    }
  } else{
    directory = await getExternalStorageDirectory();
  }
  path = directory!.path;

  if (!directory.existsSync()) {
    return;
  }
  final filePath = '${directory.path}/$fileName';
  final File file = File(Platform.isWindows ? '$path\\$fileName' : '$path/$fileName');

  await file.writeAsBytes(bytes, flush: true);
  if (!File(filePath).existsSync()) {
    debugPrint('PDF file not found.');
    return;
  }

  if (Platform.isAndroid || Platform.isIOS) {
    try{
      await open_file.OpenFile.open(filePath);
    } catch(e){
      debugPrint("errror $e");
    }

  } else if (Platform.isWindows) {
    await Process.run('start', <String>['$path\\$fileName'], runInShell: true);
  } else if (Platform.isMacOS) {
    await Process.run('open', <String>['$path/$fileName'], runInShell: true);
  } else if (Platform.isLinux) {
    await Process.run('xdg-open', <String>['$path/$fileName'],
        runInShell: true);
  }
}