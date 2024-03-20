import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cat_service.dart';
import 'home_page.dart';

// SharedPreferences 전역변수 선언 : 초기 설정값 저장
// late SharedPreferences prefs;
void main() async {

  // main()에서 async 사용
  WidgetsFlutterBinding.ensureInitialized();

  // Shared Preference 인스턴스 생성
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  // favoriteCatImages 가져오기
  List<String> favoriteCatImages = prefs.getStringList('favoriteCatImages') ?? [];

  /** Provider : 플러터 앱에서 상태를 관리하고 전역에 액세스를 허용하는 패키지
   * 앱의 여러 부분에서 동일한 데이터를 공유하고 액세스 가능
   * 여러가지 유형의 Provider 제공 (예: ChangeNotifier 등)
   * */
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CatService(prefs)),
      ],
      child: const MyApp(),
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







// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// // SharedPreferences 전역변수 선언 : 초기 설정값 저장
// late SharedPreferences prefs;
//
// void main() async {
//   // main()에서 async 사용
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Shared Preference 인스턴스 생성
//   prefs = await SharedPreferences.getInstance();
//
//   // favoriteCatImages 가져오기
//   List<String> favoriteCatImages = prefs.getStringList('favoriteCatImages') ?? [];
//
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => CatService(favoriteCatImages)),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomePage(),
//     );
//   }
// }
//
//
// class CatService extends ChangeNotifier {
//   List<String> catImages = [];
//   List<String> favoriteCatImages;  // 좋아요 한 고양이 사진
//
//   // CatService 생성자
//   CatService(this.favoriteCatImages) {
//     getRandomCatImages();
//     getFavoriteCatImages();
//   }
//
//   // 랜덤 이미지 10개 가져오는 함수
//   void getRandomCatImages() async {
//     String path = 'https://api.thecatapi.com/v1/images/search?limit=10&mime_types=gif';
//     var result = await Dio().get(path);
//     print(result.data);
//
//     // 필요한 데이터만 파싱(parsing)
//     for(int i=0; i<result.data.length; i++) {
//       var map = result.data[i];
//       print(map);
//       print(map['url']);
//
//       // catImages에 url 추가
//       catImages.add(map['url']);
//     }
//
//     notifyListeners();   // 위젯 갱신
//   }
//
//   // prefs에서 저장된 FavoriteCatImages 가져오는 함수
//   void getFavoriteCatImages() async {
//     favoriteCatImages = prefs.getStringList('favoriteCatImages') ?? [];
//   }
//
//
//   // 좋아요 기능
//   void toggleFavoriteCatImage(String catImage) {
//     if (favoriteCatImages.contains(catImage)) {
//       favoriteCatImages.remove(catImage);
//     } else {
//       favoriteCatImages.add(catImage);
//     }
//
//     // shared preference에 저장
//     prefs.setStringList('favoriteCatImages', favoriteCatImages);
//
//     notifyListeners();
//   }
//
//   // 좋아요 clear() 기능
//   void clearFavoriteCatImage() {
//     favoriteCatImages.clear();
//     notifyListeners();
//   }
//
// }
//
//
//
// // 홈 화면
// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<CatService>(
//         builder: (context, catService, child) {
//           return Scaffold(
//             appBar: AppBar(
//               backgroundColor: Colors.indigo,
//               title: Text(
//                 '랜덤 고양이',
//                 style: TextStyle(
//                   color: Colors.white,
//                 ),
//               ),
//               actions: [
//                 IconButton(
//                     onPressed: () {
//                       // favorite를 누르면 페이지 이동
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => FavoritePage(),),
//                       );
//                     },
//                     icon: Icon(
//                       Icons.favorite,
//                       color: Colors.white,
//                     )
//                 ),
//               ],
//             ),
//
//             body: GridView.count(
//               // 크로스축(가로)으로 아이템 2개씩 배치
//               crossAxisCount: 2,
//               // 주축(세로) 사이의 아이템 공간 설정
//               mainAxisSpacing: 8,
//               // 크로스축 사이의 아이템 공간 설정
//               crossAxisSpacing: 8,
//               // 그리드 전체 패딩 설정
//               padding: EdgeInsets.all(8),
//
//               // 그리드에 표시될 위젯 리스트 (현재 10개의 위젯)
//               children: List.generate(catService.catImages.length, (index) {
//                 String catImage = catService.catImages[index];
//                 return GestureDetector(
//                   child: Stack(
//                     children: [
//                       /** Positioned
//                        * Stack 내에서 자식 위젯의 위치를 정밀하게 제어
//                        * top, right, bottom, left 4가지 속성으로 위치 조정
//                        * Positioned.fill 4가지 속성 모두 0으로 설정되며 Stack 모든 면을 채움
//                        * */
//                       Positioned.fill(
//                         child: Image.network(
//                           catImage,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 8,
//                         right: 8,
//                         child: Icon(
//                           Icons.favorite,
//                           color: catService.favoriteCatImages.contains(catImage) ?
//                           Colors.red : Colors.transparent,
//                         ),
//                       ),
//                     ],
//                   ),
//                   onTap: () {
//                     // 사진 클릭 시 작동
//                     catService.toggleFavoriteCatImage(catImage);
//                   },
//                 );
//               }),
//
//             ),
//           );
//         });
//   }
//
// }
//
//
// // // favorite 페이지
// class FavoritePage extends StatelessWidget {
//   const FavoritePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // CatService 가져오기
//     final catService = Provider.of<CatService>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.indigo,
//         title: Text(
//           'Favorites',
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           color: Colors.white,
//         ),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 // 경고창 표시
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return AlertDialog(
//                       content: Text('정말로 초기화하시겠습니까?'),
//                       actions: [
//                         TextButton(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           child: Text('취소'),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             // favoriteCatImages 초기화
//                             catService.clearFavoriteCatImage();
//                             Navigator.of(context).pop();   // 경고창 닫기
//                           },
//                           child: Text('확인'),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//                 // favoriteCatImages 비우기
//                 // catService.clearFavoriteCatImage();
//               },
//               icon: Icon(
//                 Icons.delete,
//                 color: Colors.white,
//               )
//           ),
//         ],
//       ),
//
//       body: GridView.count(
//         crossAxisCount: 2,
//         mainAxisSpacing: 8,
//         crossAxisSpacing: 8,
//         padding: EdgeInsets.all(8),
//
//         // 그리드에 표시할 위젯 리스트(favortieCatImages.length 만큼)
//         children: List.generate(catService.favoriteCatImages.length, (index) {
//           String catImage = catService.favoriteCatImages[index];
//
//           return GestureDetector(
//             child: Stack(
//               children: [
//                 Positioned.fill(
//                   child: Image.network(
//                     catImage,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 8,
//                   right: 8,
//                   child: Icon(
//                     Icons.favorite,
//                     color: catService.favoriteCatImages.contains(catImage) ?
//                     Colors.red : Colors.transparent,
//                   ),
//                 ),
//               ],
//             ),
//             onTap: () {
//               // 선택 시 favorite 해제
//               catService.toggleFavoriteCatImage(catImage);
//             },
//           );
//
//         }),
//       ),
//
//     );
//   }
//
// }