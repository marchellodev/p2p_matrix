import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LocationPings {
  Map<String, Map<String, double>> list;

  static getLocationPings(BuildContext context) async {
    // final list = List.generate(285, (index) => index + 1).join(',');
    // final result = await http.read('https://wondernetwork.com/ping-data?sources=$list&destinations=$list');
    final data = await DefaultAssetBundle.of(context).loadString('assets/pings.json');

    jsonDecode(data);
    print(data.length);

  }
}
