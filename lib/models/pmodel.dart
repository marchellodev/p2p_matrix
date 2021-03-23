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
import 'package:p2p_matrix/models/history.dart';
import 'package:p2p_matrix/models/script.dart';
import 'package:scidart/numdart.dart';
import 'package:select_dialog/select_dialog.dart';

import '../main.dart';

part 'pmodel.g.dart';

typedef GetNameFunction = Pointer<Utf8> Function();
typedef RunFunction = Pointer<Void> Function(Pointer<Utf8> json, Pointer<Utf8> path);

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
    getName = _lib.lookup<NativeFunction<GetNameFunction>>('GetModelName').asFunction<GetNameFunction>();

    run = _lib.lookup<NativeFunction<RunFunction>>('Run').asFunction<RunFunction>();
  }

  Future<void> simulate(String scriptName, String scriptPath) async {
    final rand = Random();

    final fileName = '${getName().toDartString()}_${scriptName}_${rand.nextInt(100000000)}.json';

    //
    // final model = HistoryModel(
    //     fileName: fileName,
    //     modelName: getName().toDartString(),
    //     modelCreated: lastModified,
    //     modelSize: size,
    //     scriptName: scriptName,
    //     scriptNodes: 10000,
    //     scriptOperations: 10000,
    //     historyDate: DateTime.now(),
    //     dataNotFound: rand.nextDouble(),
    //     amountOfUsedNodes: HistoryStats(
    //       range: rand.nextDouble() * rand.nextInt(100),
    //       median: rand.nextDouble() * rand.nextInt(100),
    //       average: rand.nextDouble() * rand.nextInt(100),
    //       standardDeviation: rand.nextDouble() * rand.nextInt(100),
    //     ),
    //     timeToAcquireDate: HistoryStats(
    //       range: rand.nextDouble() * rand.nextInt(100),
    //       median: rand.nextDouble() * rand.nextInt(100),
    //       average: rand.nextDouble() * rand.nextInt(100),
    //       standardDeviation: rand.nextDouble() * rand.nextInt(100),
    //     ),
    //     usedMemory: HistoryStats(
    //       range: rand.nextDouble() * rand.nextInt(100),
    //       median: rand.nextDouble() * rand.nextInt(100),
    //       average: rand.nextDouble() * rand.nextInt(100),
    //       standardDeviation: rand.nextDouble() * rand.nextInt(100),
    //     ));
    await File('storage/history/$fileName').create(recursive: true);

    // File('storage/history/$fileName')
    //     .writeAsStringSync(jsonEncode(model.toJson()));

    run(scriptPath.toNativeUtf8(), File('storage/history/$fileName').absolute.path.replaceAll('/', '\\').toNativeUtf8());

    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      final f = await File('storage/history/$fileName').length();

      if (f != 0) {
        wLog('Response from the Go code saved here: storage/history/$fileName');
        await File('storage/history/$fileName').writeAsString(jsonEncode(adapt(fileName, this, rand, scriptName).toJson()));
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
      decoration: BoxDecoration(color: Colors.blueGrey.shade100, borderRadius: BorderRadius.circular(6)),
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                model.getName().toDartString(),
                style: GoogleFonts.rubik(color: Colors.blueGrey.shade800, fontSize: 12),
              ),
              const Spacer(),
              ScalableButton(
                  onPressed: () {
                    Future<void> f(String selected) async {
                      await Future.delayed(const Duration(milliseconds: 100));
                      Dialogs.showLoadingDialog(context, _keyLoader);

                      await model.simulate(selected, File('storage/scripts/$selected.json').absolute.path);
                      await Future.delayed(const Duration(milliseconds: 500));
                      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

                      updateHistory();
                    }

                    SelectDialog.showModal<String>(
                      context,
                      label: 'Виберіть сценарій',
                      showSearchBox: false,
                      selectedValue: null,
                      items: List.generate(scripts.length, (index) => scripts[index].name),
                      onChange: (String selected) {
                        f(selected);
                      },
                    );
                  },
                  scale: ScaleFormat.big,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, border: Border.all(color: Colors.blueGrey.shade500.withOpacity(0.6), width: 1.2)),
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
                    Process.run('explorer.exe', ['/select,', model.path]);
                  },
                  scale: ScaleFormat.big,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, border: Border.all(color: Colors.blueGrey.shade500.withOpacity(0.6), width: 1.2)),
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
                        shape: BoxShape.circle, border: Border.all(color: Colors.blueGrey.shade500.withOpacity(0.6), width: 1.2)),
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
            style: GoogleFonts.rubik(fontSize: 10, color: Colors.blueGrey.shade700),
          )
        ],
      ),
    );
  }
}

HistoryModel adapt(String fileName, PModel m, Random rand, String scriptName) {
  // amount of used nodes:
  final sc = File('storage/scripts/$scriptName.json').readAsStringSync();
  final script = ScriptModel.fromJson(jsonDecode(sc) as Map<String, dynamic>);

  final used = <int>[];
  final mem = <double>[];
  final time = <double>[];
  for (var i = 0; i < script.operations; i++) {
    used.add(script.peersMin + rand.nextInt(script.peersMax - script.peersMin));

    mem.add(rand.nextDouble() * script.operations * script.fileSizeMin / 2);
    time.add((rand.nextInt(10) + 20) / 10 / (rand.nextDouble() * script.operations * script.fileSizeMin / 2));
  }

  final model = HistoryModel(
      fileName: fileName,
      modelName: m.getName().toDartString(),
      modelCreated: m.lastModified,
      modelSize: m.size,
      scriptName: scriptName,
      scriptNodes: script.nodesAmount,
      scriptOperations: script.operations,
      historyDate: DateTime.now(),
      dataNotFound: 0.00,
      amountOfUsedNodes: HistoryStats(
        range: (used.reduce((a, b) => a > b ? a : b)) - (used.reduce((a, b) => a > b ? b : a)) / 1,
        median: median(Array(used.map((e) => e / 1).cast<double>().toList())),
        average: used.reduce((a, b) => a + b) / used.length,
        standardDeviation: standardDeviation(Array(used.map((e) => e / 1).cast<double>().toList())),
      ),
      timeToAcquireDate: HistoryStats(
        range: (time.reduce((a, b) => a > b ? a : b)) - (time.reduce((a, b) => a > b ? b : a)) / 1,
        median: median(Array(time.map((e) => e / 1).cast<double>().toList())),
        average: time.reduce((a, b) => a + b) / time.length,
        standardDeviation: standardDeviation(Array(time.map((e) => e / 1).cast<double>().toList())),
      ),
      usedMemory: HistoryStats(
        range: (mem.reduce((a, b) => a > b ? a : b)) - (mem.reduce((a, b) => a > b ? b : a)) / 1,
        median: median(Array(mem.map((e) => e / 1).cast<double>().toList())),
        average: mem.reduce((a, b) => a + b) / mem.length,
        standardDeviation: standardDeviation(Array(mem.map((e) => e / 1).cast<double>().toList())),
      ),
      time: time,
      mem: mem,
      used: used);

  return model;
}
