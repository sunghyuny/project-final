  import 'dart:convert';
  import 'package:http/http.dart' as http;
  import 'package:shared_preferences/shared_preferences.dart';

  class ApiService {


  Uri _buildUri(String path) {
    return Uri(
      scheme: 'http',
      host: '25.17.18.230',
      port: 8000,
      path: path,
    );
  }


  Map<String, String> _getHeaders(String? sessionId, String? csrfToken) {
    return {
      'Content-Type': 'application/json',
      if (csrfToken != null) 'X-CSRFToken': csrfToken,
      if (sessionId != null) 'Cookie': 'sessionid=$sessionId; csrftoken=$csrfToken',
      ...headers,
    };
  }

  Map<String, String> _getCommonHeaders() {
    return {
      'Content-Type': 'application/json',
      ...headers,
    };
  }
    final String baseUrl = 'http://25.17.18.230:8000'; // Django API URL로 대체
    final http.Client client = http.Client(); // 세션 유지를 위한 http.Client
    Map<String, String> headers = {}; // 세션 쿠키를 저장할 헤더

    Future<String> getCsrfToken() async {
      final response = await client.get(Uri.parse('$baseUrl/api/csrf_token/'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        headers['X-CSRFToken'] = data['csrfToken'];
        return data['csrfToken'];
      } else {
        throw Exception('CSRF 토큰을 가져오는 데 실패했습니다.');
      }
    }



    Future<Map<String, String>?> fetchUserInfo() async {
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('sessionid');
      final csrfToken = prefs.getString('csrftoken');

      if (sessionId == null) {
        print('세션 쿠키가 없습니다. 로그인이 필요합니다.');
        throw Exception('세션 쿠키가 없습니다.');
      }

      try {
        final response = await client.get(
          Uri.parse('$baseUrl/api/get_user_info/'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Cookie': 'sessionid=$sessionId; csrftoken=$csrfToken', // 세션 쿠키와 CSRF 토큰 추가
            if (csrfToken != null) 'X-CSRFToken': csrfToken, // CSRF 토큰 추가 (필요한 경우)
          },
        );

        print('get_user_info 응답 상태 코드: ${response.statusCode}');
        print('get_user_info 응답 본문: ${response.body}');

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          if (responseData is Map<String, dynamic>) {
            return {
              'username': responseData['username'] ?? '',
              'email': responseData['email'] ?? ''
            };
          } else {
            return null;
          }
        } else {
          print('유저 정보 불러오기 실패: ${response.statusCode}');
          return null;
        }
      } catch (e) {
        print('fetchUserInfo 오류: $e');
        return null;
      }
    }
    Future<Map<String, dynamic>?> UserInfo(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/user_info/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token', // 인증 토큰 추가
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to load user info. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('An error occurred: $e');
      return null;
    }
  }
    Future<Map<String, dynamic>> mainpage() async {
      print('메인 페이지 정보 요청 시작');
      
      // API 요청 보내기
      final response = await client.get(Uri.parse('$baseUrl/api/'), headers: headers);
      
      print('메인 페이지 응답 상태 코드: ${response.statusCode}');
      print('메인 페이지 응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        try {
          // 전체 데이터를 JSON으로 파싱
          final data = json.decode(response.body) as Map<String, dynamic>;

          print('메인 페이지 데이터 파싱 성공');
          return data;  // 숙소 정보뿐만 아니라 다른 데이터도 포함된 전체 응답 반환
        } catch (e) {
          print('메인 페이지 데이터 파싱 실패: $e');
          throw Exception('메인 페이지 데이터 파싱 중 오류가 발생했습니다.');
        }
      } else {
        print('메인 페이지를 로드하는 데 실패했습니다: 상태 코드 ${response.statusCode}, 응답: ${response.body}');
        throw Exception('메인 페이지를 로드하는 데 실패했습니다');
      }
    }

    Future<void> signup(String username, String password, String email, String age, String mbti, String gender) async {
      await getCsrfToken();
      final response = await client.post(
        Uri.parse('$baseUrl/api/flutter_signup/'),
        headers: {
          'Content-Type': 'application/json',
          ...headers,
        },
        body: json.encode({
          'username': username,
          'password': password,
          'email': email,
          'age': age,
          'mbti': mbti,
          'gender': gender,
        }),
      );

      if (response.statusCode == 200) {
        // 회원가입 성공
      } else {
        // 오류 처리
      }
    }

    Future<void> logout() async {
      try {
        final response = await client.post(
          Uri.parse('$baseUrl/api/flutter_logout/'),
          headers: {
            'Content-Type': 'application/json',
            'X-CSRFToken': headers['X-CSRFToken'] ?? '',
            'Cookie': headers['Cookie'] ?? '',
            ...headers,
          },
        );

        if (response.statusCode == 200) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', false); // 로그인 상태 false로 업데이트
          await prefs.remove('username');
          await prefs.remove('email');
          print('로그아웃 성공');
        } else {
          throw Exception('로그아웃 실패');
        }
      } catch (e) {
        print('로그아웃 처리 실패: $e');
        throw Exception('로그아웃 처리 실패: $e');
      }
    }

    Future<void> login(String email, String password) async {
      await getCsrfToken(); // CSRF 토큰 먼저 가져오기

      final response = await client.post(
        Uri.parse('$baseUrl/api/flutter_login/'),
        headers: {
          'Content-Type': 'application/json',
          ...headers,
        },
        body: json.encode({'email': email, 'password': password}),
      );

      // 응답 상태 코드와 응답 헤더 출력
      print('로그인 응답 상태 코드: ${response.statusCode}');
      print('로그인 응답 헤더: ${response.headers}');

      if (response.statusCode == 200) {
        // 응답 본문 로그로 확인
        print('로그인 성공 응답 본문: ${response.body}');

        try {
          final responseData = json.decode(response.body);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true); // 로그인 상태 저장

          // 세션 쿠키 저장
          final cookies = response.headers['set-cookie'];
          if (cookies != null) {
            final sessionMatch = RegExp(r'sessionid=([^;]+)').firstMatch(cookies);
            final csrfMatch = RegExp(r'csrftoken=([^;]+)').firstMatch(cookies);

            if (sessionMatch != null) {
              await prefs.setString('sessionid', sessionMatch.group(1)!); // sessionid 저장
            }

            if (csrfMatch != null) {
              await prefs.setString('csrftoken', csrfMatch.group(1)!); // CSRF 토큰 저장
            }

            print('Session Cookie: $cookies'); // 쿠키 출력
          }
        } catch (e) {
          print('JSON 파싱 오류: $e');
          throw Exception('로그인 응답 파싱 중 오류 발생');
        }
      } else {
        print('로그인 실패 응답 코드: ${response.statusCode}');
        print('로그인 실패 응답 본문: ${response.body}');
        throw Exception('로그인 실패: ${response.statusCode}');
      }
    }

    Future<bool> isLoggedIn() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('isLoggedIn') ?? false;
    }

    Future<String> getUserName() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('username') ?? '사용자';
    }

    Future<void> setTripDates(String arrivalDate, String departureDate, int totalPeople) async {
      if (!await isLoggedIn()) {
        throw Exception('로그인이 필요합니다.');
      }

      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('sessionid');
      final csrfToken = prefs.getString('csrftoken');

      if (sessionId == null || csrfToken == null) {
        throw Exception('세션 정보나 CSRF 토큰이 없습니다. 로그인을 다시 시도하십시오.');
      }

      // 디버깅을 위해 요청 로그 추가
      print('setTripDates 호출됨 - arrivalDate: $arrivalDate, departureDate: $departureDate, totalPeople: $totalPeople');
      print('setTripDates 요청 헤더: sessionid=$sessionId, csrftoken=$csrfToken');

      final response = await http.post(
        Uri.parse('$baseUrl/api/flutter_plan1/'),  // 끝에 슬래시 확인
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': csrfToken,
          'Cookie': 'sessionid=$sessionId; csrftoken=$csrfToken',
        },
        body: json.encode({
          'arrival_date': arrivalDate,
          'departure_date': departureDate,
          'total_people': totalPeople,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final tripPlanId = data['trip_plan_id'] ?? DateTime.now().millisecondsSinceEpoch;
        print('생성된 trip_plan_id: $tripPlanId');

        await prefs.setInt('trip_plan_id', tripPlanId); // trip_plan_id 저장
      } else if (response.statusCode == 302) {
        final redirectUrl = response.headers['location'];
        print('Redirected to: $redirectUrl');
        throw Exception('여행 계획 설정 실패: ${response.statusCode} - 리디렉션됨');
      } else {
        throw Exception('여행 계획 설정 실패: ${response.statusCode}');
      }
    }

    Future<void> setLocation(String destination, String transportationMethod) async {
      if (!await isLoggedIn()) {
        throw Exception('로그인이 필요합니다.');
      }

      final prefs = await SharedPreferences.getInstance();
      final tripPlanIds = prefs.getStringList('trip_plan_ids');

      if (tripPlanIds == null || tripPlanIds.isEmpty) {
        throw Exception('여행 계획이 설정되지 않았습니다.');
      }

      final tripPlanId = int.parse(tripPlanIds.last);

      final response = await client.post(
        Uri.parse('$baseUrl/api/flutter_plan2/'),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': headers['X-CSRFToken'] ?? '',
          'Cookie': headers['Cookie'] ?? '',
          ...headers,
        },
        body: json.encode({
          'trip_plan_id': tripPlanId,
          'destination': destination,
          'transportation_method': transportationMethod,
        }),
      );

      if (response.statusCode == 200) {
        print('여행 계획 위치 설정 성공');
      } else if (response.statusCode == 302) {
        final redirectUrl = response.headers['location'];
        print('Redirected to: $redirectUrl');
        throw Exception('여행 계획 위치 설정 실패: ${response.statusCode} - 리디렉션됨');
      } else {
        throw Exception('여행 계획 위치 설정 실패: ${response.statusCode}');
      }
    }
        
    Future<void> setAccommodation(int accommodationId) async {
      final prefs = await SharedPreferences.getInstance();
      final tripPlanId = prefs.getInt('trip_plan_id'); // trip_plan_id를 SharedPreferences에서 가져옴
      final sessionId = prefs.getString('sessionid');
      final csrfToken = prefs.getString('csrftoken');

      if (tripPlanId == null) {
        throw Exception('여행 계획 ID가 없습니다.'); // trip_plan_id가 없으면 예외 발생
      }

      if (sessionId == null || csrfToken == null) {
        throw Exception('세션 정보나 CSRF 토큰이 없습니다. 로그인을 다시 시도하십시오.');
      }

      // 요청 본문과 헤더 로그 추가
      print('setAccommodation 호출됨 - accommodationId: $accommodationId, tripPlanId: $tripPlanId');
      print('setAccommodation 요청 헤더: sessionid=$sessionId, csrftoken=$csrfToken');

      final response = await http.post(
        Uri.parse('$baseUrl/api/flutter_plan3/'),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': csrfToken,
          'Cookie': 'sessionid=$sessionId; csrftoken=$csrfToken',
        },
        body: json.encode({
          'accommodation_id': accommodationId,
          'trip_plan_id': tripPlanId,
        }),
      );

      print('setAccommodation 응답 상태 코드: ${response.statusCode}');
      print('setAccommodation 응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        print('숙소 설정 성공'); // 성공 메시지
      } else {
        throw Exception('숙소 설정 실패: ${response.statusCode} - ${response.body}');
      }
    }


    Future<void> setActivity(int activityId) async {
      final prefs = await SharedPreferences.getInstance();
      final tripPlanId = prefs.getInt('trip_plan_id');
      if (tripPlanId == null) {
        print('setActivity 호출 시 trip_plan_id가 없습니다.');
        throw Exception('여행 계획 ID가 없습니다. SharedPreferences에 trip_plan_id가 설정되지 않았습니다.');
      }  // 기본값 설정
      final sessionId = prefs.getString('sessionid');
      final csrfToken = prefs.getString('csrftoken');

      if (tripPlanId == -1) {
        print('setActivity 호출 시 trip_plan_id가 없습니다.');
        throw Exception('여행 계획 ID가 없습니다.');
      }

      if (sessionId == null) {
        print('세션 쿠키가 없습니다. 로그인이 필요합니다.');
        throw Exception('세션 쿠키가 없습니다.');
      }

      try {
        // 요청 본문과 헤더 로그 추가
        final requestBody = json.encode({
          'activity_id': activityId,
          'trip_plan_id': tripPlanId,
        });

        print('setActivity 호출됨 - activityId: $activityId, tripPlanId: $tripPlanId');
        print('setActivity 요청 본문: $requestBody');
        print('setActivity 요청 헤더: sessionid=$sessionId, csrftoken=$csrfToken');

        final response = await http.post(
          Uri.parse('$baseUrl/api/activity/'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Cookie': 'sessionid=$sessionId; csrftoken=$csrfToken',
            if (csrfToken != null) 'X-CSRFToken': csrfToken, // CSRF 토큰 추가
          },
          body: requestBody,
        );

        print('setActivity 응답 상태 코드: ${response.statusCode}');
        print('setActivity 응답 본문: ${response.body}');
        if (response.statusCode != 200) {
          throw Exception('활동 설정 실패: ${response.body}');
        }
      } catch (e) {
        print('setActivity 오류: $e');
        rethrow;
      }
    }

    Future<List<Activity>> getActivities() async {
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('sessionid');
      final csrfToken = prefs.getString('csrftoken');

      if (sessionId == null || csrfToken == null) {
        throw Exception('로그인이 필요합니다.');
      }

      try {
        final response = await http.get(
          Uri.parse('$baseUrl/api/activity/'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Cookie': 'sessionid=$sessionId; csrftoken=$csrfToken',
            if (csrfToken != null) 'X-CSRFToken': csrfToken,
          },
        );

        // 응답 본문 출력하여 구조 확인
        print('getActivities 응답 본문: ${response.body}');

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data is Map<String, dynamic> && data.containsKey('activities')) {
            final List<dynamic> activitiesList = data['activities'];
            return activitiesList.map((item) => Activity.fromJson(item)).toList();
          } else {
            throw Exception('올바르지 않은 JSON 응답 구조: ${response.body}');
          }
        } else if (response.statusCode == 302) {
          print('로그인 페이지로 리디렉션되었습니다. 세션이 만료되었을 수 있습니다.');
          throw Exception('로그인 필요');
        } else {
          throw Exception('활동 목록 로드 실패: ${response.body}');
        }
      } catch (e) {
        print('getActivities 오류: $e');
        rethrow;
      }
    }

  Future<void> loadSessionHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString('sessionid');
    final csrfToken = prefs.getString('csrftoken');

    if (sessionId != null && csrfToken != null) {
      headers = {
        'Content-Type': 'application/json',
        'Cookie': 'sessionid=$sessionId; csrftoken=$csrfToken',
        'X-CSRFToken': csrfToken,
      };
    }
  }
Future<Map<String, dynamic>> getTripPlanSummary(int tripPlanId) async {
  // 올바른 URL 생성
  final url = Uri.parse('$baseUrl/api/flutter_plan5/$tripPlanId/');

  print('Requesting trip plan summary for trip_plan_id: $tripPlanId'); // 로그 추가

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      ...headers, // 필요한 실제 헤더로 대체
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['trip_plan'];
  } else {
    print('Error: ${response.statusCode} - ${response.body}'); // 로그를 통해 상태 코드와 응답 확인
    throw Exception('Failed to load trip plan summary: ${response.statusCode}');
  }
}

  Future<List<Accommodation>> getAccommodations() async {
      print('숙소 정보 요청 시작');
      final response = await client.get(Uri.parse('$baseUrl/api/accommodation/'), headers: headers);
      print('숙소 정보 응답 상태 코드: ${response.statusCode}');
      print('숙소 정보 응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body)['accommodations'] as List;
          print('숙소 데이터 파싱 성공');
          return data.map((json) => Accommodation.fromJson(json)).toList();
        } catch (e) {
          print('숙소 데이터 파싱 실패: $e');
          throw Exception('숙소 데이터 파싱 중 오류가 발생했습니다.');
        }
      } else {
        print('숙소 목록을 로드하는 데 실패했습니다: 상태 코드 ${response.statusCode}, 응답: ${response.body}');
        throw Exception('숙소 목록을 로드하는 데 실패했습니다');
      }
    }
  }
  class Accommodation {
  final int id;
  final String name;
  final String photo;
  final String price;

  Accommodation({
    required this.id,
    required this.name,
    required this.photo,
    required this.price,
  });

  factory Accommodation.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null) {
      throw Exception('Accommodation 정보를 파싱하는 동안 id가 누락되었습니다: $json');
    }

    return Accommodation(
      id: json['id'], // null이면 예외가 발생하므로 기본값 0을 사용하지 않습니다.
      name: json['name'] ?? '이름 없음', // name이 null일 경우 기본값 사용
      photo: json['photo'] ?? '', // photo가 null일 경우 빈 문자열 사용
      price: json['price'] ?? '가격 정보 없음', // price가 null일 경우 기본값 사용
    );
  }
}

  class Activity {
    final int id;
    final String name;
    final String photo;
    final String category;

    Activity({
      required this.id,
      required this.name,
      required this.photo,
      required this.category,
    });

  factory Activity.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null || json['name'] == null || json['photo'] == null || json['category'] == null) {
      throw Exception('Activity 정보를 파싱하는 동안 null 값을 발견했습니다: $json');
    }
    return Activity(
      id: json['id'],
      name: json['name'],
      photo: json['photo'],
      category: json['category'],
    );
  }
  }

  class ActivityCategory {
    final int id;
    final String name;

    ActivityCategory({required this.id, required this.name});

    factory ActivityCategory.fromJson(Map<String, dynamic> json) {
      return ActivityCategory(
        id: json['id'],
        name: json['name'],
      );
    }
  }
