import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SketchPage extends StatefulWidget {
  const SketchPage({super.key});

  @override
  _SketchPageState createState() => _SketchPageState();
}

class _SketchPageState extends State<SketchPage> {
  final storage = const FlutterSecureStorage();
  List<Offset?> _points = []; // 그림을 저장할 리스트
  bool _isEraserMode = false; // 지우개 모드 여부
  String selectedTime = "";
  String selectedLocation = "";
  String selectedAction = "";

  @override
  void initState() {
    super.initState();
    _fetchStoryDetails(); // ✅ 저장된 데이터 불러오기
  }

  // ✅ 저장된 데이터 불러오기 (시간, 장소, 행동)
  Future<void> _fetchStoryDetails() async {
    String? nickname = await storage.read(key: "nickname");
    if (nickname == null) return;

    String apiUrl = "http://52.141.26.75:8000/library/library/$nickname/story-progress";
    print("📌 저장된 데이터 조회 API 호출: $apiUrl");

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Accept": "application/json"},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes)); // ✅ UTF-8 디코딩 추가

        setState(() {
          selectedTime = responseData["selected_time"] ?? "시간 미정";
          selectedLocation = responseData["selected_location"] ?? "장소 미정";
          selectedAction = responseData["selected_action"] ?? "행동 미정";
        });

        print("✅ 저장된 데이터: $selectedTime / $selectedLocation / $selectedAction");
      } else {
        print("❌ 데이터 조회 실패: ${response.statusCode} / 응답: ${response.body}");
      }
    } catch (e) {
      print("❌ 오류 발생: $e");
    }
  }

  void _clearCanvas() {
    setState(() {
      _points.clear(); // 전체 지우기
    });
  }

  void _toggleEraser() {
    setState(() {
      _isEraserMode = !_isEraserMode;
    });
    print(_isEraserMode ? "🧽 지우개 모드" : "🖌️ 펜 모드");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCF0),

      body: SafeArea(
        child: Column(
          children: [
            // ✅ 상단 텍스트 + "그림 만들기" 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "전신을 포함한 주인공이 $selectedTime에 $selectedLocation에서\n$selectedAction 시작할 장면을 그려줘",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print("🖌️ 그림 생성 요청");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: const Text(
                      "그림 만들기",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // ✅ 스케치 캔버스 (터치 위치 보정)
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange, width: 3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          // ✅ localPosition 사용 (터치 위치 보정)
                          _points.add(details.localPosition);
                        });
                      },
                      onPanEnd: (details) {
                        _points.add(null); // 선이 끊기는 지점 추가
                      },
                      child: CustomPaint(
                        painter: SketchPainter(_points, _isEraserMode),
                        size: Size.infinite,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // ✅ 하단 툴바 (색상 선택, 펜, 지우기)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange, width: 3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.palette, color: Colors.orange, size: 30),
                    onPressed: () {
                      print("🎨 색상 선택 (추후 추가 가능)");
                    },
                  ),
                  IconButton(
                    icon: Icon(_isEraserMode ? Icons.brush : Icons.cleaning_services, color: Colors.orange, size: 30),
                    onPressed: _toggleEraser, // 지우개 모드 토글
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.orange, size: 30),
                    onPressed: _clearCanvas, // 전체 지우기
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ✅ CustomPainter로 스케치 구현
class SketchPainter extends CustomPainter {
  final List<Offset?> points;
  final bool isEraserMode;

  SketchPainter(this.points, this.isEraserMode);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = isEraserMode ? Colors.white : Colors.black
      ..strokeWidth = isEraserMode ? 20.0 : 5.0
      ..strokeCap = StrokeCap.round
      ..blendMode = isEraserMode ? BlendMode.clear : BlendMode.srcOver;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
