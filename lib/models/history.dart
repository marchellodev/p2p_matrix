import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:p2p_matrix/components/buttons.dart';
import 'package:p2p_matrix/screens/matrix_result.dart';

part 'history.g.dart';

@JsonSerializable(explicitToJson: true)
class HistoryModel {
  final String scriptName;
  final String modelName;
  final int scriptOperations;
  final int scriptNodes;
  final DateTime modelCreated;
  final double modelSize;
  final DateTime historyDate;

  final HistoryStats timeToAcquireDate;
  final HistoryStats amountOfUsedNodes;
  final HistoryStats usedMemory;
  final double dataNotFound;

  final String fileName;

  HistoryModel({
    @required this.scriptName,
    @required this.scriptNodes,
    @required this.scriptOperations,
    @required this.modelName,
    @required this.modelCreated,
    @required this.modelSize,
    @required this.historyDate,
    @required this.timeToAcquireDate,
    @required this.amountOfUsedNodes,
    @required this.usedMemory,
    @required this.dataNotFound,
    @required this.fileName,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class HistoryStats {
  final double average;
  final double median;
  final double range;
  final double standardDeviation;

  const HistoryStats({
    @required this.average,
    @required this.median,
    @required this.range,
    @required this.standardDeviation,
  });

  factory HistoryStats.fromJson(Map<String, dynamic> json) =>
      _$HistoryStatsFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryStatsToJson(this);
}

class HistoryModelCard extends StatelessWidget {
  final HistoryModel model;

  const HistoryModelCard(this.model);

  @override
  Widget build(BuildContext context) {
    return ScalableButton(
      onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => MatrixResultScreen(model)));
      },
      scale: ScaleFormat.small,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(6)),
                  ),
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  child: Text(
                    model.modelName,
                    style: GoogleFonts.rubik(
                        color: Colors.blueGrey.shade800, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius:
                        const BorderRadius.vertical(bottom: Radius.circular(6)),
                  ),
                  width: double.infinity,
                  child: Text(
                    model.scriptName,
                    style: GoogleFonts.rubik(
                        color: Colors.blueGrey.shade800, fontSize: 12),
                  ),
                ),
              ],
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.blueGrey.shade200),
                  padding: const EdgeInsets.all(3.4),
                  margin: const EdgeInsets.all(8),
                  child: Text(
                    DateFormat('yyyy-MM-dd hh:mm:ss').format(model.historyDate),
                    style: GoogleFonts.rubik(
                        color: Colors.blueGrey.shade700, fontSize: 10),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
