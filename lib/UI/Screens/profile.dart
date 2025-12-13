import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/UI/Screens/account_information.dart';
import 'package:manga_app/UI/Screens/change_password.dart';
import 'package:manga_app/UI/Screens/login_page.dart';
import 'package:manga_app/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void deleteData() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    for(var key in keys) {
      if (key.startsWith('last_read_index_') 
      ||  key.startsWith('favorite_')) {
        await prefs.remove(key);
      }
    }
  }

  void logout() async {
    await authService.value.signOut();
    Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(builder: (context) => const LoginPage()), 
      (route) => false);
    }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF393D5E),
    body: Column(
      children: [
        _buildUITitleandAvatar(),
        const SizedBox(height: 10),
        _buildUIsetting()
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
            padding: const EdgeInsets.only(left: 120),
            child: Row(
              children: [
                Text(
                  'Hello $username',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30
                  )),
                  Icon(Icons.waving_hand, color: Colors.yellow, size: 20),
                ],
              ),
            )
          ],
        );
      }

      Widget _buildUIsetting() {
        return Container(
          height: 260,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey,
          ),
          child: ListView(
            children: ListTile.divideTiles( context: context, tiles: [
                ListTile(
                  onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AccountInformation())),
                  leading: Icon(Icons.info),
                  title: Text('Account Infomation'),
                  trailing: Icon(Icons.arrow_forward),
                ),
                ListTile(
                  onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ChangePassword())),
                  leading: Icon(Icons.password),
                  title: Text('Change Password'),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ListTile(
                onTap: () {
                  logout();
                },
                leading: Icon(Icons.logout),
                title: Text('Log out'),
                trailing: Icon(Icons.arrow_forward),
              ),
              ListTile(
                onTap: () {
                  deleteData();
                  final snackBar = SnackBar(
                  content: const Text("Data deleted succesfuly"),
                  action: SnackBarAction(
                    label: "Ok", 
                    onPressed: () {}
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
                leading: Icon(Icons.folder_off),
                title: Text('Delete Data'),
                trailing: Icon(Icons.arrow_forward),
              ),
            ]
          ).toList()
        )
      );
    }
  }