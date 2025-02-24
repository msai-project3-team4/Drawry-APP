import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CharacterSelectPage extends StatefulWidget {
  const CharacterSelectPage({super.key});

  @override
  _CharacterSelectPageState createState() => _CharacterSelectPageState();
}

class _CharacterSelectPageState extends State<CharacterSelectPage> {
  final storage = const FlutterSecureStorage(); // ✅ Flutter Secure Storage
  final List<Map<String, dynamic>> _characters = [
    {"name": "알라딘", "image": "assets/aladdin.png"},
    {"name": "지니", "image": "assets/genie.png"},
    {"name": "자스민", "image": "assets/jasmine.png"},
    {"name": "술탄", "image": "assets/sultan.png"},
    {"name": "자파", "image": "assets/jafar.png"},
  ];

  int _currentIndex = 0; // 현재 선택된 캐릭터 인덱스

  void _nextCharacter() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _characters.length;
    });
  }

  void _prevCharacter() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _characters.length) % _characters.length;
    });
  }

  // ✅ 캐릭터 선택 API 호출
  Future<void> _saveCharacterSelection(String selectedCharacter) async {
    String? nickname = await storage.read(key: "nickname"); // ✅ 닉네임 가져오기
    if (nickname == null) return;

    String apiUrl = "http://52.141.26.75:8000/library/library/$nickname/select-character";
    print("📌 캐릭터 저장 API 호출: $apiUrl");

    Map<String, dynamic> requestBody = {"character": selectedCharacter};

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print("✅ 캐릭터 저장 성공!");
        Navigator.pushNamed(context, '/StoryPreviewPage');
      } else {
        print("❌ 캐릭터 저장 실패: ${response.statusCode} / 응답: ${response.body}");
      }
    } catch (e) {
      print("❌ 오류 발생: $e");
    }
  }

  void _selectCharacter() {
    String selectedCharacter = _characters[_currentIndex]["name"];
    print("🎭 선택된 캐릭터: $selectedCharacter");
    _saveCharacterSelection(selectedCharacter); // ✅ 선택한 캐릭터 저장
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCF0), // ✅ 배경색

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // ✅ 좌측 상단 앱 로고 추가
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 10),
                child: Image.asset(
                  'assets/icon.png', // ✅ 로고 이미지 파일
                  width: 100,
                  height: 40,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ 타이틀
            const Text(
              "캐 릭 터 를  선 택 해 줘 🎧",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            // ✅ 캐릭터 선택 영역
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔹 왼쪽 화살표 버튼
                IconButton(
                  icon: const Icon(Icons.arrow_left, size: 40, color: Colors.orange),
                  onPressed: _prevCharacter,
                ),

                // 🔹 캐릭터 이미지 및 이름
                Column(
                  children: [
                    Image.asset(
                      _characters[_currentIndex]["image"],
                      width: 180,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _characters[_currentIndex]["name"],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                // 🔹 오른쪽 화살표 버튼
                IconButton(
                  icon: const Icon(Icons.arrow_right, size: 40, color: Colors.orange),
                  onPressed: _nextCharacter,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ✅ 선택 버튼
            ElevatedButton(
              onPressed: _selectCharacter,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
              ),
              child: const Text(
                "선택",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
