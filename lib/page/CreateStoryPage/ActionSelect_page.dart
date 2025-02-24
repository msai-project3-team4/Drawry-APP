import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ActionSelectPage extends StatefulWidget {
  const ActionSelectPage({super.key});

  @override
  _ActionSelectPageState createState() => _ActionSelectPageState();
}

class _ActionSelectPageState extends State<ActionSelectPage> {
  final storage = const FlutterSecureStorage();
  String? selectedAction; // 선택한 액션 저장

  // ✅ 액션 목록
  final List<String> actions = [
    "마법의 램프로 세 가지 소원을 빌기 시작했어!",
    "반짝이는 보물을 발견했어!",
    "마법의 양탄자를 타고 날아다녀!"
  ];

  // ✅ 선택한 액션을 저장하는 함수
  Future<void> _saveActionSelection() async {
    if (selectedAction == null) return;

    String? nickname = await storage.read(key: "nickname"); // 닉네임 가져오기
    if (nickname == null) return;

    String apiUrl = "http://52.141.26.75:8000/library/library/$nickname/select-action";
    print("📌 액션 저장 API 호출: $apiUrl");

    Map<String, dynamic> requestBody = {"action": selectedAction};

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print("✅ 액션 저장 성공!");
        Navigator.pushNamed(context, '/SketchPage'); // ✅ 다음 페이지로 이동
      } else {
        print("❌ 액션 저장 실패: ${response.statusCode} / 응답: ${response.body}");
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
            // ✅ 좌측 상단 뒤로가기 버튼
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 10),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, size: 30, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            const Spacer(),

            // ✅ 질문 텍스트
            const Center(
              child: Column(
                children: [
                  Text(
                    "시작할 내용을 구상해볼까?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "주인공은 무엇을 하고 있을까!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ✅ 버튼들을 중앙 정렬
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: actions.map((action) {
                bool isSelected = action == selectedAction;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                  child: SizedBox(
                    width: double.infinity, // ✅ 버튼 너비 화면 전체
                    height: 55, // ✅ 버튼 높이 통일
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedAction = action;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? Colors.orange.shade700 : Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // ✅ 버튼 둥글게
                        ),
                      ),
                      child: Text(
                        action,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const Spacer(),

            // ✅ "다음" 버튼 (하단 정렬)
            Center(
              child: SizedBox(
                width: 200, // ✅ "다음" 버튼 크기 고정
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveActionSelection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // ✅ 버튼 둥글게
                    ),
                  ),
                  child: const Text(
                    "다음",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
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
