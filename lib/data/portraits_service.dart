import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/portrait.dart';

class PortraitsService {
  final String jsonUrl; // <-- name the field
  PortraitsService(this.jsonUrl);

  static const _kCacheKey = 'portraits_json_cache';

  Future<List<Portrait>> fetch() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      // try network first
      final res = await http.get(Uri.parse(jsonUrl));
      if (res.statusCode == 200) {
        await prefs.setString(_kCacheKey, res.body);
        return _parse(res.body);
      }
    } catch (_) {
      // ignore network errors, fall back to cache
    }

    // fallback: cached data if available
    final cached = prefs.getString(_kCacheKey);
    if (cached != null) {
      return _parse(cached);
    }

    // no network, no cache
    return [];
  }

  List<Portrait> _parse(String body) {
    final raw = jsonDecode(body) as List;
    return raw
        .map((e) => Portrait.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}