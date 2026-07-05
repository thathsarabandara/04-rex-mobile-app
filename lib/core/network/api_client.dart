import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static const String baseUrl = 'http://192.168.1.100:5000/api';
  final _storage = const FlutterSecureStorage();
  
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  Future<void> saveTokens(String access, String refresh) async {
    await _storage.write(key: 'access_token', value: access);
    await _storage.write(key: 'refresh_token', value: refresh);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> get(String endpoint) async {
    return _requestWithRefresh(() => http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeadersSync(),
    ));
  }

  Future<http.Response> post(String endpoint, {Map<String, dynamic>? body}) async {
    return _requestWithRefresh(() => http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeadersSync(),
      body: body != null ? jsonEncode(body) : null,
    ));
  }

  Future<http.Response> put(String endpoint, {Map<String, dynamic>? body}) async {
    return _requestWithRefresh(() => http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeadersSync(),
      body: body != null ? jsonEncode(body) : null,
    ));
  }

  Future<http.Response> delete(String endpoint) async {
    return _requestWithRefresh(() => http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeadersSync(),
    ));
  }
  
  Map<String, String>? _currentHeaders;

  Future<http.Response> _requestWithRefresh(Future<http.Response> Function() requestFunc) async {
    _currentHeaders = await _getHeaders();
    http.Response response = await requestFunc();

    if (response.statusCode == 401) {
      // Try to refresh token
      final refreshed = await refreshToken();
      if (refreshed) {
        _currentHeaders = await _getHeaders();
        response = await requestFunc();
      } else {
        await clearTokens(); // Force logout
      }
    }

    return response;
  }
  
  Map<String, String> _getHeadersSync() {
    return _currentHeaders ?? {'Content-Type': 'application/json', 'Accept': 'application/json'};
  }

  Future<bool> refreshToken() async {
    final refresh = await getRefreshToken();
    if (refresh == null) return false;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/token/refresh'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refresh',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['access_token'] != null && data['refresh_token'] != null) {
          await saveTokens(data['access_token'], data['refresh_token']);
          return true;
        }
      }
    } catch (e) {
      // Error during refresh
    }
    return false;
  }
}

final apiClient = ApiClient();
