import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/env.dart';

class ApiClient {
  final http.Client _client;
  final String baseUrl;
  ApiClient({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        baseUrl = baseUrl ?? Env.bffBase;

  Future<Map<String, dynamic>> getJson(String path) async {
    final r = await _client.get(Uri.parse('$baseUrl$path'));
    if (r.statusCode >= 200 && r.statusCode < 300) return jsonDecode(r.body);
    throw Exception('GET $path failed: ${r.statusCode} ${r.body}');
  }

  Future<Map<String, dynamic>> postJson(String path, Map<String, dynamic> body) async {
    final r = await _client.post(Uri.parse('$baseUrl$path'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body));
    if (r.statusCode >= 200 && r.statusCode < 300) return jsonDecode(r.body);
    throw Exception('POST $path failed: ${r.statusCode} ${r.body}');
  }
}
