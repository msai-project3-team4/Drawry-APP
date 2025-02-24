import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final storage = const FlutterSecureStorage();
  String _nickname = ""; // 닉네임 저장
  final String _bankName = "농협은행"; // 고정된 은행 이름
  final String _accountNumber = "352-0563-1690-23"; // 고정된 계좌번호
  final String _accountHolder = "남두현"; // 고정된 예금주

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

  // ✅ 결제 처리 함수
  void _processPayment() {
    String name = _nameController.text.trim();
    String phone = _phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("모든 정보를 입력해주세요."), backgroundColor: Colors.red),
      );
      return;
    }

    // ✅ 결제 정보 출력 (실제 결제 API 연동 가능)
    print("💳 결제 정보:");
    print("닉네임: $_nickname");
    print("이름: $name");
    print("전화번호: $phone");
    print("은행: $_bankName");
    print("계좌번호: $_accountNumber");
    print("예금주: $_accountHolder");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("결제가 완료되었습니다!"), backgroundColor: Colors.green),
    );

    // ✅ 구독 완료 후 홈 화면으로 이동
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCF0), // 배경 색상

      body: SafeArea(
        child: SingleChildScrollView( // ✅ 스크롤 가능하게 수정 (오버플로우 방지)
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ 상단 앱 로고
              Image.asset(
                'assets/icon.png',
                width: 100,
                height: 40,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 30),

              // ✅ 닉네임 표시
              Text(
                "$_nickname 님,\n구독을 시작하시겠습니까?",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // ✅ 사용자 정보 입력 필드
              _buildInputField("성함", _nameController, TextInputType.text),
              const SizedBox(height: 15),
              _buildInputField("전화번호", _phoneController, TextInputType.phone),

              const SizedBox(height: 25),

              // ✅ 계좌 이체 정보
              const Text(
                "계좌 이체 정보",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              // ✅ 은행 (고정 값)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _bankName, // 고정된 은행명
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 15),

              // ✅ 계좌번호 (고정 값)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _accountNumber, // 고정된 계좌번호
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 15),

              // ✅ 예금주 (고정 값)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "예금주: $_accountHolder", // 고정된 예금주
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 30),

              // ✅ 결제하기 버튼
              Center(
                child: ElevatedButton(
                  onPressed: _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 14),
                  ),
                  child: const Text(
                    "결제하기",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ 입력 필드 위젯
  Widget _buildInputField(String label, TextEditingController controller, TextInputType keyboardType) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
