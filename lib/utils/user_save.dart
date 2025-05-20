import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

Future<void> saveAuthState(Map<String, dynamic> userInfo) async {
  await storage.write(key: 'userInfo', value: jsonEncode(userInfo));
}

Future<Map<String, dynamic>?> loadAuthState() async {
  final userInfoString = await storage.read(key: 'userInfo');

  if (userInfoString != null) {
    return jsonDecode(userInfoString);
  }
  return null;
}

Future<void> logoutAuthState() async {
  await storage.deleteAll();
}
