import 'package:DrawryAPP/page/CreateStoryPage/ActionSelect_page.dart';
import 'package:DrawryAPP/page/CreateStoryPage/LocationSelect_page.dart';
import 'package:DrawryAPP/page/CreateStoryPage/Sketch.dart';
import 'package:DrawryAPP/page/CreateStoryPage/StoryPreview_page.dart';
import 'package:DrawryAPP/page/CreateStoryPage/TimeSelect_page.dart';
import 'package:DrawryAPP/page/Credit/Subscription_page.dart';
import 'package:DrawryAPP/page/HomePage/CreateStoryPage.dart';
import 'package:DrawryAPP/page/HomePage/LibraryPage.dart';
import 'package:DrawryAPP/page/IntroPage/Intro1_page.dart';
import 'package:DrawryAPP/page/IntroPage/Intro2_page.dart';
import 'package:DrawryAPP/page/IntroPage/Intro3_page.dart';
import 'package:DrawryAPP/page/LoginPage/Login_page.dart';
import 'package:DrawryAPP/page/RegisterPage/Birthday_Page.dart';
import 'package:DrawryAPP/page/RegisterPage/Nickname_Page.dart';
import 'package:DrawryAPP/page/RegisterPage/Summary_Page.dart';
import 'package:DrawryAPP/page/Select_page.dart';
import 'package:DrawryAPP/page/StorySelectPage/CharacterSelect_page.dart';
import 'package:DrawryAPP/page/StorySelectPage/StorySelect_page.dart';
import 'package:flutter/material.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";
import 'page/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env"); // ✅ 전체 경로 직접 입력
    print("✅ .env 파일 로드 성공!");
  } catch (e) {
    print("❌ .env 파일 로드 실패: $e");
  }


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "드로리",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const MainPage());
          case '/Intro1':
            return MaterialPageRoute(builder: (_) => const Intro1Page());
          case '/Intro2':
            return MaterialPageRoute(builder: (_) => const Intro2Page());
          case '/Intro3':
            return MaterialPageRoute(builder: (_) => const Intro3Page());
          case '/Select':
            return MaterialPageRoute(builder: (_) => const SelectPage());
          case '/Login':
            return MaterialPageRoute(builder: (_) => const LoginPage());
          case '/Nickname':
            return MaterialPageRoute(builder: (_) => const NicknamePage());
          case '/Library':
            return MaterialPageRoute(builder: (_) => const LibraryPage());
          case '/CreateStoryPage':
            return MaterialPageRoute(builder: (_) => const CreateStoryPage());
          case '/StorySelectPage':
            return MaterialPageRoute(builder: (_) => const StorySelectPage());
          case '/SubscriptionPage':
            return MaterialPageRoute(builder: (_) => const SubscriptionPage());
          case '/CharacterSelectPage':
            return MaterialPageRoute(builder: (_) => const CharacterSelectPage());
          case '/StoryPreviewPage':
            return MaterialPageRoute(builder: (_) => const StoryPreviewPage());
          case '/TimeSelectPage':
            return MaterialPageRoute(builder: (_) => const TimeSelectPage());
          case '/LocationSelectPage':
            return MaterialPageRoute(builder: (_) => const LocationSelectPage());
          case '/ActionSelectPage':
            return MaterialPageRoute(builder: (_) => const ActionSelectPage());
          case '/SketchPage':
            return MaterialPageRoute(builder: (_) => const SketchPage());
          case '/Birthday':
            final args = settings.arguments as Map<String, dynamic>?; // null 체크
            if (args == null || !args.containsKey('nickname')) {
              return MaterialPageRoute(
                builder: (_) => const Scaffold(
                  body: Center(child: Text("올바른 경로로 이동해주세요.")),
                ),
              );
            }
            return MaterialPageRoute(
              builder: (_) => BirthdayPage(nickname: args['nickname']),
            );
          case '/Summary':
            final args = settings.arguments as Map<String, dynamic>?; // null 체크
            if (args == null || !args.containsKey('nickname') || !args.containsKey('birthdate')) {
              return MaterialPageRoute(
                builder: (_) => const Scaffold(
                  body: Center(child: Text("올바른 경로로 이동해주세요.")),
                ),
              );
            }
            return MaterialPageRoute(
              builder: (_) => SummaryPage(
                nickname: args['nickname'],
                birthdate: args['birthdate'],
              ),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text("페이지를 찾을 수 없습니다.")),
              ),
            );
        }
      },
    );
  }
}
