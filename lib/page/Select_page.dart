import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class SelectPage extends StatefulWidget {
  const SelectPage({super.key});

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  String? kakaoNickname; // ✅ 카카오 로그인 후 가져올 닉네임 저장 변수

  // 📌 카카오 로그인 처리
  Future<void> _loginWithKakao(BuildContext context) async {
    try {
      if (await isKakaoTalkInstalled()) {
        await UserApi.instance.loginWithKakaoTalk();
      } else {
        await UserApi.instance.loginWithKakaoAccount();
      }

      // ✅ 사용자 정보 가져오기
      User user = await UserApi.instance.me();
      String? fetchedNickname = user.kakaoAccount?.profile?.nickname;

      setState(() {
        kakaoNickname = fetchedNickname ?? "사용자"; // 닉네임이 없으면 기본값 설정
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$kakaoNickname님, 카카오 로그인 성공!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('카카오 로그인 실패: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCF0), // 배경색 설정
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/LOGO.png', // 로고 이미지
              width: 200,
            ),
            const SizedBox(height: 20),
            const Text(
              "나만의 동화로 기르는 독해력",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60), // 간격 추가
            SizedBox(
              width: 250, // 버튼 크기 고정
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/Nickname'); // 회원가입 페이지 이동
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "회원가입",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15), // 버튼 간격
            SizedBox(
              width: 250, // 버튼 크기 동일하게 고정
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/Login'); // 로그인 페이지 이동
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "로그인",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15), // 버튼 간격
            SizedBox(
              width: 250, // 버튼 크기 동일하게 고정
              child: ElevatedButton(
                onPressed: () => _loginWithKakao(context), // 카카오 로그인 실행
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFEE500), // 카카오 색상
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/kakao_logo.png', width: 24), // 카카오 로고 추가
                    const SizedBox(width: 10),
                    const Text(
                      "카카오 로그인",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // 카카오 버튼의 공식 색상
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),

            // ✅ "확인하고 계속하기" 버튼 추가 (카카오 로그인 후 표시)
            if (kakaoNickname != null)
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    if (kakaoNickname == "사용자") {
                      // 닉네임이 없으면 닉네임 입력 페이지로 이동
                      Navigator.pushNamed(
                        context,
                        '/Nickname',
                      );
                    } else {
                      // 닉네임이 있으면 생년월일 입력 페이지로 이동
                      Navigator.pushNamed(
                        context,
                        '/Birthday',
                        arguments: {'nickname': kakaoNickname},
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "확인하고 계속하기",
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
