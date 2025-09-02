import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/portrait.dart';

abstract class PortraitRepository {
  Future<List<Portrait>> loadAll();
}

class LocalAssetPortraitRepository implements PortraitRepository {
  final String jsonPath;
  LocalAssetPortraitRepository({this.jsonPath = 'assets/portraits.json'});

  @override
  Future<List<Portrait>> loadAll() async {
    final raw = await rootBundle.loadString(jsonPath);
    final list = json.decode(raw) as List;
    return list
        .map((e) => Portrait.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
