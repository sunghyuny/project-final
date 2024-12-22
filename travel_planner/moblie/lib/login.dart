import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences 클래스를 import
import 'services/api_service.dart'; // ApiService 클래스를 import
import 'dart:convert';
import 'package:http/http.dart' as http;

// 메인 함수 및 초기화
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

// 앱 구조 정의
class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 34, 104, 255),
        ),
        useMaterial3: true,
      ),
      initialRoute: isLoggedIn ? '/trip_plan' : '/flutter_login',
      routes: {
        '/flutter_login': (context) => LoginPage(),
        '/trip_plan': (context) => TripPlanPage(),
        '/signup': (context) => SignupPage(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => LoginPage(),
        );
      },
    );
  }
}
class LoginPage extends StatelessWidget {
  final ApiService apiService = ApiService(); // ApiService 클래스의 인스턴스를 생성
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTextField(emailController, 'Email'),
            _buildTextField(passwordController, 'Password', obscureText: true),
            ElevatedButton(
              onPressed: () async {
                await _handleLogin(context);
              },
              child: Text('로그인'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }

  // 텍스트 필드 생성 메서드
  Widget _buildTextField(TextEditingController controller, String label, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      obscureText: obscureText,
    );
  }

    // 로그인 처리 메서드
  Future<void> _handleLogin(BuildContext context) async {
    final email = emailController.text;
    final password = passwordController.text;

    try {
      await apiService.login(email, password);
      // 로그인 성공 시 사용자 정보 가져오기
      final userInfo = await apiService.fetchUserInfo();

      if (userInfo != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('username', userInfo['username']!);
        await prefs.setString('email', userInfo['email']!);
        Navigator.pushReplacementNamed(context, '/');
      } else {
        _showErrorDialog(context);
      }
    } catch (e) {
      _showErrorDialog(context);
      print('로그인 오류: $e');
    }
  }

  // 에러 다이얼로그 표시 메서드
  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('로그인 실패'),
        content: Text('이메일 또는 비밀번호가 잘못되었습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('확인'),
          ),
        ],
      ),
    );
  }
}

// 회원가입 페이지
class SignupPage extends StatelessWidget {
  final ApiService apiService = ApiService(); // ApiService 클래스의 인스턴스를 생성
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController mbtiController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(usernameController, 'Username'),
            _buildTextField(passwordController, 'Password', obscureText: true),
            _buildTextField(emailController, 'Email'),
            _buildTextField(ageController, 'Age'),
            _buildTextField(mbtiController, 'MBTI'),
            _buildTextField(genderController, 'Gender'),
            ElevatedButton(
              onPressed: () async {
                await _handleSignup(context);
              },
              child: Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }

  // 회원가입 처리 메서드
  Future<void> _handleSignup(BuildContext context) async {
    final username = usernameController.text;
    final password = passwordController.text;
    final email = emailController.text;
    final age = ageController.text;
    final mbti = mbtiController.text;
    final gender = genderController.text;

    await apiService.signup(username, password, email, age, mbti, gender);
    Navigator.pushReplacementNamed(context, '/flutter_login');
  }

  // 텍스트 필드 생성 메서드
  Widget _buildTextField(TextEditingController controller, String label, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      obscureText: obscureText,
    );
  }
}

// 여행 계획 페이지 (로그인 후 접근 가능)
class TripPlanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('여행 계획'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('여행 계획 페이지에 오신 것을 환영합니다!'),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);
                Navigator.pushReplacementNamed(context, '/flutter_login');
              },
              child: Text('로그아웃'),
            ),
          ],
        ),
      ),
    );
  }
}

