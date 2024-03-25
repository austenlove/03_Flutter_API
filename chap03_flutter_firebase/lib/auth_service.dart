import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

// 로그인, 회원가입을 담당하는 서비스 객체
class AuthService extends ChangeNotifier {

  // 로그인한 유저 정보 가져오기
  User? currentUser() {
    // 로그인되지 않으면 null qksghks
    return FirebaseAuth.instance.currentUser;
  }


  // 이름지정 매개변수
  // 소괄호 안에 중괄호를 넣고, 그 안에 매개변수를 넣어서 표현
  // 이름지정 매개변수는 해당 이름으로 값을 받아오는 역할을 함


  // 회원가입
  void signUp ({
    required String email,
    required String pw,
    required Function() onSuccess,
    required Function(String err) onError,

  }) async {
    // 회원가입 로직 (입력여부 유효성 검증)
    if(email.isEmpty) {
      onError('이메일을 입력하세요.');
      return;
    } else if(pw.isEmpty) {
      onError('비밀번호를 입력하세요');
      return;
    }

    // firebase auth 회원가입
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: pw,
      );
      // 성공 함수 호출
      onSuccess();
    } on FirebaseAuthException catch (e) {   // firebase auth 에러 발생 시
      // onError(e.message!);
      // 에러메시지 한국어로 바꾸기
      if (e.code == 'weak-password') {
        onError('비밀번호를 6자리 이상 입력해 주세요.');
      } else if (e.code == 'email-already-in-use') {
        onError('이미 가입된 이메일 입니다.');
      } else if (e.code == 'invalid-email') {
        onError('이메일 형식을 확인해주세요.');
      } else if (e.code == 'user-not-found') {
        onError('일치하는 이메일이 없습니다.');
      } else if (e.code == 'wrong-password') {
        onError('비밀번호가 일치하지 않습니다.');
      } else {
        onError(e.message!);
      }

      // Firebase auth 에러 발생
      // ! => null을 강제로 벗겨준다.
      onError(e.message!);

    } catch (e) {
      // firebase auth 이외 에러 발생
      onError(e.toString());
    }
  }



  // 로그인
  void signIn ({
    required String email,
    required String pw,
    required Function() onSuccess,
    required Function(String err) onError,

  }) async {
    // 로그인 로직
    if(email.isEmpty) {
      onError('이메일을 입력해주세요');
      return;
    } else if (pw.isEmpty) {
      onError('비밀번호를 입력해주세요.');
      return;
    }

    // 로그인 시도
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: pw,
      );

      // 성공 함수 호출
      onSuccess();
      // 로그인 상태 변경 알림
      notifyListeners();

    } on FirebaseAuthException catch (e) {
      // firebase auth 에러 발생
      onError(e.message!);
    } catch(e) {
      onError(e.toString());
    }
  }



  // 로그아웃
  void signOut () async {
    // 로그아웃 로직
    await FirebaseAuth.instance.signOut();
    // 로그인 상태 변경 알림
    notifyListeners();
  }

}