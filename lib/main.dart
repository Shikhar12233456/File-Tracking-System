import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:pr301s/screens/dashboard.dart';
import 'package:pr301s/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDSop80jT_gUZFCEKlIuSF31hoSrrKquDg",
          appId: "1:307003607296:web:3d43ff6584c3b835770be5",
          messagingSenderId: "307003607296",
          storageBucket: "pr301s.appspot.com",
          projectId: "pr301s"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _auth = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _auth == null ? Home() : const Dash(),
    );
  }
}
