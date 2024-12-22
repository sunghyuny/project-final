import 'package:flutter/material.dart';
import 'lodging.dart'; // lodging.dart import
import 'people.dart'; // people.dart import

void main() {
  runApp(const locationPage());
}

class locationPage extends StatelessWidget {
  const locationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Single Expansion List Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const LocationPage(),
    );
  }
}

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  int _currentIndex = -1; // 현재 확장된 리스트 인덱스
  Map<int, String?> _selectedItems = {}; // 각 리스트의 선택된 항목 저장

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // 뒤로가기 버튼을 누르면 people.dart로 이동
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PeoplePage()),
            );
          },
        ),
        title: const Text(
          '여행지 선택하기',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildExpansionTile('서울', 0, const [
            '잠실',
            '여의도',
            '명동',
            '인사동',
            '종로',
            '신촌',
          ]),
          _buildExpansionTile('경기도', 1, const [
            '용인시',
            '수원시',
            '부천시',
            '가평시',
            '광명시',
          ]),
          _buildExpansionTile('인천', 2, const [
            '남동구',
            '미추홀구',
            '연수구',
            '중구',
            '서구',
          ]),
          _buildExpansionTile('전라도', 3, const [
            '전주시',
            '목포시',
            '담양군',
            '순천시',
            '군산시',
          ]),
          _buildExpansionTile('경상도', 4, const [
            '부산',
            '경주',
            '포항',
            '대구',
            '안동',
          ]),
          _buildExpansionTile('충청도', 5, const [
            '단양',
            '청주',
            '충주',
            '보령',
            '태안',
          ]),
          _buildExpansionTile('강원도', 6, const [
            '속초시',
            '횡성군',
            '강릉시',
            '춘천시',
            '철원군',
          ]),
          _buildExpansionTile('제주도', 7, const [
            '제주시',
            '서귀포시',
          ]),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  // 확장 리스트를 빌드하는 함수
  Widget _buildExpansionTile(String title, int index, List<String> items) {
    return ExpansionTile(
      key: Key(index.toString()), // 고유 키를 부여
      title: Text(title),
      onExpansionChanged: (bool expanded) {
        setState(() {
          if (expanded) {
            _currentIndex = index; // 리스트가 열릴 때 현재 인덱스 저장
          } else if (_currentIndex == index) {
            _currentIndex = -1; // 현재 인덱스가 닫힐 때 상태 리셋
          }
        });
      },
      initiallyExpanded: _currentIndex == index, // 현재 인덱스와 일치하면 확장
      children: items.map((item) {
        bool isSelected = _selectedItems[_currentIndex] == item; // 현재 선택된 항목과 비교
        return ListTile(
          title: Text(
            item,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.blue : Colors.black,
            ),
          ),
          onTap: () {
            setState(() {
              _selectedItems[_currentIndex] = item; // 선택한 항목 저장
            });
            // 항목 선택 시 lodgingPage로 이동
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const lodgingpage(),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
