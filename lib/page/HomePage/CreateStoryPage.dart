import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CreateStoryPage extends StatefulWidget {
  const CreateStoryPage({super.key});

  @override
  _CreateStoryPageState createState() => _CreateStoryPageState();
}

class _CreateStoryPageState extends State<CreateStoryPage> {
  final storage = const FlutterSecureStorage();
  String _nickname = "사용자"; // 기본 닉네임

  @override
  void initState() {
    super.initState();
    _loadNickname();
  }

  // ✅ 닉네임 불러오기
  Future<void> _loadNickname() async {
    String? nickname = await storage.read(key: "nickname");
    setState(() {
      _nickname = nickname ?? "사용자";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCF0), // ✅ 배경색

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10), // ✅ 상단 여백 추가

            // ✅ 상단 로고 (좌측 정렬)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Image.asset(
                'assets/icon.png',
                width: 110,
                height: 50,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 20),

            // ✅ 페이지 타이틀 (닉네임 포함)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                "$_nickname의 서재", // ✅ 닉네임 동적 적용
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ✅ 중앙 동화 만들기 박스
            Expanded(
              child: Center(
                child: Container(
                  width: 280,
                  height: 350,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF8EC),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ✅ 상단 갈색 책장 바
                      Container(
                        height: 16,
                        width: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCC6A0),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(height: 50),

                      // ✅ 중앙 텍스트
                      const Text(
                        "새로운 동화를 만들어볼까요?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ✅ "동화 생성하기" 버튼 (동화책 선택 페이지로 이동)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/StorySelectPage'); // ✅ 동화책 선택 페이지로 이동
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "동화 생성하기",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),

                      const SizedBox(height: 50),

                      // ✅ 하단 갈색 책장 바
                      Container(
                        height: 16,
                        width: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCC6A0),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
