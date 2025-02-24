import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nicknameController = TextEditingController();
  static const storage = FlutterSecureStorage();
  bool _isLoading = false;

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    String nickname = _nicknameController.text.trim();
    if (nickname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("닉네임을 입력해주세요."), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String apiUrl = dotenv.env['API_URL_LOGIN'] ?? "http://52.141.26.75:8000/auth/login";
    print("📌 API 요청 URL: $apiUrl");

    Map<String, dynamic> requestBody = {"nickname": nickname};

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String accessToken = responseData['access_token'];

        print("✅ 로그인 성공! 토큰: $accessToken");

        await storage.write(key: "access_token", value: accessToken);
        await storage.write(key: "nickname", value: nickname);

        // ✅ 로그인 후 서재 상태 확인
        await _checkLibraryStatus(nickname);
      } else {
        print("❌ 로그인 실패: ${response.statusCode} / 응답: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("로그인 실패: 닉네임을 확인하세요."), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print("❌ 네트워크 오류 발생: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("네트워크 오류: $e"), backgroundColor: Colors.red),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  // ✅ 서재 상태 확인 함수 (서재가 없으면 동화 만들기 페이지로 이동)
  Future<void> _checkLibraryStatus(String nickname) async {
    String apiUrl = dotenv.env['API_URL_LIBRARY'] ?? "http://52.141.26.75:8000/library/library/$nickname/status";
    print("📌 서재 조회 API 요청 URL: $apiUrl");

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        bool isLibraryEmpty = responseData['is_empty'];

        if (isLibraryEmpty) {
          print("📌 서재가 비어 있음 → 서재 생성 후 이동");
          await _createLibrary(nickname);  // ✅ 서재 자동 생성 추가
        }

        Navigator.pushReplacementNamed(context, '/CreateStoryPage');
      } else if (response.statusCode == 404) {
        print("📌 서재 없음 → 서재 자동 생성");
        await _createLibrary(nickname);  // ✅ 서재 자동 생성 추가
        Navigator.pushReplacementNamed(context, '/CreateStoryPage');
      } else {
        print("❌ 서재 조회 실패: ${response.statusCode} / 응답: ${response.body}");
      }
    } catch (e) {
      print("❌ 오류 발생: $e");
    }
  }

// ✅ 서재 자동 생성 API 호출 함수 추가
  Future<void> _createLibrary(String nickname) async {
    String apiUrl = "http://52.141.26.75:8000/library/library";
    print("📌 서재 생성 API 요청: $apiUrl");

    Map<String, dynamic> requestBody = {"nickname": nickname};

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ 서재 생성 성공!");
      } else {
        print("❌ 서재 생성 실패: ${response.statusCode} / 응답: ${response.body}");
      }
    } catch (e) {
      print("❌ 오류 발생: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCF0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "로그인",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // ✅ 닉네임 입력 필드
            TextField(
              controller: _nicknameController,
              decoration: InputDecoration(
                labelText: "닉네임 입력",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 20),
            // ✅ 로그인 버튼
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _loginUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isLoading ? Colors.grey : Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 14),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "로그인",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
