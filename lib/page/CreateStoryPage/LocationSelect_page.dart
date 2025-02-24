import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocationSelectPage extends StatefulWidget {
  const LocationSelectPage({super.key});

  @override
  _LocationSelectPageState createState() => _LocationSelectPageState();
}

class _LocationSelectPageState extends State<LocationSelectPage> {
  final storage = const FlutterSecureStorage();
  String? selectedLocation;
  List<String> locations = ["아그라바", "시장", "왕궁", "마법의 동굴", "지니의 세계"];

  // ✅ API 호출하여 위치 저장
  Future<void> _saveLocationSelection(String location) async {
    String? nickname = await storage.read(key: "nickname");
    if (nickname == null) return;

    String apiUrl = "http://52.141.26.75:8000/library/library/$nickname/select-location";
    print("📌 위치 저장 API 호출: $apiUrl");

    Map<String, dynamic> requestBody = {"location": location};

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print("✅ 위치 저장 성공: $location");
        Navigator.pushNamed(context, '/ActionSelectPage');
      } else {
        print("❌ 위치 저장 실패: ${response.statusCode} / 응답: ${response.body}");
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
              "주인공은 어디에 있을까!",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            // ✅ 위치 선택 버튼들
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: locations.map((location) => _buildLocationButton(location)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ 위치 선택 버튼 위젯
  Widget _buildLocationButton(String location) {
    return ElevatedButton(
      onPressed: () => _saveLocationSelection(location),
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedLocation == location ? Colors.orange[700] : Colors.orange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
      ),
      child: Text(
        location,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
