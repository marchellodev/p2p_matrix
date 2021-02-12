// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryModel _$HistoryModelFromJson(Map<String, dynamic> json) {
  return HistoryModel(
    scriptName: json['scriptName'] as String,
    scriptNodes: json['scriptNodes'] as int,
    scriptOperations: json['scriptOperations'] as int,
    modelName: json['modelName'] as String,
    modelCreated: json['modelCreated'] == null
        ? null
        : DateTime.parse(json['modelCreated'] as String),
    modelSize: (json['modelSize'] as num)?.toDouble(),
    historyDate: json['historyDate'] == null
        ? null
        : DateTime.parse(json['historyDate'] as String),
    timeToAcquireDate: json['timeToAcquireDate'] == null
        ? null
        : HistoryStats.fromJson(
            json['timeToAcquireDate'] as Map<String, dynamic>),
    amountOfUsedNodes: json['amountOfUsedNodes'] == null
        ? null
        : HistoryStats.fromJson(
            json['amountOfUsedNodes'] as Map<String, dynamic>),
    usedMemory: json['usedMemory'] == null
        ? null
        : HistoryStats.fromJson(json['usedMemory'] as Map<String, dynamic>),
    dataNotFound: (json['dataNotFound'] as num)?.toDouble(),
    fileName: json['fileName'] as String,
  );
}

Map<String, dynamic> _$HistoryModelToJson(HistoryModel instance) =>
    <String, dynamic>{
      'scriptName': instance.scriptName,
      'modelName': instance.modelName,
      'scriptOperations': instance.scriptOperations,
      'scriptNodes': instance.scriptNodes,
      'modelCreated': instance.modelCreated?.toIso8601String(),
      'modelSize': instance.modelSize,
      'historyDate': instance.historyDate?.toIso8601String(),
      'timeToAcquireDate': instance.timeToAcquireDate?.toJson(),
      'amountOfUsedNodes': instance.amountOfUsedNodes?.toJson(),
      'usedMemory': instance.usedMemory?.toJson(),
      'dataNotFound': instance.dataNotFound,
      'fileName': instance.fileName,
    };

HistoryStats _$HistoryStatsFromJson(Map<String, dynamic> json) {
  return HistoryStats(
    average: (json['average'] as num)?.toDouble(),
    median: (json['median'] as num)?.toDouble(),
    range: (json['range'] as num)?.toDouble(),
    standardDeviation: (json['standardDeviation'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$HistoryStatsToJson(HistoryStats instance) =>
    <String, dynamic>{
      'average': instance.average,
      'median': instance.median,
      'range': instance.range,
      'standardDeviation': instance.standardDeviation,
    };
