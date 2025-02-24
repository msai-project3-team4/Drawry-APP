import 'package:flutter/material.dart';

class Intro1Page extends StatelessWidget {
  const Intro1Page({super.key});

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
                const Icon(Icons.circle, size: 10, color: Colors.orange),
                const SizedBox(width: 5),
                Icon(Icons.circle, size: 10, color: Colors.orange.withOpacity(0.5)),
                const SizedBox(width: 5),
                Icon(Icons.circle, size: 10, color: Colors.orange.withOpacity(0.5)),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "독해력이란 무엇이며,\n왜 중요할까요?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "우리 아이 혹은 본인이 글을 읽어볼게 되었을때\n한번에 이해하기 어려운 상황을 겪고있나요?\n그렇다면 잘 찾아오셨어요!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 50),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Intro2 페이지로 이동 (추후 추가 예정)
                  Navigator.pushNamed(context, '/Intro2');
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
