import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> filePicker() async {
  String temp = " ";
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  // if (result != null) {
  Uint8List? file = result!.files.single.bytes;
  String? fileName = result.files.single.name;
  print(result.files.first.name);
  String path = "file$fileName+${DateTime.now()}";
  Reference ref = FirebaseStorage.instance.ref("files").child(path);
  Future<TaskSnapshot> uploadTask = ref.putData(file!);
  uploadTask.whenComplete(() async {
    temp = await ref.getDownloadURL();
    print(temp);
  });
  // } else {}
  return temp;
}
