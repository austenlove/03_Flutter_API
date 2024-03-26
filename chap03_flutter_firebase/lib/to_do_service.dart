import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ToDoService extends ChangeNotifier {

  // todo 컬렉션 인스턴스 생성
  final toDoCollection = FirebaseFirestore.instance.collection('toDo');

  // create
  void create(String job, String uid) async {
    // todo 만들기
    await toDoCollection.add({
      'uid' : uid,
      'job' : job,
      'isDone' : false,
    });
    notifyListeners();
  }


  // read
  // QuerySnapshop : 파이어베이스에서 쿼리를 실행한 결과로 반환되는 객체
  Future<QuerySnapshot> read(String uid) async {
    // 내 toDoList 가져오기
    return toDoCollection.where('uid', isEqualTo: uid).get();
    throw UnimplementedError();   // return 값 미구현 에러
  }


  // update
  void update(String docId, bool isDone) async {
    // todo isDone 업데이트
    await toDoCollection.doc(docId).update(
        {"isDone": isDone}
    );
    notifyListeners();
  }


  // delete
  void delete(String docId) async {
    // todo 삭제
    await toDoCollection.doc(docId).delete();
    notifyListeners();
  }

}