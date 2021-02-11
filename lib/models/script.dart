import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:json_annotation/json_annotation.dart';

import '../components/buttons.dart';

part 'script.g.dart';

@JsonSerializable(explicitToJson: true)
class ScriptModel {
  final String name;
  final int operations;
  final int nodesAmount;
  final int peersMin;
  final int peersMax;
  final int fileSizeMin;
  final int fileSizeMax;
  final Map<int, ScriptNode> nodes;
  final Map<int, ScriptFile> files;
  final List<ScriptStoryElement> story;

  const ScriptModel(
      {@required this.name,
      @required this.operations,
      @required this.nodesAmount,
      @required this.peersMin,
      @required this.peersMax,
      @required this.fileSizeMin,
      @required this.fileSizeMax,
      @required this.nodes,
      @required this.files,
      @required this.story});

  static Map<int, ScriptNode> genNodes(int max) {
    final result = <int, ScriptNode>{};

    final rand = Random();
    for (var i = 1; i <= max; i++) {
      result[i] = ScriptNode.gen(rand);
    }

    return result;
  }

  static Map<int, ScriptFile> genFiles(int nodes, double min, double max) {
    final result = <int, ScriptFile>{};

    final rand = Random();
    for (var i = 1; i <= nodes ~/ 2; i++) {
      result[i] = ScriptFile.gen(rand, min, max);
    }

    return result;
  }

  static List<ScriptStoryElement> genStory(int nodes) {
    final maxFiles = nodes ~/ 2;

    // here we generate the story lol

  }

  factory ScriptModel.fromJson(Map<String, dynamic> json) =>
      _$ScriptModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScriptModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ScriptNode {
  // todo maybe use an enum ?
  final int location;
  final double speed;

  const ScriptNode({
    @required this.location,
    @required this.speed,
  });

  factory ScriptNode.fromJson(Map<String, dynamic> json) =>
      _$ScriptNodeFromJson(json);

  Map<String, dynamic> toJson() => _$ScriptNodeToJson(this);

  static ScriptNode gen(Random rand) {
    return ScriptNode(
        location: rand.nextInt(285 + 1),
        speed: double.parse(
            (rand.nextDouble() * (5 - 0.5) + 0.5).toStringAsFixed(4)));
  }
}

@JsonSerializable(explicitToJson: true)
class ScriptFile {
  final double size;

  const ScriptFile({
    @required this.size,
  });

  static ScriptFile gen(Random rand, double min, double max) {
    return ScriptFile(
        size: double.parse(
            (rand.nextDouble() * (max - min) + min).toStringAsFixed(4)));
  }

  factory ScriptFile.fromJson(Map<String, dynamic> json) =>
      _$ScriptFileFromJson(json);

  Map<String, dynamic> toJson() => _$ScriptFileToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ScriptStoryElement {
  final Map<int, ScriptElementNodeAction> nodeActions;
  final Map<int, ScriptElementOperation> operations;

  const ScriptStoryElement({
    @required this.nodeActions,
    @required this.operations,
  });

  factory ScriptStoryElement.fromJson(Map<String, dynamic> json) =>
      _$ScriptStoryElementFromJson(json);

  Map<String, dynamic> toJson() => _$ScriptStoryElementToJson(this);
}

enum ScriptElementNodeAction { on, off }

@JsonSerializable(explicitToJson: true)
class ScriptElementOperation {
  final int fileId;
  final ScriptElementOperationType type;

  const ScriptElementOperation({
    @required this.fileId,
    @required this.type,
  });

  factory ScriptElementOperation.fromJson(Map<String, dynamic> json) =>
      _$ScriptElementOperationFromJson(json);

  Map<String, dynamic> toJson() => _$ScriptElementOperationToJson(this);
}

enum ScriptElementOperationType { read, write }

class ScriptModelCard extends StatelessWidget {
  // final ScriptModel model;
  //
  // const ScriptModelCard(this.model);

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
                'сценарій_13',
                style: GoogleFonts.rubik(
                    color: Colors.blueGrey.shade800, fontSize: 12),
              ),
              const Spacer(),
              ScalableButton(
                  onPressed: () {},
                  scale: ScaleFormat.big,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.blueGrey.shade500.withOpacity(0.6),
                            width: 1.2)),
                    padding: const EdgeInsets.all(3.2),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 11,
                      color: Colors.blueGrey.shade900,
                    ),
                  )),
              const SizedBox(width: 4),
              ScalableButton(
                  onPressed: () {},
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
            '6 000 операцій • 500 вузлів',
            style: GoogleFonts.rubik(
                fontSize: 10, color: Colors.blueGrey.shade700),
          )
        ],
      ),
    );
  }
}
