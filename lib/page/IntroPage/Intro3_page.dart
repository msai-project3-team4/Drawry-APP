import 'package:flutter/material.dart';

class Intro3Page extends StatelessWidget {
  const Intro3Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCF0), // 배경색 설정
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50), // 상단 여백
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.circle, size: 10, color: Colors.orange.withOpacity(0.5)),
                const SizedBox(width: 5),
                Icon(Icons.circle, size: 10, color: Colors.orange.withOpacity(0.5)),
                const SizedBox(width: 5),
                const Icon(Icons.circle, size: 10, color: Colors.orange),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "나만의 그림,\n나만의 글,\n나만의 동화책!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "독해력이란 다른 모든 학습의 기초체력 같아요.\n"
                  "'드로우리' 앱을 이용하여 내가 상상한 그림을 그리고,\n"
                  "나의 그림과 어울리는 내용을 AI와 함께 만들어\n"
                  "나만의 동화책을 가져보아요!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 50),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/Select'); // 홈 화면으로 이동
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
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
            ),
          ],
        ),
      ),
    );
  }
}
