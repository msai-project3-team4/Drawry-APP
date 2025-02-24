import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCF0), // 배경색 설정
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/LOGO.png', // 로고 이미지
              width: 200,
            ),
          ),
          const SizedBox(height: 50), // 간격 추가
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/Intro1'); // 버튼 클릭 시 Intro1 페이지 이동
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange, // 버튼 색상
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // 둥근 모서리
              ),
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 14),
            ),
            child: const Text(
              "다음",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
