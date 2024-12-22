import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // 날짜 형식 관련 intl 패키지

void main() {
  // 한국어 로케일을 사용하여 날짜 형식 초기화
  initializeDateFormatting('ko_KR', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Post Create',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 34, 104, 255),
        ),
        scaffoldBackgroundColor: Colors.white,
        dialogBackgroundColor: Colors.white,
      ),
      home: const PostCreatePage(),
    );
  }
}

class PostListPage extends StatelessWidget {
  const PostListPage({super.key});

  final List<Map<String, String>> posts = const [
    {
      'location': '대전',
      'title': '대전에 놀러오세요~!',
      'content': '이것은 첫 번째 게시물의 내용입니다.',
    },
    {
      'location': '강원도',
      'title': '강원도 여행지 추천',
      'content': '이것은 두 번째 게시물의 내용입니다.',
    },
    {
      'location': '제주도',
      'title': '11월말 제주도 여행',
      'content': '친구들과 겨울 바람 맞으러 가기 좋은 시기',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          '커뮤니티',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: Text(
                post['location']!,
                style: const TextStyle(color: Colors.blue, fontSize: 14),
              ),
              title: Text(post['title']!),
              subtitle: Text(post['content']!.substring(0, 20) + '...'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailPage(post: post),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PostCreatePage(),
            ),
          );
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.blue,
        mini: false,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class PostCreatePage extends StatefulWidget {
  const PostCreatePage({super.key});

  @override
  State<PostCreatePage> createState() => _PostCreatePageState();
}

class _PostCreatePageState extends State<PostCreatePage> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _contentController = TextEditingController();
  String? _selectedDateRange;

  void _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDialog<DateTimeRange>(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: 300, // 캘린더 크기 설정
            height: 400,
            child: CalendarDateRangePicker(
              initialRange: DateTimeRange(
                start: DateTime.now(),
                end: DateTime.now().add(const Duration(days: 1)),
              ),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              onDateRangeSelected: (DateTimeRange? range) {
                Navigator.pop(context, range); // 날짜 범위 선택 후 팝업 닫기
              },
            ),
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange =
        '${picked.start.toString().split(' ')[0]} ~ ${picked.end.toString().split(' ')[0]}';
      });
    }
  }

  void _savePost() {
    final title = _titleController.text;
    final location = _locationController.text;
    final content = _contentController.text;

    if (title.isNotEmpty && location.isNotEmpty && _selectedDateRange != null && content.isNotEmpty) {
      // 게시물을 저장하는 로직 추가 가능
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: TextButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const PostListPage()),
                  (route) => false, // 이전 경로 스택을 모두 제거
            );
          },
          child: const Text(
            '취소',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton(
              onPressed: _savePost,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text(
                '게시',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintText: '제목을 입력해 주세요',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintText: '지역',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _selectDateRange(context),
              child: AbsorbPointer(
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: _selectedDateRange ?? '날짜를 선택해 주세요',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              style: const TextStyle(color: Colors.black),
              controller: _contentController,
              decoration: const InputDecoration(
                hintText: '내용',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}

// 캘린더 위젯
class CalendarDateRangePicker extends StatefulWidget {
  final DateTimeRange initialRange;
  final DateTime firstDate;
  final DateTime lastDate;
  final void Function(DateTimeRange?) onDateRangeSelected;

  const CalendarDateRangePicker({
    super.key,
    required this.initialRange,
    required this.firstDate,
    required this.lastDate,
    required this.onDateRangeSelected,
  });

  @override
  _CalendarDateRangePickerState createState() =>
      _CalendarDateRangePickerState();
}

class _CalendarDateRangePickerState extends State<CalendarDateRangePicker> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialRange.start;
    _endDate = widget.initialRange.end;
  }

  void _onDateSelected(DateTime selectedDate) {
    setState(() {
      if (_startDate == null || (_startDate != null && _endDate != null)) {
        // 시작 날짜 선택
        _startDate = selectedDate;
        _endDate = null; // 이전 종료 날짜 초기화
      } else {
        // 종료 날짜 선택
        if (selectedDate.isBefore(_startDate!)) {
          // 종료 날짜가 시작 날짜보다 이전일 경우, 시작 날짜로 설정
          _startDate = selectedDate;
        } else {
          _endDate = selectedDate;
        }
      }

      // 날짜 범위가 완성되면 콜백 호출
      if (_startDate != null && _endDate != null) {
        widget.onDateRangeSelected(DateTimeRange(
          start: _startDate!,
          end: _endDate!,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalendarDatePicker(
      initialDate: _startDate ?? DateTime.now(),
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      onDateChanged: _onDateSelected,
      currentDate: DateTime.now(),
      selectableDayPredicate: (date) {
        // 선택된 날짜 하이라이트 조건
        if (_startDate != null && _endDate == null) {
          return date.isAfter(_startDate!) || date == _startDate;
        }
        return true;
      },
    );
  }
}

class PostDetailPage extends StatelessWidget {
  final Map<String, String> post;

  const PostDetailPage({required this.post, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post['location']!,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              post['title']!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            const SizedBox(height: 16),
            Text(
              post['content']!,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
