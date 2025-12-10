import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/UI/Screens/account_setting.dart';
import 'package:manga_app/auth_service.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String username = '';
  
  
  @override
  void initState() {
    super.initState();
    loadUsername();
  }

  Future<String?> fetchUsername() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get();

    if(snapshot.exists) {
      return snapshot.data()?['username'];
    }
    return null;
  }

    void loadUsername() async {
      final name = await fetchUsername();
      setState(() {
        username = name ?? '';
      });
    }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF393D5E),
    body: Column(
      children: [
        _buildUITitleandAvatar(),
        
      ],
    ),
  );
}

Widget _buildUITitleandAvatar() {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: const Text(
              "Profile",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Inter",
                fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 10),
          CircleAvatar(
            backgroundColor: Colors.black,
            radius: 60,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Row(
              children: [
                Icon(Icons.waving_hand, color: Colors.yellow, size: 20),
                Text(
                  'Hello $username',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30
                  ))
              ],
            ),
          )
        ],
      );
    }
  }