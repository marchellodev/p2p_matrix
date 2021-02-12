import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:p2p_matrix/components/buttons.dart';
import 'package:p2p_matrix/models/history.dart';

class MatrixResultScreen extends StatelessWidget {
  final HistoryModel model;

  const MatrixResultScreen(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blueGrey.shade900, Colors.blueGrey.shade800])),
        child: Column(
          children: [
            Container(
              height: 76,
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ScalableButton(
                      scale: ScaleFormat.big,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.grey.shade50,
                        size: 20,
                      )),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Результати симуляції',
                    style: GoogleFonts.rubik(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFF5F5F5),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'експорт',
                    style: GoogleFonts.rubik(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(width: 6),
                  ScalableButton(
                    scale: ScaleFormat.big,
                    onPressed: () {
                      Process.run('explorer.exe',
                          ['/select,', 'storage\\history\\${model.fileName}']);
                    },
                    child: Text(
                      '.json',
                      style: GoogleFonts.rubik(
                        fontSize: 14,
                        color: Colors.grey.shade50,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1.2,
              color: Colors.blueGrey.shade800,
            ),
            Expanded(
                child: Row(
              children: [
                SizedBox(
                  width: 260,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey.shade100,
                            borderRadius: BorderRadius.circular(6)),
                        margin: const EdgeInsets.symmetric(horizontal: 18),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              model.modelName,
                              style: GoogleFonts.rubik(
                                  color: Colors.blueGrey.shade800,
                                  fontSize: 12),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${DateFormat('yyyy-MM-dd').format(model.modelCreated)} • ${NumberFormat('#,##0.##').format(model.modelSize).replaceAll(',', ' ')} Mb',
                              style: GoogleFonts.rubik(
                                  fontSize: 10,
                                  color: Colors.blueGrey.shade700),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey.shade100,
                            borderRadius: BorderRadius.circular(6)),
                        margin: const EdgeInsets.symmetric(horizontal: 18),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'model',
                              style: GoogleFonts.rubik(
                                  color: Colors.blueGrey.shade800,
                                  fontSize: 12),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${NumberFormat('#,##0').format(model.scriptOperations).replaceAll(',', ' ')} операцій • ${NumberFormat('#,##0').format(model.scriptNodes).replaceAll(',', ' ')} вузлів',
                              style: GoogleFonts.rubik(
                                  fontSize: 10,
                                  color: Colors.blueGrey.shade700),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 2,
                  color: Colors.blueGrey.shade700,
                ),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    children: [
                      StatsCard(
                          title: 'Час отримання даних із мережі',
                          dataType: 'с',
                          stats: model.timeToAcquireDate),
                      const SizedBox(height: 22),
                      StatsCard(
                          title:
                              'Кількість задіяних вузлів при отриманні даних',
                          dataType: '',
                          stats: model.amountOfUsedNodes),
                      const SizedBox(height: 22),
                      StatsCard(
                          title: 'Дані збережені кожним вузлом',
                          dataType: 'Mb',
                          stats: model.usedMemory),
                      const SizedBox(height: 22),
                      Column(
                        children: [
                          Text(
                            'Дані не знайдені',
                            style: GoogleFonts.rubik(
                                fontSize: 14, color: Colors.grey.shade50),
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: [
                              Text(
                                '${(model.dataNotFound * 100).toStringAsFixed(4)} %',
                                style: GoogleFonts.rubik(
                                    fontSize: 16, color: Colors.grey.shade100),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}

class StatsCard extends StatelessWidget {
  final String title;
  final HistoryStats stats;
  final String dataType;

  const StatsCard({
    @required this.title,
    @required this.stats,
    @required this.dataType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.rubik(fontSize: 14, color: Colors.grey.shade50),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(
                  '${NumberFormat('#,##0.##').format(stats.average).replaceAll(',', ' ')} $dataType',
                  style: GoogleFonts.rubik(
                      fontSize: 16, color: Colors.grey.shade100),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  'середнє',
                  style: GoogleFonts.rubik(
                      fontSize: 12, color: Colors.grey.shade400),
                )
              ],
            ),
            const SizedBox(width: 22),
            Column(
              children: [
                Text(
                  '${NumberFormat('#,##0.##').format(stats.median).replaceAll(',', ' ')} $dataType',
                  style: GoogleFonts.rubik(
                      fontSize: 16, color: Colors.grey.shade100),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  'медіана',
                  style: GoogleFonts.rubik(
                      fontSize: 12, color: Colors.grey.shade400),
                )
              ],
            ),
            const SizedBox(width: 22),
            Column(
              children: [
                Text(
                  '${NumberFormat('#,##0.##').format(stats.range).replaceAll(',', ' ')} $dataType',
                  style: GoogleFonts.rubik(
                      fontSize: 16, color: Colors.grey.shade100),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  'розмах',
                  style: GoogleFonts.rubik(
                      fontSize: 12, color: Colors.grey.shade400),
                )
              ],
            ),
            const SizedBox(width: 22),
            Column(
              children: [
                Text(
                  '${NumberFormat('#,##0.##').format(stats.standardDeviation).replaceAll(',', ' ')} $dataType',
                  style: GoogleFonts.rubik(
                      fontSize: 16, color: Colors.grey.shade100),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  'середнє\nвідхилення',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rubik(
                      fontSize: 12, color: Colors.grey.shade400),
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}
