// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'script.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScriptModel _$ScriptModelFromJson(Map<String, dynamic> json) {
  return ScriptModel(
    name: json['name'] as String,
    operations: json['operations'] as int,
    nodesAmount: json['nodesAmount'] as int,
    peersMin: json['peersMin'] as int,
    peersMax: json['peersMax'] as int,
    fileSizeMin: json['fileSizeMin'] as int,
    fileSizeMax: json['fileSizeMax'] as int,
    nodes: (json['nodes'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(int.parse(k),
          e == null ? null : ScriptNode.fromJson(e as Map<String, dynamic>)),
    ),
    files: (json['files'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(int.parse(k),
          e == null ? null : ScriptFile.fromJson(e as Map<String, dynamic>)),
    ),
    story: (json['story'] as List)
        ?.map((e) => e == null
            ? null
            : ScriptStoryElement.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ScriptModelToJson(ScriptModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'operations': instance.operations,
      'nodesAmount': instance.nodesAmount,
      'peersMin': instance.peersMin,
      'peersMax': instance.peersMax,
      'fileSizeMin': instance.fileSizeMin,
      'fileSizeMax': instance.fileSizeMax,
      'nodes':
          instance.nodes?.map((k, e) => MapEntry(k.toString(), e?.toJson())),
      'files':
          instance.files?.map((k, e) => MapEntry(k.toString(), e?.toJson())),
      'story': instance.story?.map((e) => e?.toJson())?.toList(),
    };

ScriptNode _$ScriptNodeFromJson(Map<String, dynamic> json) {
  return ScriptNode(
    location: json['location'] as int,
    speed: (json['speed'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$ScriptNodeToJson(ScriptNode instance) =>
    <String, dynamic>{
      'location': instance.location,
      'speed': instance.speed,
    };

ScriptFile _$ScriptFileFromJson(Map<String, dynamic> json) {
  return ScriptFile(
    size: (json['size'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$ScriptFileToJson(ScriptFile instance) =>
    <String, dynamic>{
      'size': instance.size,
    };

ScriptStoryElement _$ScriptStoryElementFromJson(Map<String, dynamic> json) {
  return ScriptStoryElement(
    nodeActions: (json['nodeActions'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(int.parse(k),
          _$enumDecodeNullable(_$ScriptElementNodeActionEnumMap, e)),
    ),
    operations: (json['operations'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          int.parse(k),
          e == null
              ? null
              : ScriptElementOperation.fromJson(e as Map<String, dynamic>)),
    ),
  );
}

Map<String, dynamic> _$ScriptStoryElementToJson(ScriptStoryElement instance) =>
    <String, dynamic>{
      'nodeActions': instance.nodeActions?.map((k, e) =>
          MapEntry(k.toString(), _$ScriptElementNodeActionEnumMap[e])),
      'operations': instance.operations
          ?.map((k, e) => MapEntry(k.toString(), e?.toJson())),
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$ScriptElementNodeActionEnumMap = {
  ScriptElementNodeAction.on: 'on',
  ScriptElementNodeAction.off: 'off',
};

ScriptElementOperation _$ScriptElementOperationFromJson(
    Map<String, dynamic> json) {
  return ScriptElementOperation(
    fileId: json['fileId'] as int,
    type:
        _$enumDecodeNullable(_$ScriptElementOperationTypeEnumMap, json['type']),
  );
}

Map<String, dynamic> _$ScriptElementOperationToJson(
        ScriptElementOperation instance) =>
    <String, dynamic>{
      'fileId': instance.fileId,
      'type': _$ScriptElementOperationTypeEnumMap[instance.type],
    };

const _$ScriptElementOperationTypeEnumMap = {
  ScriptElementOperationType.read: 'read',
  ScriptElementOperationType.write: 'write',
};
