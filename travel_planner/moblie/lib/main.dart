import 'dart:async';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:intl/intl.dart';
import 'services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'planner/Calendar.dart';
import 'sight/sight_main.dart';
import 'community/community.dart';
import 'Mypage/mypage_main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진 초기화
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false; // 로그인 상태 확인

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

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
      initialRoute: '/', // 초기 라우트 설정
      routes: {
        '/': (context) => MyHomePage(title: 'Travel Plan'), // 메인 페이지
        '/login': (context) => LoginPage(), // 로그인 페이지
        '/trip_plan': (context) => CalendarPage(), // 여행 계획 페이지 추가
        '/sight_main' : (context) => TouristMainPage(),
        '/community' : (context) => PostListPage(),
        '/mypage': (context) => MyPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;
  String userName = 'guest';
  String userEmail = '';
  Future<Map<String, dynamic>>? mainPageData;

   final List<Map<String, String>> reviewDataNow = [
    {
      'location': '여수',
      'title': '낭만적인 여수 밤바다',
      'userName': '오연주님의 여행',
      'imagePath': 'assets/image/e4e76e16-ba3e-4ce6-8f97-d78d840bbc50.jpg',
      'date': '2024-06-15',
    },
    {
      'location': '서울',
      'title': '화려한 서울의 야경',
      'userName': '김철수님의 여행',
      'imagePath': 'assets/image/2023102309222011344_1698020541_0019874275.jpg',
      'date': '2024-06-18',
    },
    {
      'location': '부산',
      'title': '부산 해운대에서의 하루',
      'userName': '이영희님의 여행',
      'imagePath': 'assets/image/20191229160530047_oen.jpeg',
      'date': '2024-06-20',
    },
  ];

  // "커뮤니티" 더미 데이터
  final List<Map<String, String>> reviewDataCommunity = [
    {
      'location': '제주도',
      'title': '제주도의 푸른 바다',
      'date': '2024-05-15',
      'userName': '박지수',
      'imagePath': 'assets/image/다운로드 (6).jpeg',
    },
    {
      'location': '강릉',
      'title': '강릉 바다와 커피 한 잔',
      'date': '2024-07-30',
      'userName': '최현우',
      'imagePath': 'assets/image/11772BB7-D64A-4864-A05A-A93C060C3D6D.jpeg',
    },
    {
      'location': '전주',
      'title': '전주 한옥마을에서의 하루',
      'date': '2024-08-05',
      'userName': '신미라',
      'imagePath': 'assets/image/08847ebd8a96fe9c3969155049ce06c9.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserInfo(); // 사용자 정보 로드
    mainPageData = ApiService().mainpage(); // 메인 페이지 데이터를 불러옵니다.

    _timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      if (_currentPage < 3) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('username') ?? 'guest';
      userEmail = prefs.getString('email') ?? '';
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              child: Container(
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/profile.jpg'),
                    ),
                    SizedBox(height: 16),
                    Text(
                      userName, // 로그인한 사용자의 이름 표시
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      userEmail, // 로그인한 사용자의 이메일 표시
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('여행'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('여행계획'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/trip_plan');
              },
            ),
            ListTile(
              leading: const Icon(Icons.place),
              title: const Text('관광지'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/sight_main');
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('커뮤니티'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/community');
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('매칭'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('마이페이지'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: FutureBuilder<bool>(
                future: ApiService().isLoggedIn(), // 로그인 상태 확인
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Icon(Icons.login); // 기본 아이콘은 로그인 아이콘
                  } else {
                    bool loggedIn = snapshot.data ?? false;
                    return Icon(loggedIn ? Icons.logout : Icons.login);
                  }
                },
              ),
              title: FutureBuilder<bool>(
                future: ApiService().isLoggedIn(), // 로그인 상태 확인
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('로그인/회원가입'); // 기본 텍스트는 로그인/회원가입
                  } else {
                    bool loggedIn = snapshot.data ?? false;
                    return Text(loggedIn ? '로그아웃' : '로그인/회원가입');
                  }
                },
              ),
              onTap: () async {
                bool loggedIn = await ApiService().isLoggedIn();
                if (loggedIn) {
                  await ApiService().logout(); // 로그아웃 메서드 호출
                  setState(() {}); // 로그아웃 후 UI 업데이트
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage(title: 'Travel Plan')),
                  );
                } else {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: mainPageData == null
    ? const Center(child: CircularProgressIndicator())
    : FutureBuilder<Map<String, dynamic>>(
        future: mainPageData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('메인 페이지 데이터를 불러오는 데 실패했습니다: \${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('메인 페이지 데이터를 불러올 수 없습니다.'));
          } else {
            final data = snapshot.data!;
            if (data.containsKey('accommodations')) {
              final accommodations = (data['accommodations'] as List)
                  .map((json) => Accommodation.fromJson(json))
                  .toList();

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 지금 가면 좋은 곳 Section
                    SizedBox(
                      height: 180,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          switch (index) {
                            case 0:
                              return Image.asset(
                                'assets/image/0c0c0ffc-ffca-4fad-91a8-edfa3d125067.webp',
                                fit: BoxFit.cover,
                              );
                            case 1:
                              return Image.asset(
                                'assets/image/88dec60e-8cd1-42cc-b7d8-34b67f7d923c.jpg',
                                fit: BoxFit.cover,
                              );
                            case 2:
                              return Image.asset(
                                'assets/image/32aca3fe-9499-4d7f-8df1-2b70c839c8c3.jpg',
                                fit: BoxFit.cover,
                              );
                            default:
                              return Container();
                          }
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Text(
                        '지금 가면 좋은 곳',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(thickness: 1, color: Colors.grey),
                    Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox(
                height: 180,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: reviewDataNow.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final data = reviewDataNow[index];
                    return ReviewCard(
                      location: data['location']!,
                      title: data['title']!,
                      userName: data['userName']!,
                      imagePath: data['imagePath']!,
                      date: data['date']!,
                    );
                  },
                ),
              ),
            ),

                    // 커뮤니티 Section
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Text(
                        '커뮤니티',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(thickness: 1, color: Colors.grey),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: SizedBox(
                        height: 180,
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: reviewDataCommunity.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final data = reviewDataCommunity[index];
                            return ReviewCard(
                              location: data['location']!,
                              title: data['title']!,
                              userName: data['userName']!,
                              imagePath: data['imagePath']!,
                              date: data['date']!,
                            );
                          }
                        ),
                      ),
                    ),

                    // 지금 가면 좋은 숙소 Section
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Text(
                        '지금 가면 좋은 숙소',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(thickness: 1, color: Colors.grey),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: accommodations.length,
                      itemBuilder: (context, index) {
                        final accommodation = accommodations[index];
                        return ReviewCard(
                          accommodation: accommodation,
                        );
                      }
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('추천할 숙소가 없습니다.'));
            }
          }
        },
      ),
    );
  }
}
class ReviewCard extends StatelessWidget {
  final String? location;
  final String? title;
  final String? userName;
  final String? imagePath;
  final String? date;
  final Accommodation? accommodation;

  ReviewCard({
    Key? key,
    this.location,
    this.title,
    this.userName,
    this.imagePath,
    this.date,
    this.accommodation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (accommodation != null) {
      // 숙소 데이터를 이용한 카드 생성
      return Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(21),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(21),
                topRight: Radius.circular(21),
              ),
              child: Image.network(
                accommodation!.photo, // 숙소 이미지 URL
                width: double.infinity,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Color(0xFF2295FF), size: 16),
                      SizedBox(width: 4),
                      Text(
                        accommodation!.name,
                        style: TextStyle(
                          color: Color(0xFF2295FF),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${accommodation!.price} 원',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      // 로컬 데이터를 이용한 카드 생성
      return Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(21),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(21),
                topRight: Radius.circular(21),
              ),
              child: Image.asset(
                imagePath!,
                width: double.infinity,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Color(0xFF2295FF), size: 16),
                      SizedBox(width: 4),
                      Text(
                        location!,
                        style: TextStyle(
                          color: Color(0xFF2295FF),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    title!,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    userName!,
                    style: TextStyle(
                      color: Color(0xFF949494),
                      fontSize: 8,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    date!,
                    style: TextStyle(
                      color: Color(0xFF949494),
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
