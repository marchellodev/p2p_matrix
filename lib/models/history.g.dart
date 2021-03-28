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
    fileName: json['fileName'] as String,
    result: json['result'] == null
        ? null
        : ResultModel.fromJson(json['result'] as Map<String, dynamic>),
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
      'fileName': instance.fileName,
      'result': instance.result?.toJson(),
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

ResultModel _$ResultModelFromJson(Map<String, dynamic> json) {
  return ResultModel(
    storageHistoryStats: json['storageHistoryStats'] == null
        ? null
        : HistoryStats.fromJson(
            json['storageHistoryStats'] as Map<String, dynamic>),
    usedNodesStats: json['usedNodesStats'] == null
        ? null
        : HistoryStats.fromJson(json['usedNodesStats'] as Map<String, dynamic>),
    operationTimeStats: json['operationTimeStats'] == null
        ? null
        : HistoryStats.fromJson(
            json['operationTimeStats'] as Map<String, dynamic>),
    fileNotFound: (json['fileNotFound'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$ResultModelToJson(ResultModel instance) =>
    <String, dynamic>{
      'storageHistoryStats': instance.storageHistoryStats?.toJson(),
      'usedNodesStats': instance.usedNodesStats?.toJson(),
      'operationTimeStats': instance.operationTimeStats?.toJson(),
      'fileNotFound': instance.fileNotFound,
    };
