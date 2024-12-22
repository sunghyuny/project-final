import 'package:flutter/material.dart';
import 'location.dart'; // location.dart를 import
import 'Calendar.dart'; // calendar.dart를 import

void main() {
  runApp(const PeoplePage());
}

class PeoplePage extends StatelessWidget {
  const PeoplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const PersonCounterPage(),
    );
  }
}

class PersonCounterPage extends StatefulWidget {
  const PersonCounterPage({super.key});

  @override
  _PersonCounterPageState createState() => _PersonCounterPageState();
}

class _PersonCounterPageState extends State<PersonCounterPage> {
  int _adultCount = 1;
  int _teenCount = 0;
  int _childCount = 0;

  void _incrementAdultCount() {
    setState(() {
      _adultCount++;
    });
  }

  void _decrementAdultCount() {
    setState(() {
      if (_adultCount > 0) {
        _adultCount--;
      }
    });
  }

  void _incrementTeenCount() {
    setState(() {
      _teenCount++;
    });
  }

  void _decrementTeenCount() {
    setState(() {
      if (_teenCount > 0) {
        _teenCount--;
      }
    });
  }

  void _incrementChildCount() {
    setState(() {
      _childCount++;
    });
  }

  void _decrementChildCount() {
    setState(() {
      if (_childCount > 0) {
        _childCount--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white, // Scaffold의 배경색을 흰색으로 설정
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CalendarPage()),
            );
          },
        ),
        title: const Text(
          '인원 선택하기',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 15),
                      const Text(
                        '성인',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 5),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: _decrementAdultCount,
                        iconSize: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '$_adultCount',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _incrementAdultCount,
                        iconSize: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 8),
                      const Text(
                        '청소년',
                        style: TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: _decrementTeenCount,
                        iconSize: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '$_teenCount',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _incrementTeenCount,
                        iconSize: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 10),
                      const Text(
                        '아동',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: _decrementChildCount,
                        iconSize: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '$_childCount',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _incrementChildCount,
                        iconSize: 20,
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0), // 버튼과 하단 사이 여백 조정
            child: ElevatedButton(
              onPressed: () {
                if (_adultCount == 0 && _teenCount == 0 && _childCount == 0) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.white,
                      contentPadding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
                      content: const Text(
                        '인원을 선택해 주십시오.',
                        textAlign: TextAlign.center,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                              '확인',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const locationPage(),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(380, 50),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('선택 완료'),
            ),
          ),
        ],
      ),
    );
  }
}
