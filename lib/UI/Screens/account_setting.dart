import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/UI/Screens/change_password.dart';
import 'package:manga_app/auth_service.dart';

class AccountSetting extends StatefulWidget {
  const AccountSetting({super.key});

  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  
  void logout() async {
    try {
     await authService.value.signOut();
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF393D5E),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF393D5E),
        title: Text(
          "Account Setting",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Inter",
            fontWeight: FontWeight.bold,
          )),
        ),
        body: buildUI(),
          
      );
    }
    Widget buildUI() {
      return ListView(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword()));
            },
            child: ListTile(
              leading: const Icon(Icons.password, color: Colors.black),
              title: const Text("Change Password")
            ),
          ),
          GestureDetector(
            onTap: () {
              logout();
            },
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Log out", style: TextStyle(color: Colors.red))
            ),
          )
        ],
      );
    }
  }