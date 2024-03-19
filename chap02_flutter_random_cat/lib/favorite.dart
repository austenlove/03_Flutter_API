import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cat_service.dart';


// favorite 페이지
class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    // CatService 가져오기
    final catService = Provider.of<CatService>(context);

    return Scaffold(
      // AppBar
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(
          'Favorites',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
        actions: [
          IconButton(
              onPressed: () {
                // 경고창 표시
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text('정말로 초기화하시겠습니까?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('취소'),
                        ),
                        TextButton(
                          onPressed: () {
                            // favoriteCatImages 초기화
                            catService.clearFavoriteCatImage();
                            Navigator.of(context).pop();   // 경고창 닫기
                          },
                          child: Text('확인'),
                        ),
                      ],
                    );
                  },
                );
                // favoriteCatImages 비우기
                // catService.clearFavoriteCatImage();
              },
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              )
          ),
        ],
      ),

      body: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: EdgeInsets.all(8),

        // 그리드에 표시할 위젯 리스트(favortieCatImages.length 만큼)
        children: List.generate(catService.favoriteCatImages.length, (index) {
          String catImage = catService.favoriteCatImages[index];

          return GestureDetector(
            child: Stack(
              children: [
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
              // 선택 시 favorite 해제
              catService.toggleFavoriteCatImage(catImage);
            },
          );

        }),
      ),

    );
  }

}
