import 'package:flutter/material.dart';

class Intro2Page extends StatelessWidget {
  const Intro2Page({super.key});

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
                const Icon(Icons.circle, size: 10, color: Colors.orange),
                const SizedBox(width: 5),
                Icon(Icons.circle, size: 10, color: Colors.orange.withOpacity(0.5)),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "글을 읽는 것은 사실,\n무척 재미있어요",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "소설은 멋진 주인공이 되는 걸 상상하게 해주고,\n"
                  "신문 기사는 시대의 생각들을 알려주고,\n"
                  "편지는 상대방의 감정을 공감하게 해줘요.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 50),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/Intro3'); // Intro3 페이지로 이동
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
