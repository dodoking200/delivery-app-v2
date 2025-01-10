import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'main.dart';

class TokenSecureStorage {
  static const _secureStorage = FlutterSecureStorage();

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
    String? token = await _secureStorage.read(key: 'token');
    final headers = {
      'Content-Type': 'application/json', // Ensures you're sending JSON
      'Authorization': 'Bearer $token', // Replace with your actual token
    };
    final response = await http.post(
      url,
      headers: headers,
    );
    print("_____________________________________________");
    print(response.body);

    await _secureStorage.delete(key: 'token');
  }

  // Save user data securely
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _secureStorage.write(key: 'userData', value: jsonEncode(userData));
  }

  // Retrieve user data securely
  static Future<Map<String, dynamic>?> getUserData() async {
    String? userDataString = await _secureStorage.read(key: 'userData');
    if (userDataString != null) {
      return jsonDecode(userDataString);
    }
    return null;
  }

  // Remove user data securely
  static Future<void> removeUserData() async {
    await _secureStorage.delete(key: 'userData');
  }

  static Future<bool> hasToken() async {
    String? token = await getToken();
    print(token);
    print(token != null && token.isNotEmpty);
    return token != null && token.isNotEmpty;
  }
}