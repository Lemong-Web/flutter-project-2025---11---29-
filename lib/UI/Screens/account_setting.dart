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
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF393D5E),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF393D5E),
        foregroundColor: Colors.white,
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
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          height: 400,
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12)
          ),
          child: ListView(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword()));
                },
                child: ListTile(
                  leading: const Icon(Icons.password, color: Colors.black),
                  title: const Text(
                    "Change Password",
                    style: TextStyle(
                      fontSize: 15
                    )),
                    trailing: Icon(Icons.arrow_forward_ios, size: 15),
                ),
              ),

              GestureDetector(
                onTap: () {
                  logout();
                  Navigator.pop(context);
                },
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    "Log out", 
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 15)),
                      trailing: Icon(Icons.arrow_forward_ios, size: 15),
                ),
              ),
                GestureDetector(
                onTap: () {

                },
                child: ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text(
                    "Delete Account",
                    style: TextStyle(
                      color: Colors.red
                  )),
                  trailing: Icon(Icons.arrow_forward_ios, size: 15),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }