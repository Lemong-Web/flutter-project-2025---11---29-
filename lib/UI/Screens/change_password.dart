import 'package:flutter/material.dart';
import 'package:manga_app/auth_service.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController emailText = TextEditingController();
  TextEditingController currentPasswords = TextEditingController();
  TextEditingController newPasswords = TextEditingController();


  void updatePassword() async {
    try {
      await authService.value.resetPasswordFromCurrentPassword(
        currentPassword: currentPasswords.text, 
        newPassword: newPasswords.text, 
        email: emailText.text);
    } catch (e) {
      print(e);
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
          const SizedBox(height: 20),
          _buildUItitle(),
          _buildUIfield(),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildbtn()
          )
        ],
      ),
    );
  }
  Widget _buildUItitle() {
    return Center(
      child: const Text(
        "Change Password",
        style: TextStyle(
          color: Colors.white,
          fontFamily: "Inter",
          fontWeight: FontWeight.bold,
          fontSize: 25
        )),
      );
    }

    Widget _buildUIfield() {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextFormField(
              controller: emailText,
              decoration: InputDecoration(
                hint: Text("Email"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8)
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            TextFormField(
              controller: currentPasswords,
              decoration: InputDecoration(
                hint: Text("Current Password"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8)
                ),
              ),
            ),

            const SizedBox(height: 10),
            TextFormField(
              controller: newPasswords,
              decoration: InputDecoration(
                hint: Text("New Password"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8)
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildbtn() {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(350, 50),
          backgroundColor: Colors.amber
        ),
        onPressed: () {
          updatePassword();
        }, 
        child: const Text(
          "Change Password",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white
          ))
        );
      }
    }