import 'package:flutter/material.dart';
import 'package:pr301s/Firebase/login.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              border: Border.all(width: 1, color: Colors.black)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "File Tracking System",
                  style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                tec("Email", _email, false),
                const SizedBox(
                  height: 10,
                ),
                tec("Password", _password, true),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: () {
                      Auth().signIn(_email.text, _password.text);
                    },
                    child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            border: Border.all(
                              color: Colors.deepOrange,
                            ),
                            borderRadius: BorderRadius.circular(20)),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 20),
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tec(String hint, TextEditingController controller, bool ispassWord) {
    return TextField(
      controller: controller,
      obscureText: ispassWord,
      decoration: InputDecoration(
        labelText: hint,
        hintText: hint,
        border: OutlineInputBorder(
            borderSide:
                BorderSide(width: 2, color: Colors.grey.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.blue),
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
