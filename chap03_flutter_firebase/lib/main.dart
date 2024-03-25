import 'package:chap03_flutter_firebase/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  // main()에서 async 사용하기 위해 선언
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase 앱 시작
  await Firebase.initializeApp();

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthService()),
        ],
        child: const MyApp(),
      ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MyApp 에서 유저 조회
    final user = context.read<AuthService>().currentUser();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // user 여부에 따라 home 위젯 변경
      home: user == null ? LoginPage() : HomePage(),
    );
  }
}



// 로그인 페이지
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {

        // 로그인한 유저 객체 가져오기
        User? user = authService.currentUser();

        return Scaffold(
          appBar: AppBar(
            title: Text('Login'),
          ),

          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    user == null ? '로그인해주세요.' : '${user.email}님, 반갑습니다.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(hintText: '이메일 주소'),
                ),
                TextField(
                  controller: pwController,
                  decoration: InputDecoration(hintText: '비밀번호'),
                  obscureText: true,
                ),
                SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                  onPressed: () {
                    // 로그인 성공 시 HomePage로 이동
                    authService.signIn(
                        email: emailController.text, 
                        pw: pwController.text, 
                        onSuccess: () {
                          // 로그인 성공
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("로그인 성공")
                            ),
                          );
                          // 로그인 성공 시 HomePage()로 이동
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => HomePage())
                          );
                        }, 
                        onError: (err) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(err),
                            ),
                          );
                        },
                    );
                  },
                  child: Text(
                    '로그인',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // 로그인 성공 시 HomePage로 이동
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(builder: (_) => HomePage())
                    // );
                    authService.signUp(
                        email: emailController.text,
                        pw: pwController.text,
                        onSuccess: () {
                          // print("회원가입 성공");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('회원가입 성공'),
                            ),
                          );
                        },
                        onError: (err) {
                          // print("회원가입 실패 : $err");
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(err),
                              ),
                          );
                        },
                    );
                  },
                  child: Text(
                    '회원가입',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),

              ],
            ),
          ),
        );
    },
    );

  }
}



// 홈 화면
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController jobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do List'),
        actions: [
          TextButton(
              onPressed: () {
                // 로그아웃 버튼 클릭 시 액션
                context.read<AuthService>().signOut();
                // 로그인 페이지로 이동
                Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (_) => LoginPage()),
                );
              },
              child: Text(
                '로그아웃',
                style: TextStyle(color: Colors.black),
              ),
          )
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: jobController,
                    decoration: InputDecoration(hintText: '할 일을 입력하세요.'),
                  ),
                ),

                ElevatedButton(
                    onPressed: () {},
                    child: Icon(Icons.add)
                ),
              ],
            ),
          ),

          Divider(
            height: 1,
          ),

          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                String job = "$index";
                bool isDone = false;

                return ListTile(
                  title: Text(
                    job,
                    style: TextStyle(
                      fontSize: 20,
                      color: isDone ? Colors.grey : Colors.black,
                      decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      // 삭제 버튼 클릭 시 액션
                    },
                    icon: Icon(
                      CupertinoIcons.delete,
                    ),
                  ),
                  onTap: () {},
                );
              }
            ),
          ),
        ],
      ),

    );
  }
}
