import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:p2p_matrix/models/pings.dart';

import '../components/buttons.dart';
import '../log.dart';

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
  final Pings pings;

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
      @required this.story,
      @required this.pings});

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

  // todo check nodesMin, nodesMax, nodes whether they make sense
  static List<ScriptStoryElement> genStory(
      int nodes, int actions, int nodesMin, int nodesMax) {
    final maxFiles = nodes ~/ 2;
    final story = <ScriptStoryElement>[];
    final filesInTheNetwork = <int>[];
    final nodesTurnedOn = <int>[];
    // nodes: from 1 to nodes

    final rand = Random();
// todo no need to create a list, just use random

    // bootstrap
    while (nodesTurnedOn.length < nodesMin) {
      final randomNode = rand.nextInt(nodes - 1) + 1;
      if (!nodesTurnedOn.contains(randomNode)) {
        nodesTurnedOn.add(randomNode);
      }
    }

    story.add(ScriptStoryElement(nodeActions: {
      for (var el in nodesTurnedOn) el: ScriptElementNodeAction.on
    }, operations: {}));

    // generating the story itself
    for (var i = 0; i < actions ~/ 5; i++) {
      final nodeActions = <int, ScriptElementNodeAction>{};
      final nodeOperations = <int, ScriptElementOperation>{};

      // for (var i = 1; i <= nodes; i++) {
      //   if (rand.nextDouble() > 0.01) {
      //
      //     nodeActions[i] = ScriptElementNodeAction.on;
      //   }
      //
      //   if (rand.nextDouble() > 0.0008) {
      //     nodeActions[i] = ScriptElementNodeAction.off;
      //   }
      // }

      final newNodes = nodesMin + rand.nextInt(nodesMax - nodesMin);

      while (nodesTurnedOn.length > newNodes) {
        nodesTurnedOn.shuffle();
        nodeActions[nodesTurnedOn[0]] = ScriptElementNodeAction.off;
        nodesTurnedOn.remove(nodesTurnedOn[0]);
      }

      while (nodesTurnedOn.length < newNodes) {
        final randomNode = rand.nextInt(nodes - 1) + 1;
        if (!nodesTurnedOn.contains(randomNode)) {
          nodesTurnedOn.add(randomNode);
          nodeActions[randomNode] = ScriptElementNodeAction.on;
        }
      }

      for (var i = 0; i < rand.nextInt(4) + 1; i++) {
        if (rand.nextDouble() > 0.5 || filesInTheNetwork.isEmpty) {
          final file = rand.nextInt(maxFiles - 1) + 1;
          nodesTurnedOn.shuffle(rand);
          final node = nodesTurnedOn.first;
          if (!nodeOperations.keys.contains(node)) {
            nodeOperations[node] = ScriptElementOperation(
                type: ScriptElementOperationType.write, fileId: file);
          }
        } else {
          filesInTheNetwork.shuffle(rand);
          final file = filesInTheNetwork.first;
          nodesTurnedOn.shuffle();
          final node = nodesTurnedOn[0];
          nodeOperations[node] = ScriptElementOperation(
              type: ScriptElementOperationType.read, fileId: file);
        }
      }
      // var operation;
      // if (filesInTheNetwork.isEmpty) {
      //   final id = rand.nextInt(maxFiles - 1) + 1;
      //   // operation = {id: ScriptElementOperation.};
      // }

      story.add(ScriptStoryElement(
          nodeActions: nodeActions, operations: nodeOperations));
    }

    return story;
    /*
    LOL

    allright, here are the chances:
    node turns on: max(1-(turned_on / all), 0.3) (10/100)
    node turns off: max(1-(turned_off / all), 0.2)
    file_write: 0.1
    file_read: 0.05

     */
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

  ScriptNode.gen(Random rand)
      : location = rand.nextInt(285 + 1),
        speed = double.parse(
            (rand.nextDouble() * (5 - 0.5) + 0.5).toStringAsFixed(4));
}

@JsonSerializable(explicitToJson: true)
class ScriptFile {
  final double size;

  const ScriptFile({
    @required this.size,
  });

  ScriptFile.gen(Random rand, double min, double max)
      : size = double.parse(
            (rand.nextDouble() * (max - min) + min).toStringAsFixed(4));

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
  final ScriptModel model;
  final Function() onRemove;

  const ScriptModelCard(this.model, this.onRemove);

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
                model.name,
                style: GoogleFonts.rubik(
                    color: Colors.blueGrey.shade800, fontSize: 12),
              ),
              const Spacer(),
              ScalableButton(
                  onPressed: () {
                    Process.run('explorer.exe',
                        ['/select,', 'storage\\scripts\\${model.name}.json']);
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
                  onPressed: () {
                    onRemove();

                    llog('Removed script ${model.name}.json');
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
                      Icons.delete_outline,
                      size: 11,
                      color: Colors.blueGrey.shade900,
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '${NumberFormat('#,##0').format(model?.operations ?? 0).replaceAll(',', ' ')} операцій • ${NumberFormat('#,##0').format(model?.nodesAmount ?? 0).replaceAll(',', ' ')} вузлів',
            style: GoogleFonts.rubik(
                fontSize: 10, color: Colors.blueGrey.shade700),
          )
        ],
      ),
    );
  }
}
