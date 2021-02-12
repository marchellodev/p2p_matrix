import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:p2p_matrix/components/buttons.dart';

part 'pmodel.g.dart';

typedef StringFunction = Pointer<Utf8> Function();

@HiveType(typeId: 1)
class PModel {
  @HiveField(0)
  final String path;

  @HiveField(1)
  final double size;

  @HiveField(2)
  final DateTime lastModified;

  DynamicLibrary _lib;
  StringFunction getName;

  PModel({
    @required this.path,
    @required this.size,
    @required this.lastModified,
  }) {
    _lib = DynamicLibrary.open(path);
    getName = _lib
        .lookup<NativeFunction<StringFunction>>('GetModelName')
        .asFunction<StringFunction>();
  }

  void load() {
    print(getName().toDartString());

    // lib.lookupFunction<Pointer<Utf8> Function(), void Function()>('GetName').call();
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
                    model.load();
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
