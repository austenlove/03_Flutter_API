import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


// 상태 클래스
class _HomePageState extends State<HomePage> {
  String quiz = '퀴즈';
  
  /** initState()
   * StatefulWidget에서 위젯이 처음 생성될 때 실행되는 함수
   * */
  @override
  void initState() {
    super.initState();   // 그냥 외워라 StatefulWidget 사용 시 실행
    getQuiz();
  }
  
  // Numbers API 호출하기
  Future<String> getNumberTrivia() async {
    String path = 'http://numbersapi.com/random/trivia';
    Response result = await Dio().get(path);
    String trivia = result.data;
    print(trivia);
    return trivia;
  }

  void getQuiz() async {
    String trivia = await getNumberTrivia();
    setState(() {
      quiz = trivia;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.indigo,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            /** 크로스 축
             *  주축의 반대되는 축을 크로스 축이라고 함
             *  Column의 주축은 세로방향이고, 따라서 크로스축은 가로 방향
             * */
            // 크로스축 방향으로 가능한한 많은 공간 차지
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              /** Expanded 설정
               *  레이아웃 위젯으로, 자식 위젯이 사용 가능한 추가 공간을 모두 차지하도록
               *  주로 Row, Column 같은 레이아웃 위젯을 사용할 때, 내부의 자식
               * */
              Expanded(
                child: Center(
                  child: Text(
                    quiz,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // 퀴즈 생성 버튼
              SizedBox(
                height: 42,
                child: ElevatedButton(
                  onPressed: () {
                    // 버튼 눌렀을 때 동작
                    getQuiz();
                    },
                  child: Text(
                    'New Quiz',
                    style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



