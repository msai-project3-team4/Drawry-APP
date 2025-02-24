import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  // 🔹 토큰 저장
  static Future<void> saveToken(String accessToken) async {
    await _storage.write(key: "access_token", value: accessToken);
  }

  // 🔹 토큰 가져오기
  static Future<String?> getToken() async {
    return await _storage.read(key: "access_token");
  }

  // 🔹 토큰 삭제 (로그아웃 시 사용)
  static Future<void> deleteToken() async {
    await _storage.delete(key: "access_token");
  }
}
