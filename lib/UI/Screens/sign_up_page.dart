import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  String errorMessage = "";
  
  void register() async {
    try {
     await authService.value.createAccount(
      email: controllerEmail.text, 
      password: controllerPassword.text
    ); 
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? "There is an error";
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF393D5E),
      appBar: AppBar(
        backgroundColor: Color(0xFF393D5E),
        ),
        body: Column(
          children: [
            _buildUItitle(),
            const SizedBox(height: 10),
            _buildEmail(),
            const SizedBox(height: 10),
            _buildPass(),
            const SizedBox(height: 5),
            _buildErrorMes(),
            const SizedBox(height: 20),
            _buildbtn()
          ],
        ),
      );
    }
    Widget _buildUItitle() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (bound) {
              return LinearGradient(
                colors: [
                  Color(0xff2BFF88),
                  Color(0xff2BD2FF),
                  Color(0xffFA8BFF)
                ]
              ).createShader(bound);
            },
            child: Text(
              "Create Account",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30
              )),
          ),
      
          SizedBox(
            height: 50,
            width: 300,
            child: Text(
              "Enter you username, email and password to sign up",
              style: TextStyle(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.4),
                fontSize: 15
              )),
            )
          ],
        );
      }
      
      Widget _buildEmail() {
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: TextFormField(
            controller: controllerEmail,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hint: Text("Email")
            ),
          ),
        );
      }
      Widget _buildPass() {
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: TextFormField(
            controller: controllerPassword,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hint: Text("Password")
            )
          ),
        );
      }
      Widget _buildErrorMes() {
        return Text(
          errorMessage,
          style: TextStyle(color: Colors.redAccent), 
        );
      }
      Widget _buildbtn() {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(340, 50)
          ),
          onPressed: () async {
            register();
          }, 
          child: Text(
            "Sign in",
            style: TextStyle(
               fontSize: 20,
               color: Colors.black
            ))
          );
        }
      }