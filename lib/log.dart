import 'dart:io';

import 'package:intl/intl.dart';

void llog(String message) {
  try {
    File(
      'storage/log.txt',
    ).writeAsStringSync(
        '${DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now())} $message\n',
        mode: FileMode.writeOnlyAppend);
  } catch (e) {
    print(e);
  }
}
