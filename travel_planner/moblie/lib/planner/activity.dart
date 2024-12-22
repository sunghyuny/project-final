import 'package:flutter/material.dart';
import 'lodging.dart';
import 'summary.dart'; // SummaryPage를 import합니다.
import '/services/api_service.dart'; // ApiService import
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences import

void main() {
  runApp(const activitypage());
}

class activitypage extends StatelessWidget {
  const activitypage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '활동 선택하기',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const ActivitySelectionPage(),
    );
  }
}

class ActivitySelectionPage extends StatefulWidget {
  const ActivitySelectionPage({super.key});

  @override
  _ActivitySelectionPageState createState() => _ActivitySelectionPageState();
}

class _ActivitySelectionPageState extends State<ActivitySelectionPage> {
  List<Map<String, dynamic>> _activities = [];
  final List<String> chipLabels = ["식분", "경관", "체험", "전신"];
  String? selectedChip;

  @override
  void initState() {
    super.initState();
    _initializeTripPlanId();
    _fetchActivities();
  }

  Future<void> _initializeTripPlanId() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('trip_plan_id')) {
      await prefs.setInt('trip_plan_id', 123); // 임의의 trip_plan_id 설정
    }
  }
  Future<void> _fetchActivities() async {
    try {
      final activities = await ApiService().getActivities();
      setState(() {
        _activities = activities.map((activity) => {
          "id": activity.id, // id 값을 추가하여 나중에 참조할 수 있게 함
          "title": activity.name,
          "selected": false,
          "image": activity.photo,
          "category": activity.category,
        }).toList();
      });
    } catch (e) {
      print('활동 정보를 불러오는 데 실패했습니다: $e');
    }
  }

  Future<void> _setActivity(int activityId) async {
    try {
      await ApiService().setActivity(activityId);
      // 활동을 설정한 후 목록을 다시 가져오지 않도록 수정
    } catch (e) {
      print('활동 설정 실패: $e');
    }
  }
    void _toggleSelection(int index) {
      var filteredActivity = getFilteredActivities()[index];
      int originalIndex = _activities.indexWhere((activity) => activity['title'] == filteredActivity['title']);

      setState(() {
        _activities[originalIndex]['selected'] = !_activities[originalIndex]['selected'];
      });

      if (_activities[originalIndex]['selected']) {
        // 선택한 활동의 고유 id를 사용하여 활동을 설정
        final activityId = _activities[originalIndex]['id'];
        if (activityId != null) {
          _setActivity(activityId);
        } else {
          print('활동 ID가 null입니다. 활동을 설정할 수 없습니다.');
        }
      }
    }


  void _selectChip(String label) {
    setState(() {
      selectedChip = selectedChip == label ? null : label;
    });
  }

  List<Map<String, dynamic>> getFilteredActivities() {
    if (selectedChip == null) return _activities;
    return _activities.where((activity) => activity['category'] == selectedChip).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LodgingPage()),
            );
          },
        ),
        title: const Text(
          '활동 선택하기',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Wrap(
            spacing: 8.0,
            children: chipLabels.map((label) {
              return ChoiceChip(
                label: Text(
                  label,
                  style: TextStyle(
                    color: selectedChip == label ? Colors.white : Colors.grey,
                    fontSize: 14,
                  ),
                ),
                selected: selectedChip == label,
                onSelected: (_) {
                  _selectChip(label);
                },
                backgroundColor: Colors.white,
                selectedColor: Colors.blue,
              );
            }).toList(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: getFilteredActivities().length,
              itemBuilder: (context, index) {
                var activity = getFilteredActivities()[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    leading: Image.network(
                      activity['image'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error, color: Colors.red),
                    ),
                    title: Text(activity["title"]),
                    trailing: IconButton(
                      icon: Icon(
                        activity["selected"] ? Icons.check_box : Icons.check_box_outline_blank,
                        color: Colors.blue,
                      ),
                      onPressed: () => _toggleSelection(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
        child: ElevatedButton(
          onPressed: () {
            final selectedActivities = _activities
                .where((activity) => activity['selected'])
                .map((activity) => activity['title'])
                .toList();

            if (selectedActivities.isEmpty) {
              _showErrorDialog('최소 하나의 활동을 선택해 주십시오.');
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TravelSummaryPage(),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: const Text('선택 완료'),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message, textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}
