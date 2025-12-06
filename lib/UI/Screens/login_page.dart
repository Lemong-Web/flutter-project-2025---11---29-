import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/UI/Screens/sign_up_page.dart';
import 'package:manga_app/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailText = TextEditingController();
  TextEditingController passwordText = TextEditingController();
  bool isCheck = false;
  String errorMessage = '';

  void login() async {
    try {
     await authService.value.signIn(
      email: emailText.text, 
      password: passwordText.text
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? "something gone wrong";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF393D5E),
      body: Column(
        children: [
          _buildUIlogo(),
          _buildUIContainer(),
          const SizedBox(height: 10),
          _buildUIerror(),
          _buildUIbutton(),
          const SizedBox(height: 10),
          _buildUInew()
        ],
      ),
    );
  }

  Widget _buildUIlogo() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 150),
        child: Center(
          child: SizedBox(
            child: Image.asset("assets/img/Comics.png")),
        ),
      ),
    );
  }

  Widget _buildUIContainer() {
    return Padding(
      padding: const EdgeInsets.only(right: 30, left: 30),
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: Colors.grey.withOpacity(0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: emailText,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                  )
                ),
              ),
      
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordText,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                  ) 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUIerror() {
    return Text(
      errorMessage,
      style: TextStyle(color: Colors.red));
  }

  Widget _buildUIbutton() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              checkColor: Colors.amber,
              value: isCheck,
              onChanged: (bool? value){
                setState(() {
                  isCheck = value!;
                });
              }
            ),
            Text("Remember Me")
          ],
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(200, 50),
            backgroundColor: Colors.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(12)
            )
          ),
          onPressed: () {
            setState(() {
              login();
            });
          }, 
          child: Text(
            "Đăng Nhập",
            style: TextStyle(
              color: Colors.blue
            ))
          ),
        ],
      );
    }

  Widget _buildUInew() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: TextStyle(
            color: Colors.white,
          )),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
          },
          child: Text(
            "Sign up",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white
            )),
          )
        ],
      );
    }
  }