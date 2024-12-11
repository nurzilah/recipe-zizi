import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_pertemuan7/services/session_services.dart';

const String baseUrl = 'https://recipe.incube.id/api';

class AuthServices {
  final SessionService _sessionService = SessionService();

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await _sessionService.saveToken(data['data']['token']);
      return {'status': true, 'message': 'Registration successful'};
    } else {
      return {'status': false, 'message': 'Registration failed'};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _sessionService.saveToken(data['data']['token']);
      return {'status': true, 'message': 'Login successful'};
    } else {
      return {'status': false, 'message': 'Invalid credentials'};
    }
  }

  Future<bool> logout() async {
    final token = await _sessionService.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      await _sessionService.clearSession();
      return true;
    } else {
      return false;
    }
  }
}
