import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountInformation extends StatefulWidget {
  const AccountInformation({super.key});

  @override
  State<AccountInformation> createState() => _AccountInformationState();
}

class _AccountInformationState extends State<AccountInformation> {
  String email = '';
  String username = '';
  
  Future<String?> fetchEmail() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
     .collection('users')
     .doc(uid)
     .get();
     if (snapshot.exists) {
      return snapshot.data()?['email'];
    }
    return null;
  }

  void loadEmail() async {
    String? accountEmail = await fetchEmail();
    setState(() {
      email = accountEmail ?? '';
    });
  }

  Future<String?> fetchUsername() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
     .collection('users')
     .doc(uid)
     .get();
     if (snapshot.exists) {
      return snapshot.data()?['username'];
    }
    return null;
  }

  void loadUsername() async {
    String? name = await fetchUsername();
    setState(() {
      username = name ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    loadEmail();
    loadUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF393D5E),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF393D5E),
        centerTitle: true,
        title: const Text(
          "Infomation",
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold)),
          ),
          body: _buildUI(),
        );
      }

      Widget _buildUI() {
        return Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Email: $email",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18)),
              const SizedBox(height: 10),
              Text(
                "Username: $username",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18))
                ],
              ),
            );
          }
        }