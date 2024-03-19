import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cat_service.dart';
import 'favorite.dart';


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
              title: Text(
                '랜덤 고양이',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      // favorite를 누르면 페이지 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FavoritePage(),),
                      );
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.white,
                    )
                ),
              ],
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
