import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountInformation extends StatefulWidget {
  const AccountInformation({super.key});

  @override
  State<AccountInformation> createState() => _AccountInformationState();
}

class _AccountInformationState extends State<AccountInformation> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _username = TextEditingController();
  late Future<String?> emailFunct;
  late Future<String?> usernameFunct;
  String _nickname = "";
  String? _selectedValue;
  
  
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

  Future<void> loadEmail() async {
    String? accountEmail = await fetchEmail();
    setState(() {
      _email.text = accountEmail ?? "";
    });
  }

  Future<String?> fetchDate() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get();
      if (snapshot.exists) {
        return snapshot.data()?['createdAt'];
      }
      return null;
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

  Future<void> loadUsername() async {
    String? name = await fetchUsername();
    setState(() {
      _username.text = name ?? '';
    });
  }

  Future<String?> fetchNickname() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get();
      if (snapshot.exists) {
        return snapshot.data()?['nickname'];
      }
    return null;
  }

  Future<void> loadNickname() async {
    String? nickname = await fetchNickname();
    setState(() {
      _nickname = nickname ?? "";
    });
  }

  Future<void> updateUsername() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .update({'username': _username.text});
    }

  Future<void> updateNickname() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .update({'nickname': _selectedValue});
  }

  @override
  void initState() {
    super.initState();
    loadEmail();
    loadUsername();
    loadNickname();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(        
        centerTitle: true,
        title: const Text(
          "Thông tin tài khoản",
          style: TextStyle(
            fontWeight: FontWeight.bold)),
          ),
          body: _buildUI(),
        );
      }

    Widget _buildUI() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            child: const Text(
              "Email",
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            child: TextFormField(
              controller: _email,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8)
                )
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              "Tên người dùng",
              style: TextStyle (
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextFormField(
                    controller: _username,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)
                      )
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(65, 52),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                    )
                  ),
                  onPressed: () {
                    updateUsername();
                  }, 
                  child: const Icon(Icons.edit)
                ),
              )
            ],
          ),
          
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              "Biệt danh",
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
          ),

          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: _nickname.isNotEmpty ? _nickname : "Chọn biệt danh",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)
                      )
                    ),
                    initialValue: _selectedValue,
                    items: ["Huyết Kiếm", "Mê Manhua", "Đạo Sĩ Trẻ", "Thiên Ma", "Vô Danh", "Bánh Bao", "Mê Truyện Tàu"]
                      .map((value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
                      .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value;
                      });
                    }
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(65, 52),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                    )
                  ),
                  onPressed: () {
                    updateNickname();
                  }, 
                  child: const Icon(Icons.edit)
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              "Ngày tạo tài khoản",
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ],
      );
    }
  }