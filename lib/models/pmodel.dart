import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:ffi/ffi.dart';
import 'package:ffi/ffi.dart' as ffi;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:p2p_matrix/components/buttons.dart';
import 'package:p2p_matrix/components/dialogs.dart';
import 'package:p2p_matrix/log.dart';
import 'package:p2p_matrix/models/script.dart';
import 'package:select_dialog/select_dialog.dart';

import '../main.dart';

part 'pmodel.g.dart';

typedef GetNameFunction = Pointer<Utf8> Function();
typedef RunFunction = Pointer<Void> Function(
    Pointer<Utf8> script, Pointer<Utf8> resultPath);

@HiveType(typeId: 1)
class PModel {
  @HiveField(0)
  final String path;

  @HiveField(1)
  final double size;

  @HiveField(2)
  final DateTime lastModified;

  DynamicLibrary _lib;
  GetNameFunction getName;
  RunFunction run;

  PModel({
    @required this.path,
    @required this.size,
    @required this.lastModified,
  }) {
    _lib = DynamicLibrary.open(path);
    getName = _lib
        .lookup<NativeFunction<GetNameFunction>>('GetModelName')
        .asFunction<GetNameFunction>();

    run = _lib
        .lookup<NativeFunction<RunFunction>>('Run')
        .asFunction<RunFunction>();
  }

  Future<void> simulate(String scriptName, String scriptPath) async {
    final rand = Random();

    final fileName =
        '${getName().toDartString()}_${scriptName}_${rand.nextInt(100000000)}.json';

    print('running script');
    print(File('storage/history/$fileName').absolute.path);
    print(scriptPath);

    run(scriptPath.toNativeUtf8(),
        File('storage/history/$fileName').absolute.path.toNativeUtf8());

    while (true) {
      print('checking');
      await Future.delayed(const Duration(seconds: 1));
      final f = await File('storage/history/$fileName').length();

      if (f != 0) {
        final res =
            jsonDecode(await File('storage/history/$fileName').readAsString());
        final scriptModel = ScriptModel.fromJson(
            jsonDecode(await File(scriptPath).readAsString())
                as Map<String, dynamic>);
        final newVar = {};
        newVar['result'] = res;
        newVar['scriptName'] = scriptName;
        newVar['modelName'] = getName().toDartString();
        newVar['scriptOperations'] = scriptModel.operations;
        newVar['scriptNodes'] = scriptModel.nodesAmount;
        newVar['modelCreated'] = lastModified.toString();
        newVar['modelSize'] = size;
        newVar['historyDate'] = DateTime.now().toString();
        newVar['fileName'] = fileName;


        await File('storage/history/$fileName')
            .writeAsString(jsonEncode(newVar));

        wLog('Response from the Go code saved here: storage/history/$fileName');
        return;
      }
      wLog('Awaiting response from the Go code: 1 second passed');
    }
  }
}

class PModelCard extends StatelessWidget {
  final PModel model;
  final Function() remove;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  final List<ScriptModel> scripts;

  PModelCard(this.model, this.scripts, this.remove);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.blueGrey.shade100,
          borderRadius: BorderRadius.circular(6)),
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                model.getName().toDartString(),
                style: GoogleFonts.rubik(
                    color: Colors.blueGrey.shade800, fontSize: 12),
              ),
              const Spacer(),
              ScalableButton(
                  onPressed: () {
                    Future<void> f(String selected) async {
                      await Future.delayed(const Duration(milliseconds: 100));
                      Dialogs.showLoadingDialog(context, _keyLoader);

                      await model.simulate(selected,
                          File('storage/scripts/$selected.json').absolute.path);
                      await Future.delayed(const Duration(milliseconds: 500));
                      Navigator.of(_keyLoader.currentContext,
                              rootNavigator: true)
                          .pop();

                      updateHistory();
                    }

                    SelectDialog.showModal<String>(
                      context,
                      label: 'Виберіть сценарій',
                      showSearchBox: false,
                      selectedValue: null,
                      items: List.generate(
                          scripts.length, (index) => scripts[index].name),
                      onChange: (String selected) {
                        f(selected);
                      },
                    );
                  },
                  scale: ScaleFormat.big,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.blueGrey.shade500.withOpacity(0.6),
                            width: 1.2)),
                    padding: const EdgeInsets.all(3.2),
                    child: Icon(
                      Icons.play_arrow_outlined,
                      size: 11,
                      color: Colors.blueGrey.shade900,
                    ),
                  )),
              const SizedBox(width: 4),
              ScalableButton(
                  onPressed: () {
                    if (Platform.isWindows) {
                      Process.run('explorer.exe', ['/select,', model.path]);
                    } else {
                      print(model.path);
                      Process.run('xdg-open', [
                        model.path
                            .split('/')
                            .getRange(0, model.path.split('/').length - 1)
                            .join('/')
                      ]);
                    }
                  },
                  scale: ScaleFormat.big,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.blueGrey.shade500.withOpacity(0.6),
                            width: 1.2)),
                    padding: const EdgeInsets.all(3.2),
                    child: Icon(
                      Icons.folder_open,
                      size: 11,
                      color: Colors.blueGrey.shade900,
                    ),
                  )),
              const SizedBox(width: 4),
              ScalableButton(
                  onPressed: remove,
                  scale: ScaleFormat.big,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.blueGrey.shade500.withOpacity(0.6),
                            width: 1.2)),
                    padding: const EdgeInsets.all(3.2),
                    child: Icon(
                      Icons.delete_outline,
                      size: 11,
                      color: Colors.blueGrey.shade900,
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '${DateFormat('yyyy-MM-dd').format(model.lastModified)} • ${NumberFormat('#,##0.##').format(model.size ?? 0).replaceAll(',', ' ')} Mb',
            style: GoogleFonts.rubik(
                fontSize: 10, color: Colors.blueGrey.shade700),
          )
        ],
      ),
    );
  }
}
