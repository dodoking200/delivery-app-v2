import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

class TokenSecureStorage {
  static final _secureStorage = FlutterSecureStorage();

  // Save token securely
  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'token', value: token);
  }

  // Retrieve token securely
  static Future<String?> getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  // Remove token securely
  static Future<void> removeToken() async {

    final url = Uri.parse(constructImageUrl('api/logout'));
String? token =  await _secureStorage.read(key: 'token');
    final headers = {
      'Content-Type': 'application/json', // Ensures you're sending JSON
      'Authorization': 'Bearer '+token!, // Replace with your actual token
    };
    final response = await http.post(
      url,
      headers: headers,
    );

    await _secureStorage.delete(key: 'token');

  }
}
