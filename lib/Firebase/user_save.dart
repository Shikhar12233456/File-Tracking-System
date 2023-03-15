import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pr301s/model/user.dart';

class Save {
  final _dbinstance = FirebaseFirestore.instance;
  Future<void> saveInDb(User user) async {
    await _dbinstance
        .collection("user")
        .doc(user.email)
        .set(user.tomap())
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<bool> check(String id) async {
    var check = await _dbinstance.collection("user").doc(id).get();
    return check.exists;
  }

  // Future getUserInfo(String email) async {
  //   _dbinstance
  //       .collection("user")
  //       .where('email', isEqualTo: email)
  //       .get()
  //       .catchError((e) {
  //     print(e.toString());
  //   });
  // }

  Future<Map<String, dynamic>> getUSerInfo(String id) async {
    DocumentSnapshot _doc = await _dbinstance.collection("user").doc(id).get();
    return _doc.data() as Map<String, dynamic>;
  }
}
