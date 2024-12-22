import 'package:flutter/material.dart';
import 'location.dart';
import 'activity.dart';
import '/services/api_service.dart';

void main() {
  runApp(const lodgingpage());
}

class lodgingpage extends StatelessWidget {
  const lodgingpage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const LodgingPage(),
    );
  }
}

class LodgingPage extends StatefulWidget {
  const LodgingPage({super.key});

  @override
  _LodgingPageState createState() => _LodgingPageState();
}

class _LodgingPageState extends State<LodgingPage> {
  int? selectedAccommodationIndex;
  Future<List<Accommodation>>? accommodations;

  @override
  void initState() {
    super.initState();
    accommodations = ApiService().getAccommodations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LocationPage()),
            );
          },
        ),
        title: const Padding(
          padding: EdgeInsets.only(left: 90.0),
          child: Text(
            '숙소 선택하기',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Accommodation>>(
        future: accommodations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('숙소 정보를 불러오는 데 실패했습니다.')); // 에러 메시지 출력
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('추천할 숙소가 없습니다.'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final accommodation = snapshot.data![index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAccommodationIndex = index;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AccommodationDetailPage(
                            title: accommodation.name,
                            description: '여기에는 숙소의 상세 설명이 들어갑니다.',
                            price: '${accommodation.price} 원',
                            imageUrl: '${ApiService().baseUrl}${accommodation.photo}',
                            accommodationId: accommodation.id, // 추가: 숙소 ID 전달
                          ),
                        ),
                      );
                    },
                    child: AccommodationCard(
                      title: accommodation.name,
                      description: '여기에는 숙소의 설명이 들어갑니다.',
                      price: '${accommodation.price} 원',
                      imageUrl: '${ApiService().baseUrl}${accommodation.photo}',
                      isSelected: selectedAccommodationIndex == index,
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class AccommodationCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final String imageUrl;
  final bool isSelected;

  const AccommodationCard({
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? const Color.fromARGB(255, 243, 243, 243) : Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              height: 150,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, color: Colors.red);
              },
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 8),
            Text(
              price,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
class AccommodationDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final String imageUrl;
  final int accommodationId; // 추가: 숙소 ID를 전달받기 위해 추가

  const AccommodationDetailPage({
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.accommodationId, // 추가: 숙소 ID 전달
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              height: 250,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, color: Colors.red);
              },
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 16),
            Text(
              price,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                try {
                  // 숙소를 서버에 저장하기 위해 ApiService 호출
                  await ApiService().setAccommodation(accommodationId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('숙소가 성공적으로 저장되었습니다.')),
                  );

                  // 성공 시 활동 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ActivitySelectionPage()),
                  );
                } catch (e) {
                  // 오류가 발생할 경우
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('숙소 저장 실패: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(380, 50),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('선택 완료'),
            ),
          ],
        ),
      ),
    );
  }
}

