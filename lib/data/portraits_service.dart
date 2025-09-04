import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/portrait.dart';

class PortraitsService {
  final String jsonUrl;
  PortraitsService(this.jsonUrl);

  static const _kCacheKey = 'portraits_json_cache';

  Future<List<Portrait>> fetch() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      if (kDebugMode) {
        debugPrint('🌐 Fetching portraits from $jsonUrl');
      }

      final res = await http.get(Uri.parse(jsonUrl));

      if (kDebugMode) {
        debugPrint('➡️ Response code: ${res.statusCode}');
      }

      if (res.statusCode == 200) {
        if (kDebugMode) {
          debugPrint('✅ Loaded portraits from network (${res.body.length} bytes)');
        }
        await prefs.setString(_kCacheKey, res.body);
        return _parse(res.body);
      } else {
        if (kDebugMode) {
          debugPrint('⚠️ Network request failed with ${res.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Exception while fetching: $e');
      }
    }

    // fallback: cached data if available
    final cached = prefs.getString(_kCacheKey);
    if (cached != null) {
      if (kDebugMode) {
        debugPrint('📦 Loaded portraits from cache');
      }
      return _parse(cached);
    }

    if (kDebugMode) {
      debugPrint('🚨 No portraits available (no network, no cache)');
    }
    return [];
  }

  List<Portrait> _parse(String body) {
    final raw = jsonDecode(body) as List;
    return raw
        .map((e) => Portrait.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
