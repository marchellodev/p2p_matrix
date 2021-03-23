// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pings _$PingsFromJson(Map<String, dynamic> json) {
  return Pings(
    pings: (json['pings'] as List)?.map((e) => e == null ? null : PingPair.fromJson(e as Map<String, dynamic>))?.toList(),
    locations: (json['locations'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(int.parse(k), e as String),
    ),
  );
}

Map<String, dynamic> _$PingsToJson(Pings instance) => <String, dynamic>{
      'pings': instance.pings?.map((e) => e?.toJson())?.toList(),
      'locations': instance.locations?.map((k, e) => MapEntry(k.toString(), e)),
    };

PingPair _$PingPairFromJson(Map<String, dynamic> json) {
  return PingPair(
    l1: json['l1'] as int,
    l2: json['l2'] as int,
    p: (json['p'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$PingPairToJson(PingPair instance) => <String, dynamic>{
      'l1': instance.l1,
      'l2': instance.l2,
      'p': instance.p,
    };
