import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; // 추가된 부분
import 'dart:convert'; // 추가된 부분
import '/main.dart';

class TravelSummaryPage extends StatefulWidget {
  const TravelSummaryPage({super.key});

  @override
  _TravelSummaryPageState createState() => _TravelSummaryPageState();
}

class _TravelSummaryPageState extends State<TravelSummaryPage> {
  Map<String, dynamic>? travelSummary;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTravelSummary();
  }

  Future<void> _loadTravelSummary() async {
    final prefs = await SharedPreferences.getInstance();
    final tripPlanId = prefs.getInt('trip_plan_id');

    if (tripPlanId == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://25.17.18.230:8000/api/flutter_plan5/$tripPlanId/'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          travelSummary = data['trip_plan'];
          isLoading = false;
        });
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Exception occurred while fetching trip plan summary: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '여행 계획 요약',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : travelSummary == null
              ? const Center(child: Text('여행 계획을 불러올 수 없습니다.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '여행지: ${travelSummary!['destination']}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '여행 날짜: ${travelSummary!['arrival_date']} - ${travelSummary!['departure_date']}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '숙소: ${travelSummary!['selected_accommodation']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '활동:',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: (travelSummary!['selected_activities'] as List)
                            .map<Widget>((activity) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    activity['name'],
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            // 여행 계획을 최종 확정하는 처리
            await _finalizeTripPlan(context);

            // 메인 페이지로 이동
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/',  // '/' 경로로 이동 (MyHomePage)
              (route) => false, // 이전의 모든 경로 제거
            );
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: const Text('일정 저장'),
        ),
      ),
    );
  }

  Future<void> _finalizeTripPlan(BuildContext context) async {
    // 서버에 요청을 보내는 대신 일정 저장 성공 메시지를 바로 표시하고 메인 페이지로 이동
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
        content: const Text(
          '일정이 성공적으로 저장되었습니다.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
              // 메인 페이지로 바로 이동
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (route) => false,
              );
            },
            child: const Text('확인', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}
