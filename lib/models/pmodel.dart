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
import 'package:p2p_matrix/log.dart';

import '../main.dart';

part 'pmodel.g.dart';

typedef GetNameFunction = Pointer<Utf8> Function();
typedef RunFunction = Pointer<Void> Function(
    Pointer<Utf8> json, Pointer<Utf8> path);

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

  Future<void> simulate(String scriptName) async {
    final rand = Random();

    final fileName =
        '${getName().toDartString()}_${scriptName}_${rand.nextInt(100000000)}.json';

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
    File('storage/history/$fileName').create(recursive: true);

    // File('storage/history/$fileName')
    //     .writeAsStringSync(jsonEncode(model.toJson()));

    run(scriptName.toNativeUtf8(),
        File('storage/history/$fileName').path.toNativeUtf8());

    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      final f = await File('storage/history/$fileName').length();

      if (f != 0) {
        llog('Response from the Go code saved here: storage/history/$fileName');

        updateHistory();
        return;
      }
      llog('Awaiting response from the Go code: 1 second passed');
    }
  }
}

class PModelCard extends StatelessWidget {
  final PModel model;
  final Function() remove;

  const PModelCard(this.model, this.remove);

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
                    model.simulate('rand');
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
                    Process.run('explorer.exe', ['/select,', model.path]);
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
