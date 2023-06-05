import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login(String email, String password) async {
    try {
      Response response = await post(
          Uri.parse('https://reqres.in/api/login'),
          body: {
            'email': email,
            'password': password,
          }
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print('Login Successfull!');
        print(data['token']);
      } else {
        print('Failed');
      }
    } catch (e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login API"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                  hintText: "Email"
              ),
            ),

            const SizedBox(height: 20,),
            TextFormField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                  hintText: "Password"
              ),
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              onTap: () {
                login(emailController.text.toString(),
                    passwordController.text.toString());
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(child: Text("Login")),
              ),
            )

          ],
        ),
      ),
    );
  }
}
