import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';


// ChangeNotifier : provider에서 제공하는 상태관리 패키지
// 플러터의 native 패키지
// Navigator나 GoRouter를 이용하여 페이지 이동 시 데이터를 실어 보낼 수 있다.
class CatService extends ChangeNotifier {

  late SharedPreferences prefs;
  List<String> catImages = [];
  List<String> favoriteCatImages = [];  // 좋아요 한 고양이 사진

  // CatService 생성자
  CatService(SharedPreferences prefs) {
    this.prefs = prefs;
    getRandomCatImages();
    getFavoriteCatImages();
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

    notifyListeners();   // 위젯 갱신
  }

  // prefs에서 저장된 FavoriteCatImages 가져오는 함수
  void getFavoriteCatImages()  {
    favoriteCatImages = prefs.getStringList('favoriteCatImages') ?? [];
  }


  // 좋아요 기능
  void toggleFavoriteCatImage(String catImage) {
    if (favoriteCatImages.contains(catImage)) {
      favoriteCatImages.remove(catImage);
    } else {
      favoriteCatImages.add(catImage);
    }

    // shared preference에 저장
    prefs.setStringList('favoriteCatImages', favoriteCatImages);

    notifyListeners();
  }

  // 좋아요 clear() 기능
  void clearFavoriteCatImage() {
    favoriteCatImages.clear();

    notifyListeners();
  }

}