import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'location.dart';
import '/main.dart';
import 'package:moblie/services/api_service.dart'; // ApiService를 import

void main() {
  initializeDateFormatting('ko_KR', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const CalendarPage(),
    );
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _startDay;
  DateTime? _endDay;
  
  int _adultCount = 1;
  int _teenCount = 0;
  int _childCount = 0;

  final ApiService apiService = ApiService(); // ApiService 객체 생성

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      if (_startDay == null || (_startDay != null && _endDay != null)) {
        _startDay = selectedDay;
        _endDay = null;
      } else if (_startDay != null && _endDay == null) {
        if (selectedDay.isAfter(_startDay!)) {
          _endDay = selectedDay;
        } else {
          _startDay = selectedDay;
        }
      }
      _focusedDay = focusedDay;
    });
  }

  void _showDateAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
          content: const Text(
            '날짜를 선택해 주십시오.',
            textAlign: TextAlign.center,
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 5),
          actions: <Widget>[
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  '확인',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
               context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(title: 'Travel Plan'),
        ),
            );
          },
        ),
        backgroundColor: Colors.white,
        title: const Text(
          '여행 계획',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildCalendarSelection(),
              const SizedBox(height: 20),
              _buildPeopleSelection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: ElevatedButton(
          onPressed: () async {
            if (_startDay == null || _endDay == null) {
              _showDateAlertDialog();
            } else if (_adultCount == 0 && _teenCount == 0 && _childCount == 0) {
              _showPeopleAlertDialog();
            } else {
              try {
                await apiService.setTripDates(
                  DateFormat('yyyy-MM-dd').format(_startDay!),
                  DateFormat('yyyy-MM-dd').format(_endDay!),
                  _adultCount + _teenCount + _childCount,
                );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocationPage(),
                ),
              );
              } catch (e) {
                // 에러 발생 시 로그 출력 및 에러 처리
                print('날짜 설정 중 오류 발생: $e');
              }
            }
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: const Text('선택 완료'),
        ),
      ),
    );
  }

  Widget _buildCalendarSelection() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          TableCalendar(
            locale: 'ko_KR',
            firstDay: DateTime.utc(2010, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_startDay, day) || isSameDay(_endDay, day);
            },
            onDaySelected: _onDaySelected,
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: const CalendarStyle(
              defaultDecoration: BoxDecoration(
                color: Colors.white,
              ),
              selectedDecoration: BoxDecoration(
                color: Color.fromARGB(255, 34, 149, 255),
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Color.fromARGB(255, 149, 202, 255),
                shape: BoxShape.circle,
              ),
              outsideDaysVisible: false,
            ),
          ),
          const SizedBox(height: 20.0),
          if (_startDay != null && _endDay != null)
            Text(
              '${DateFormat('yyyy.MM.dd').format(_startDay!)} - ${DateFormat('yyyy.MM.dd').format(_endDay!)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPeopleSelection() {
    return Column(
      children: [
        const SizedBox(height: 20),
        _buildCounterRow('성인', _adultCount, _incrementAdultCount, _decrementAdultCount),
        const SizedBox(height: 30),
        _buildCounterRow('청소년', _teenCount, _incrementTeenCount, _decrementTeenCount),
        const SizedBox(height: 30),
        _buildCounterRow('아동', _childCount, _incrementChildCount, _decrementChildCount),
      ],
    );
  }

  Widget _buildCounterRow(String label, int count, VoidCallback increment, VoidCallback decrement) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: decrement,
          iconSize: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '$count',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: increment,
          iconSize: 20,
        ),
      ],
    );
  }

  void _showPeopleAlertDialog() {
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
  }
}
