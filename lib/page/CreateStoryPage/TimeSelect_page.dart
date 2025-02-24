import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TimeSelectPage extends StatefulWidget {
  const TimeSelectPage({super.key});

  @override
  _TimeSelectPageState createState() => _TimeSelectPageState();
}

class _TimeSelectPageState extends State<TimeSelectPage> {
  final storage = const FlutterSecureStorage();
  String? selectedTime;

  // ✅ API 호출하여 시간대 저장
  Future<void> _saveTimeSelection(String time) async {
    String? nickname = await storage.read(key: "nickname");
    if (nickname == null) return;

    String apiUrl = "http://52.141.26.75:8000/library/library/$nickname/select-time";
    print("📌 시간대 저장 API 호출: $apiUrl");

    Map<String, dynamic> requestBody = {"time": time};

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print("✅ 시간대 저장 성공: $time");
        Navigator.pushNamed(context, '/LocationSelectPage');
      } else {
        print("❌ 시간대 저장 실패: ${response.statusCode} / 응답: ${response.body}");
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
          children: [
            const SizedBox(height: 20),

            // ✅ 뒤로가기 버튼
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ 질문 텍스트
            const Text(
              "시작할 내용을 구상해볼까?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "먼저 시간대를 알려줘!",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 40),

            // ✅ 낮 / 밤 선택 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimeButton("낮"),
                const SizedBox(width: 20),
                _buildTimeButton("밤"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ✅ 시간대 선택 버튼 위젯
  Widget _buildTimeButton(String time) {
    return ElevatedButton(
      onPressed: () => _saveTimeSelection(time),
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedTime == time ? Colors.orange[700] : Colors.orange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
      ),
      child: Text(
        time,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
