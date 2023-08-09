import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pr301s/Firebase/login.dart';
import 'package:pr301s/Firebase/user_save.dart';
import 'package:pr301s/model/user.dart';
import 'package:pr301s/screens/s_login.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _secondname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[75],
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 50,),
            // Image(image: Image.asset(E:\flutter\pr301s\assets\logo.jpeg)),
            Image.asset("assets/logo.jpeg"),
            const SizedBox(
              height: 75,
            ),
            Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.65,
              width: MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                // color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                      color: Colors.black.withOpacity(0.5), width: 1)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                    child: Text(
                      "Sign-Up",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                    ),
                  ),
                  tec("First Name", _firstname, false),
                  paddBox(),
                  tec("Last Name", _secondname, false),
                  paddBox(),
                  tec("Username", _name, false),
                  paddBox(),
                  tec("Email", _email, false),
                  paddBox(),
                  tec("Password", _password, true),
                  paddBox(),
                  tec("Confirm Password", _confirmpassword, false),
                  paddBox(),
                  tec("Role", _bio, false),
                  paddBox(),
                  GestureDetector(
                    onTap: () async {
                      if (kDebugMode) {
                        print(
                            "${_name.text} ${_email.text} ${_password.text} ${_bio.text}");
                      }
                      if (!await Save().check(_name.text)) {
                        Save().saveInDb(User(
                            username: _name.text,
                            firstname: _firstname.text,
                            secondname: _secondname.text,
                            email: _email.text,
                            bio: _bio.text));
                        Auth().signUp(_email.text, _password.text);
                      } else {
                        const snackBar =
                            SnackBar(content: Text("User already Present"));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 250,
                        alignment: Alignment.center,
                        constraints: const BoxConstraints(
                          maxWidth: 250,
                          minHeight: 40,
                        ),
                        decoration: const BoxDecoration(
                            color: Colors.deepOrangeAccent,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: const Text(
                          "Sign-up",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.to(Login());
                      },
                      child: const Text("Login"))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tec(String hint, TextEditingController controller, bool ispassWord) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(left: 12),
        //   child: Text(
        //     hint,
        //     style: TextStyle(
        //         color: Colors.black.withOpacity(0.7),
        //         fontWeight: FontWeight.w600),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: controller,
            obscureText: ispassWord,
            decoration: InputDecoration(
                hintText: hint, isCollapsed: true, border: InputBorder.none),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Container(
            height: 2,
            color: Colors.grey,
          ),
        )
      ],
    );
  }

  Widget paddBox() {
    return const SizedBox(
      height: 5,
    );
  }
}
