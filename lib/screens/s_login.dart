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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            t_g("Enter Your Email", _email),
            const SizedBox(
              height: 20,
            ),
            t_g("Enter Your Password", _password),
            const SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () {
                  Auth().signIn(_email.text, _password.text);
                },
                child: const Text("Login"))
          ],
        ),
      ),
    );
  }

  Widget t_g(String hint, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(
            color: Colors.grey.withOpacity(1),
          )),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: hint, border: InputBorder.none),
      ),
    );
  }
}
