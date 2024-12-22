import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String selectedText = '';
  List<Map<String, String>> tripPlans = [
    // 샘플 데이터 추가
    {'destination': '제주도', 'period': '2024-11-28 ~ 2024-11-31', 'member': '친구들과'},
    {'destination': '부산', 'period': '2024-12-10 ~ 2024-12-15', 'member': '가족들과'},
  ];

  List<Map<String, String>> userPosts = [
    // 샘플 게시물 데이터 추가
    {'title': '겨울 제주 여행', 'date': '2024-11-28', 'image': 'assets/image/다운로드 (15).jpeg'},
    {'title': '부산 맛집 추천', 'date': '2024-12-16', 'image': ''},
  ];

  List<Map<String, String>> travelReservations = [
    // 샘플 예약 데이터 추가
    {
      'destination': '제주도 패키지',
      'start_date': '2024-11-20',
      'end_date': '2024-11-25',
      'total_price': '1,000,000',
      'image': 'assets/image/제주도전경.jpeg'
    },
    {
      'destination': '제주 호텔',
      'start_date': '2024-12-05',
      'end_date': '2024-12-07',
      'total_price': '300,000',
      'image': 'assets/image/289994367.jpg'
    },
  ];

  List<Map<String, String>> userChatRooms = [
    // 샘플 채팅방 데이터 추가
    {'name': '서울 여행 메이트', 'date': '2024-11-10', 'image': 'assets/chat_room1.png'},
    {'name': '부산 맛집 탐방', 'date': '2024-12-20', 'image': 'assets/chat_room2.png'},
  ];

  Map<String, String> userInfo = {
    'name': '이승혁',
    'mbti': 'estp',
    'email': 'SH@naver.com',
    'phone': '010-1234-5678',
    'birthdate': '2003-11-09',
    'gender': '남성',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          '마이페이지',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/image/KakaoTalk_20241125_142422375.jpg'), // 사용자 프로필 이미지
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userInfo['name'] ?? '',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      userInfo['id'] ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('개인정보'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('이름: ${userInfo['name']}'),
                              SizedBox(height: 8),                              
                              Text('이메일: ${userInfo['email']}'),
                              SizedBox(height: 8),
                              Text('전화번호: ${userInfo['phone']}'),
                              SizedBox(height: 8),
                              Text('생년월일: ${userInfo['birthdate']}'),
                              SizedBox(height: 8),
                              Text('성별: ${userInfo['gender']}'),
                              Text('mbti: ${userInfo['mbti']}'),
                              SizedBox(height: 8),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('닫기'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('개인정보 보기'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(), // 구분선 추가
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedText = '내 계획';
                      });
                    },
                    child: Text(
                      '내 계획',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: selectedText == '내 계획' ? Colors.purple : Colors.black,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedText = '내 게시물';
                      });
                    },
                    child: Text(
                      '내 게시물',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: selectedText == '내 게시물' ? Colors.purple : Colors.black,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedText = '예약';
                      });
                    },
                    child: Text(
                      '예약',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: selectedText == '예약' ? Colors.purple : Colors.black,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedText = '참여 채팅방';
                      });
                    },
                    child: Text(
                      '참여 채팅방',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: selectedText == '참여 채팅방' ? Colors.purple : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (selectedText == '개인정보')
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      title: Text('이름'),
                      subtitle: Text(userInfo['name'] ?? ''),
                    ),
                    ListTile(
                      title: Text('이메일'),
                      subtitle: Text(userInfo['email'] ?? ''),
                    ),
                    ListTile(
                      title: Text('전화번호'),
                      subtitle: Text(userInfo['phone'] ?? ''),
                    ),
                    ListTile(
                      title: Text('생년월일'),
                      subtitle: Text(userInfo['birthdate'] ?? ''),
                    ),
                    ListTile(
                      title: Text('성별'),
                      subtitle: Text(userInfo['gender'] ?? ''),
                    ),
                    ListTile(
                      title: Text('MBTI'),
                      subtitle: Text(userInfo['mbti'] ?? ''),
                    ),
                  ],
                ),
              ),
            if (selectedText == '내 계획')
              Expanded(
                child: ListView.builder(
                  itemCount: tripPlans.length,
                  itemBuilder: (context, index) {
                    final plan = tripPlans[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plan['destination'] ?? '',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text('기간: ${plan['period']}'),
                            SizedBox(height: 4),
                            Text('참여자: ${plan['member']}'),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    // 상세 정보 보기 동작 추가
                                  },
                                  child: Text('상세정보'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // 삭제 버튼 동작 추가
                                    setState(() {
                                      tripPlans.removeAt(index);
                                    });
                                  },
                                  child: Text(
                                    '삭제',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (selectedText == '내 게시물')
              Expanded(
                child: userPosts.isEmpty
                    ? Center(
                        child: Text('작성한 게시글이 없습니다.'),
                      )
                    : ListView.builder(
                        itemCount: userPosts.length,
                        itemBuilder: (context, index) {
                          final post = userPosts[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  if (post['image'] != null && post['image']!.isNotEmpty)
                                    Image.asset(
                                      post['image']!,
                                      width: 200,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          post['title'] ?? '',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text('작성일: ${post['date']}'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            if (selectedText == '예약')
              Expanded(
                child: travelReservations.isEmpty
                    ? Center(
                        child: Text('예약된 항목이 없습니다.'),
                      )
                    : ListView.builder(
                        itemCount: travelReservations.length,
                        itemBuilder: (context, index) {
                          final reservation = travelReservations[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    reservation['image']!,
                                    width: 200,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          reservation['destination'] ?? '',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text('기간: ${reservation['start_date']} - ${reservation['end_date']}'),
                                        SizedBox(height: 4),
                                        Text('총 가격: ${reservation['total_price']}원'),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          // 예약 상세 정보 보기 동작 추가
                                        },
                                        child: Text('상세정보'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // 예약 삭제 버튼 동작 추가
                                          setState(() {
                                            travelReservations.removeAt(index);
                                          });
                                        },
                                        child: Text(
                                          '삭제',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            if (selectedText == '참여 채팅방')
              Expanded(
                child: userChatRooms.isEmpty
                    ? Center(
                        child: Text('참여된 채팅방이 없습니다.'),
                      )
                    : ListView.builder(
                        itemCount: userChatRooms.length,
                        itemBuilder: (context, index) {
                          final room = userChatRooms[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    room['image']!,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          room['name'] ?? '',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text('참여일: ${room['date']}'),
                                      ],
                                    ),
                                  ),
                                  if (true) // 채팅방 삭제 조건 추가 예정
                                    TextButton(
                                      onPressed: () {
                                        // 채팅방 삭제 동작 추가
                                        setState(() {
                                          userChatRooms.removeAt(index);
                                        });
                                      },
                                      child: Text(
                                        '삭제',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(
      MaterialApp(
        title: 'My Page',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 34, 104, 255), // seedColor 설정
          ),
          useMaterial3: true,
        ),
        home: MyPage(),
      ),
    );
