import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  static const storage = FlutterSecureStorage();
  String? _nickname;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    String? nickname = await storage.read(key: "nickname"); // ✅ 닉네임 불러오기
    setState(() {
      _nickname = nickname ?? "@@"; // 닉네임이 없을 경우 기본값 설정
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCF0), // ✅ 배경색

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // ✅ 왼쪽 정렬
          children: [
            const SizedBox(height: 10), // ✅ 상단 여백 추가

            // ✅ 상단 로고 (좌측 배치)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Image.asset(
                'assets/icon.png',
                width: 110, // ✅ 크기 조정
                height: 50,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 20), // 로고와 닉네임 사이 여백

            // ✅ 닉네임 (왼쪽 정렬)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                "$_nickname의 서재", // ✅ 닉네임 적용
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 40), // 닉네임과 서재 박스 사이 여백

            // ✅ 중앙 서재 박스 (가운데 정렬)
            Expanded(
              child: Center(
                child: Container(
                  width: 280, // ✅ 서재 크기 조정
                  height: 350,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF8EC), // ✅ 배경 색상 부드럽게
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
                      // ✅ 상단 갈색 책장 바 (부드러운 갈색)
                      Container(
                        height: 16,
                        width: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCC6A0), // ✅ 연한 갈색
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(height: 50),

                      // ✅ 중앙 텍스트
                      const Text(
                        "앗,\n서재가 비었어요!\n동화책을 만들어볼까요?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ✅ "동화 만들기" 버튼 (둥글게 디자인)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/CreateStoryPage');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // ✅ 버튼 둥글게
                          ),
                        ),
                        child: const Text(
                          "동화 만들기",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),

                      const SizedBox(height: 50),

                      // ✅ 하단 갈색 책장 바 (부드러운 갈색)
                      Container(
                        height: 16,
                        width: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCC6A0), // ✅ 연한 갈색
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40), // 하단 여백 추가
          ],
        ),
      ),
    );
  }
}
