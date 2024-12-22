import 'package:flutter/material.dart';
import 'sight_main.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 34, 104, 255),
      ),
      useMaterial3: true,
    ),
    home: TouristDetailPage(),
  ));
}


class TouristDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context); // TouristMainPage로 돌아감
          },
        ),

        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            _buildImageSection(),
            _buildTitleSection(),
            _buildTitleSection2(),
            Divider(),
            _buildDetailInfoSection(),
            Divider(),
            _buildCategorySection(),
            Divider(),
            _buildRecommendedPlacesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.asset(
              'assets/image/성산일출봉1.jpeg',
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10),
          Column(
            children: [
              Row(
                children: [
                  _buildSubImage('assets/image/성산일출봉2.jpeg', width: 150, height: 100),
                  SizedBox(width: 10),
                  _buildSubImage('assets/image/성산일출봉3.jpg', width: 150, height: 100),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  _buildSubImage('assets/image/성산일출봉4.jpg', width: 150, height: 100),
                  SizedBox(width: 10),
                  _buildSubImage('assets/image/성산일출봉5.jpg', width: 150, height: 100),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        '성산일출봉',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTitleSection2() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        '제주 서귀포시 성산읍 성산리 1',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSubImage(String path, {double width = 190, double height = 190}) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }

  Widget _buildDetailInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '상세 정보',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            '마그마나 용암이 다량의 얕은 수심의 차가운 바닷물과 섞여서 급히 냉각되고 물이 가열되어 끓으면서 분출 초기부터 격렬한 폭발을 일으키게 된다. 이때의 폭발로 마그마가 유리질 화산재와 화산력(火山礫)[2]으로 산산이 깨졌으며, 습기를 머금어 끈끈한 화산재는 뭉치거나 화산력 표면에 수 mm 두께로 달라붙어 피복화산력(부가화산력)을 만들었다.',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 8.0,
        children: [
          _buildCategoryChip('#가족여행'),
          _buildCategoryChip('#힐링'),
          _buildCategoryChip('#나들이'),
          _buildCategoryChip('#오색코스'),
          _buildCategoryChip('#등산'),
          _buildCategoryChip('#등산코스'),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(color: Colors.blue), // 글자 색상 파란색
      ),
      shape: StadiumBorder(
        side: BorderSide(
          color: Colors.blue, // 테두리 색상 파란색
          width: 1.0,
        ),
      ),
      backgroundColor: Colors.white, // 배경색 흰색
    );
  }

  Widget _buildRecommendedPlacesSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '비슷한 장소 추천',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildRecommendedPlaceCard('assets/image/우도.jpeg', '우도'),
                SizedBox(width: 10),
                _buildRecommendedPlaceCard('assets/image/한라산.jpeg', '한라산 국립공원'),
                SizedBox(width: 10),
                _buildRecommendedPlaceCard('assets/image/섭지코지.jpeg', '섭지코지'),
                SizedBox(width: 10),
                _buildRecommendedPlaceCard('assets/image/1600843915748.jpg', '주상절리대'),
                SizedBox(width: 10),
                _buildRecommendedPlaceCard('assets/image/만장굴.jpeg', '만장굴'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedPlaceCard(String imagePath, String placeName) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            imagePath,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 5),
        Text(
          placeName,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
