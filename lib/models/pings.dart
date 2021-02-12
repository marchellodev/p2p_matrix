import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pings.g.dart';

@JsonSerializable(explicitToJson: true)
class Pings {
  final List<PingPair> pings;
  final Map<int, String> locations;

  const Pings({
    @required this.pings,
    @required this.locations,
  });


//   static getLocationPings(BuildContext context) async {
//     final locations = <int, String>{};
//     final pings = <PingPair>[];
//
//     // final list = List.generate(285, (index) => index + 1).join(',');
//     // final result = await http.read('https://wondernetwork.com/ping-data?sources=$list&destinations=$list');
//     final data =
//         await DefaultAssetBundle.of(context).loadString('assets/pings.json');
// // locations are from 0 to 275
//
//     for (final el in jsonDecode(data)['sourcesList'] as List) {
//       print(int.parse(el['id'] as String));
//       locations[int.parse(el['id'] as String)] = el['name'] as String;
//     }
//     final j = jsonDecode(data)['pingData'] as Map;
//
//     for (final el in j.entries) {
//       print('d');
//
//       final elId = int.parse(el.key as String);
//       for (final elNested in (el.value as Map).entries) {
//         if (elNested.value['avg'] == null) {
//           continue;
//         }
//         pings.add(PingPair(
//             l1: elId,
//             l2: int.parse(elNested.key as String),
//             p: double.parse(elNested.value['avg'] as String)));
//       }
//     }
//
//     final model = Pings(pings: pings, locations: locations);
//
//
//     File('res.json').writeAsString(jsonEncode(model.toJson()));
//     // print();
//
//     // print(j['pingData'].length);
//   }


  static Future<Pings> loadFromAssets(BuildContext context) async {
    final data =
        await DefaultAssetBundle.of(context).loadString('assets/pings.json');

    return Pings.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }

  factory Pings.fromJson(Map<String, dynamic> json) => _$PingsFromJson(json);

  Map<String, dynamic> toJson() => _$PingsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PingPair {
  final int l1;
  final int l2;
  final double p;

  const PingPair({
    @required this.l1,
    @required this.l2,
    @required this.p,
  });

  factory PingPair.fromJson(Map<String, dynamic> json) =>
      _$PingPairFromJson(json);

  Map<String, dynamic> toJson() => _$PingPairToJson(this);
}
