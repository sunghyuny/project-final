import 'package:flutter/material.dart';
import 'dart:async';
import 'detali.dart';
// import 'MB_detail.dart';

class TouristMainPage extends StatefulWidget {
  @override
  _TouristMainPageState createState() => _TouristMainPageState();
}

class _TouristMainPageState extends State<TouristMainPage> {
  final List<String> sliderImages = [
    'assets/image/다운로드 (14).jpeg',
    'assets/image/다운로드 (19).jpeg',
    'assets/image/다운로드 (21).jpeg',
    'assets/image/AA8032_I_01.jpg',
  ];

  final List<String> popularRegions = [
    '서울', '부산', '제주', '경주'
  ];

  final List<Map<String, String>> recommendedContents = [
    {'image': 'assets/image/한강공원.jpeg', 'title': '한강공원'},
    {'image': 'assets/image/광안리.jpeg', 'title': '광안리 해수용장'},
    {'image': 'assets/image/IMG_3684.jpg', 'title': '성산일출봉'},
    {'image': 'assets/image/불국사.jpeg', 'title': '불국사'},
  ];

  final PageController _pageController = PageController();
  Timer? _sliderTimer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _sliderTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        int nextPage = _pageController.page!.round() + 1;
        if (nextPage >= sliderImages.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _sliderTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
            '관광지',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이미지 슬라이더
              SizedBox(
                height: 200.0,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: sliderImages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(sliderImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10.0),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(sliderImages.length, (index) {
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double selected = _pageController.page == null ? 0 : _pageController.page!;
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          width: (selected.round() == index) ? 12.0 : 8.0,
                          height: 8.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (selected.round() == index) ? Colors.blue : Colors.grey,
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),

              SizedBox(height: 20.0),

              // 인기 지역
              Text(
                '인기 지역',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: popularRegions.map((region) {
                  return Chip(
                    label: Text(region),
                    backgroundColor: Colors.white,
                  );
                }).toList(),
              ),

              SizedBox(height: 20.0),

              // 추천
              Text(
                '추천',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Divider(),
              SizedBox(height: 10.0),
              Column(
                children: recommendedContents.map((content) {
                  return Card(
                    elevation: 3,
                    color: Colors.white, // 배경색을 흰색으로 설정
                    child: ListTile(
                      leading: Image.asset(
                        content['image']!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      title: Text(content['title']!),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TouristDetailPage()),
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    theme: ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 34, 104, 255),
      ),
    ),
    home: TouristMainPage(),
  ));
}
