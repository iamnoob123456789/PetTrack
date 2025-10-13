import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/match.dart';
import '../config.dart'; // ✅ import your config
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final storage = FlutterSecureStorage();

  Future<List<MatchModel>> fetchMatches() async {
    String? token = await storage.read(key: "token"); // JWT token

    final url = Uri.parse('${Config.backendUrl}/pets/matches'); // ✅ proper dynamic URL
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((json) => MatchModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load matches: ${response.statusCode}');
    }
  }
}
