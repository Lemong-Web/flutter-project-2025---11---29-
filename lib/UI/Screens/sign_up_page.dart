import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manga_app/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerUsername = TextEditingController();
  String errorMessage = "";
  File? _image;
    
  void register() async {
    try {
     await authService.value.createAccount(
      email: controllerEmail.text, 
      password: controllerPassword.text,
    ); 
    final uid = authService.value.currentUser!.uid;
    final db = FirebaseFirestore.instance;
    db.collection("users").doc(uid).set({
      "username": controllerUsername.text,
      "email": controllerEmail.text,
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userID', authService.value.currentUser?.uid ?? '');
    } on FirebaseAuthException {
      setState(() {
        errorMessage = "Có lỗi trong khi tạo tài khoản, vui lòng thử lại";
      });
    }
  }

  void selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery);
      if (image == null) return;
      setState(() {
        _image = File(image.path);
      });
    }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFF393D5E),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF393D5E),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom
          ),
          child: Column(
            children: [
              _buildUItitle(),
              const SizedBox(height: 10),
              _profileImage(),
              const SizedBox(height: 10),
              _buildEmail(),
              const SizedBox(height: 10),
              _buildUsername(),
              const SizedBox(height: 10),
              _buildPass(),
              const SizedBox(height: 5),
              _buildErrorMes(),
              const SizedBox(height: 20),
              _buildbtn()
            ],
          ),
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
              "Tạo tài khoản",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30
              )),
          ),
      
          SizedBox(
            height: 50,
            width: 300,
            child: Text(
              "Điền tên người dùng, email và mật khẩu để tạo tài khoản.",
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
            hint: Text(
              "Email", 
              style: TextStyle(color: Colors.white)),
            ),
          ),
        );
      }
      

      Widget _buildPass() {
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: TextFormField(
            validator: (val) => val!.length < 6 ? "Mật khẩu quá ngắn" : null,
            controller: controllerPassword,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hint: Text(
                "Mật khẩu",
                style: TextStyle(color: Colors.white))
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
            controllerEmail.clear();
            controllerUsername.clear();
            controllerPassword.clear();
            register();
            // Navigator.pop(context);
          }, 
          child: Text(
            "Đăng ký",
            style: TextStyle(
               fontSize: 20,
               color: Colors.black
            ))
          );
        }

        Widget _profileImage() {
          return Stack(
            children: [
              CircleAvatar(
                radius: 64,
                backgroundImage: (_image == null) 
                  ? NetworkImage(
                  'https://as2.ftcdn.net/jpg/04/62/63/65/1000_F_462636502_9cDAYuyVvBY4qYJlHjW7vqar5HYS8h8x.jpg')
                  // as ImageProvider vì dụ nếu dùng FileImage thì nó sẽ không nhận NetworkImage vì khác kiểu dữ liệu
                  // Phải dùng as ImgProvider vì nó yêu cầu cả 2 nhánh có cùng 1 kiểu, ép kiểu giúp cả 2 nhánh về cùng 1 type
                  : FileImage(_image!) as ImageProvider
                ),
              Positioned(
                bottom: -10,
                right: 0,
                child: IconButton(
                  onPressed: () {
                    selectImage();
                  }, 
                  icon: Icon(Icons.add_a_photo, color: Colors.black)
                )
              )
            ],
          );
        }
        Widget _buildUsername() {
          return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: TextFormField(
            controller: controllerUsername,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hint: Text(
                "Tên người dùng",
                style: TextStyle(color: Colors.white))
              )
            ),
          );
        }
      }