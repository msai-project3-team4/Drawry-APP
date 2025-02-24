import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SummaryPage extends StatefulWidget {
  final String nickname;
  final DateTime birthdate;

  const SummaryPage({super.key, required this.nickname, required this.birthdate});

  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  bool _isLoading = false;

  int calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Future<void> _registerUser() async {
    setState(() {
      _isLoading = true;
    });

    String apiUrl = dotenv.env['API_URL'] ?? "http://52.141.26.75:8000/auth/register";
    if (apiUrl.isEmpty || !Uri.parse(apiUrl).isAbsolute) {
      print("⚠️ 잘못된 API_URL 값 감지 → 기본 URL 사용");
      apiUrl = "http://52.141.26.75:8000/auth/register";
    }
    print("📌 API 요청 URL: $apiUrl");

    int age = calculateAge(widget.birthdate);
    String formattedBirthdate = DateFormat("yyyy-MM-dd").format(widget.birthdate);

    Map<String, dynamic> requestBody = {
      "nickname": widget.nickname,
      "age": age,
      "birthdate": formattedBirthdate,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("✅ 회원가입 성공! 응답: ${response.body}");
        Navigator.pushNamed(context, '/Select');
        return;
      } else {
        print("❌ 회원가입 실패: ${response.statusCode} / 응답: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("회원가입 실패: ${response.statusCode}"), backgroundColor: Colors.red),
        );
        return;
      }
    } catch (e) {
      print("❌ 오류 발생: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("네트워크 오류: $e"), backgroundColor: Colors.red),
      );
      return;
    }

  }

  @override
  Widget build(BuildContext context) {
    int age = calculateAge(widget.birthdate);
    String formattedBirthdate = DateFormat("yyyy-MM-dd").format(widget.birthdate);

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
            const Text("최종 확인", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange, width: 2),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("별명: ${widget.nickname}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("생년월일: $formattedBirthdate", style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Text("나이: 만 $age 세", style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _registerUser,
                style: ElevatedButton.styleFrom(backgroundColor: _isLoading ? Colors.grey : Colors.orange),
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("회원가입 완료"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
