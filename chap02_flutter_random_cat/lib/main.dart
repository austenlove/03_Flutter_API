import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cat_service.dart';
import 'home_page.dart';

void main() async {

  // main()에서 async 사용
  WidgetsFlutterBinding.ensureInitialized();

  // Shared Preference 인스턴스 생성 (초기 설정값 저장)
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
