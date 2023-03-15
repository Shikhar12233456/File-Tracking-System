import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pr301s/model/fileModel.dart';

class File {
  final _dbinstance = FirebaseFirestore.instance;
  final _dbstorageinstance = FirebaseStorage.instance;
  final _usercollection = FirebaseFirestore.instance.collection("user");
  final _filecollection = FirebaseFirestore.instance.collection("files");
  Future savetoFirebase(Uint8List? file, String? filename, String sender,
      String receiver, String title, String discription, String remark) async {
    String path = "file$filename+${DateTime.now()}";
    Reference reference = _dbstorageinstance.ref("files").child(path);
    Future<TaskSnapshot> uploadTask = reference.putData(file!);
    uploadTask.whenComplete(() async {
      String filepath = await reference.getDownloadURL();

      savefile(
          sender,
          receiver,
          FileModel(
              title: title,
              discription: discription,
              path: filepath,
              remark: remark,
              status: "Pending",
              time: DateTime.now().toString(),
              sender: sender));
    });
  }

  Future savefile(String sender, String receiver, FileModel fileModel) async {
    var set = await _filecollection.add(fileModel.tomap());
    _filecollection.doc(set.id).collection("history").add(fileHistory(
            sender: sender, receiver: receiver, time: DateTime.now().toString())
        .tomap());
    _usercollection.doc(sender).collection("sendfiles").add({"file": set.id});
    _usercollection
        .doc(receiver)
        .collection("receivedfiles")
        .doc(set.id)
        .set({"file": set.id});
  }

  Future<Map<String, dynamic>> getFilebyId(String id) async {
    DocumentSnapshot doc = await _dbinstance.collection("files").doc(id).get();

    return doc.data() as Map<String, dynamic>;
  }

  Future<void> acceptFile(String id, String userId) async {
    _filecollection.doc(id).update({"status": "accepted"});
    DocumentReference doc =
        _usercollection.doc(userId).collection("receivedfiles").doc(id);
    await FirebaseFirestore.instance
        .runTransaction((Transaction myTransaction) async {
      myTransaction.delete(doc);
    });
    _usercollection.doc(userId).collection("acceptedfiles").add({"file": id});
  }

  Future<void> rejectFile(String id, String userId) async {
    _filecollection.doc(id).update({"status": "rejected"});
    DocumentReference doc =
        _usercollection.doc(userId).collection("receivedfiles").doc(id);
    await FirebaseFirestore.instance
        .runTransaction((Transaction myTransaction) async {
      myTransaction.delete(doc);
    });
    _usercollection
        .doc(userId)
        .collection("rejectedfiles")
        .doc(id)
        .set({"file": id});
  }

  Future<void> forwardFile(String id, String userId, String toId) async {
    String time = DateTime.now().toString();
    _filecollection.doc(id).update({"status": "forwarded"});
    _filecollection
        .doc(id)
        .collection("history")
        .add(fileHistory(sender: userId, receiver: toId, time: time).tomap());
    DocumentReference doc =
        _usercollection.doc(userId).collection("receivedfiles").doc(id);
    await FirebaseFirestore.instance
        .runTransaction((Transaction myTransaction) async {
      myTransaction.delete(doc);
    });
    _usercollection.doc(userId).collection("forwardedfiles").add({"file": id});
    _usercollection
        .doc(toId)
        .collection("receivedfiles")
        .doc(id)
        .set({"file": id});
  }
}
