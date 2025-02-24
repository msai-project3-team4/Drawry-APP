import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorySelectPage extends StatefulWidget {
  const StorySelectPage({super.key});

  @override
  _StorySelectPageState createState() => _StorySelectPageState();
}

class _StorySelectPageState extends State<StorySelectPage> {
  final storage = const FlutterSecureStorage(); // ✅ 보안 저장소
  final List<Map<String, dynamic>> _stories = [
    {"title": "알라딘과 요술램프", "image": "assets/aladdin_genie.png", "available": true},
    {"title": "피터팬", "image": "assets/peterpan.png", "available": false},
    {"title": "장화신은 고양이", "image": "assets/puss_in_boots.png", "available": false},
  ];

  int _currentIndex = 0; // 현재 선택된 동화책 인덱스

  void _nextStory() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _stories.length;
    });
  }

  void _prevStory() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _stories.length) % _stories.length;
    });
  }

  // ✅ 동화책 선택 API 호출
  Future<void> _saveStorySelection(String selectedStory) async {
    String? nickname = await storage.read(key: "nickname"); // ✅ 닉네임 가져오기
    if (nickname == null) return;

    String apiUrl = "http://52.141.26.75:8000/library/library/$nickname/select-story";
    print("📌 동화책 저장 API 호출: $apiUrl");

    Map<String, dynamic> requestBody = {"title": selectedStory};

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print("✅ 동화책 저장 성공!");
        Navigator.pushNamed(context, '/CharacterSelectPage');
      } else {
        print("❌ 동화책 저장 실패: ${response.statusCode} / 응답: ${response.body}");
      }
    } catch (e) {
      print("❌ 오류 발생: $e");
    }
  }

  void _selectStory() {
    String selectedStory = _stories[_currentIndex]["title"];
    bool isAvailable = _stories[_currentIndex]["available"];

    if (isAvailable) {
      print("📖 선택된 동화책: $selectedStory (무료 사용 가능)");
      _saveStorySelection(selectedStory); // ✅ 선택한 동화책 저장
    } else {
      print("❌ 선택된 동화책: $selectedStory (구독 필요)");
      _showSubscriptionDialog();
    }
  }

  // ✅ 구독 안내 팝업
  void _showSubscriptionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("구독이 필요합니다"),
          content: const Text("이 동화책을 이용하려면 구독이 필요합니다.\n구독을 진행하시겠습니까?"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("닫기")),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/SubscriptionPage');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text("구독하기", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCF0),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 10),
                child: Image.asset('assets/icon.png', width: 100, height: 40, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 20),
            const Text("동 화 책 을  선 택 해 줘 🎧", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: const Icon(Icons.arrow_left, size: 40, color: Colors.orange), onPressed: _prevStory),
                Column(
                  children: [
                    Image.asset(_stories[_currentIndex]["image"], width: 180, height: 180, fit: BoxFit.cover),
                    const SizedBox(height: 10),
                    Text(_stories[_currentIndex]["title"], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                IconButton(icon: const Icon(Icons.arrow_right, size: 40, color: Colors.orange), onPressed: _nextStory),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _selectStory,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
              ),
              child: const Text("선택", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
