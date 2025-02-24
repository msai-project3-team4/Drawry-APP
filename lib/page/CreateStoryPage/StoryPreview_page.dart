import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StoryPreviewPage extends StatefulWidget {
  const StoryPreviewPage({super.key});

  @override
  _StoryPreviewPageState createState() => _StoryPreviewPageState();
}

class _StoryPreviewPageState extends State<StoryPreviewPage> {
  final storage = const FlutterSecureStorage();
  String _selectedStory = "로딩 중...";
  String _selectedCharacter = "로딩 중...";

  @override
  void initState() {
    super.initState();
    _fetchStorySelection(); // ✅ 선택된 동화책 & 캐릭터 불러오기
  }

  // ✅ 저장된 동화책 & 캐릭터 불러오는 API 호출
  Future<void> _fetchStorySelection() async {
    String? nickname = await storage.read(key: "nickname");
    if (nickname == null) return;

    String apiUrl = "http://52.141.26.75:8000/library/library/$nickname/selection";
    print("📌 저장된 동화책 & 캐릭터 조회 API 호출: $apiUrl");

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));

        // ✅ null 값 방지: 기본값 설정
        setState(() {
          _selectedStory = responseData["title"] ?? "동화책 없음";
          _selectedCharacter = responseData["character"] ?? "캐릭터 없음";
        });

        print("✅ 저장된 동화책: $_selectedStory");
        print("✅ 저장된 캐릭터: $_selectedCharacter");
      } else {
        print("❌ 저장된 동화책 & 캐릭터 조회 실패: ${response.statusCode} / 응답: ${response.body}");
      }
    } catch (e) {
      print("❌ 오류 발생: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCF0),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ 좌측 상단 앱 로고
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 10),
              child: Image.asset(
                'assets/icon.png', // 앱 로고 이미지
                width: 100,
                height: 40,
                fit: BoxFit.contain,
              ),
            ),

            const Spacer(), // 중앙 정렬을 위한 Spacer

            // ✅ 미리보기 텍스트
            Center(
              child: Column(
                children: [
                  Text(
                    "$_selectedStory의 $_selectedCharacter(으)로\n새로운 동화를 만들자!",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "먼저 주인공의 소개가 필요해",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(), // 중앙 정렬을 위한 Spacer

            // ✅ "다음" 버튼
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // ✅ 동화 제작 페이지로 이동
                  Navigator.pushNamed(context, '/TimeSelectPage');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                ),
                child: const Text(
                  "다음",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
