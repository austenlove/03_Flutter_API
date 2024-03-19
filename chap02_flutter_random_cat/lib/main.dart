import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => CatService()
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}


class CatService extends ChangeNotifier {
  List<String> catImages = [];
  List<String> favoriteCatImages = [];  // 좋아요 한 고양이 사진

  // CatService 생성자
  CatService() {
    getRandomCatImages();
  }

  // 랜덤 이미지 10개 가져오는 함수
  void getRandomCatImages() async {
    String path = 'https://api.thecatapi.com/v1/images/search?limit=10&mime_types=gif';
    var result = await Dio().get(path);
    print(result.data);

    // 필요한 데이터만 파싱(parsing)
    for(int i=0; i<result.data.length; i++) {
      var map = result.data[i];
      print(map);
      print(map['url']);

      // catImages에 url 추가
      catImages.add(map['url']);
    }
    notifyListeners();
  }

  // 좋아요 기능
  void toggleFavoriteCatImage(String catImage) {
    if (favoriteCatImages.contains(catImage)) {
      favoriteCatImages.remove(catImage);
    } else {
      favoriteCatImages.add(catImage);
    }
    notifyListeners();
  }

}


// 홈 화면
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CatService>(
        builder: (context, catService, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.indigo,
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.white,
                    )
                ),
              ],
              title: Text(
                '랜덤 고양이',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            body: GridView.count(
              // 크로스축(가로)으로 아이템 2개씩 배치
              crossAxisCount: 2,
              // 주축(세로) 사이의 아이템 공간 설정
              mainAxisSpacing: 8,
              // 크로스축 사이의 아이템 공간 설정
              crossAxisSpacing: 8,
              // 그리드 전체 패딩 설정
              padding: EdgeInsets.all(8),

              // 그리드에 표시될 위젯 리스트 (현재 10개의 위젯)
              children: List.generate(catService.catImages.length, (index) {
                String catImage = catService.catImages[index];
                return GestureDetector(
                  child: Stack(
                    children: [
                      /** Positioned
                       * Stack 내에서 자식 위젯의 위치를 정밀하게 제어
                       * top, right, bottom, left 4가지 속성으로 위치 조정
                       * Positioned.fill 4가지 속성 모두 0으로 설정되며 Stack 모든 면을 채움
                       * */
                      Positioned.fill(
                        child: Image.network(
                          catImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Icon(
                          Icons.favorite,
                          color: catService.favoriteCatImages.contains(catImage) ?
                          Colors.red : Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // 사진 클릭 시 작동
                    catService.toggleFavoriteCatImage(catImage);
                  },
                );
              }),

            ),
          );
        });
  }

}