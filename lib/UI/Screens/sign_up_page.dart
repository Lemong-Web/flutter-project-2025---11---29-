import 'dart:async';
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
  bool hidePass = true;
  bool hideWord = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerConfirmPass = TextEditingController();
  TextEditingController controllerUsername = TextEditingController();
  String errorMessage = "";
  File? _image;
  FocusNode textSecondFocusNode = FocusNode();
    
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
  
  void handleTimer() {
    setState(() {
      hideWord =! hideWord;
    });
  }

  @override
  void dispose() {
    super.dispose();
    controllerEmail.dispose();
    controllerPassword.dispose();
    controllerConfirmPass.dispose();
    controllerUsername.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF393D5E),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF393D5E),
        ),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              children: [
                _buildUItitle(),
                const SizedBox(height: 10),
                _profileImage(),
                const SizedBox(height: 10),
                _buildFormField(),
                const SizedBox(height: 10),
                _buildErrorMes(),
                _buildbtn(),
                const SizedBox(height: 20),
              ],
            ),
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
            if (_formKey.currentState!.validate()) {
              register();
            }
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

      Widget _buildFormField() {
        return Form(    
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
             Builder(
              builder: (fieldContext) {
                return TextFormField(
                  onTap: () {
                    Scrollable.ensureVisible(
                      fieldContext,
                      alignment: 0.5,
                      duration: Duration(milliseconds: 300)
                    );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Trường email còn trống';
                    }
                    return null;
                  },
                  style: TextStyle(
                    color: Colors.white
                  ),
                  textInputAction: TextInputAction.next,
                  controller: controllerEmail,
                  decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  // ignore: deprecated_member_use
                  prefixIconColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(),
                  labelText: "Email",
                  labelStyle: TextStyle(
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.2))
                  )
                );
              }
             ),
              
            const SizedBox(height: 20),
             TextFormField(
               onTap: () {
              },
              style: TextStyle(
                color: Colors.white
              ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tên người dùng còn thiếu';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                controller: controllerUsername,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  // ignore: deprecated_member_use
                  prefixIconColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(),
                  labelText: "Tên người dùng",
                  labelStyle: TextStyle(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.2))
                )
              ),
              
              const SizedBox(height: 20),
              TextFormField(
                obscureText: hidePass ? true : false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Trường mật khẩu còn trống';
                  }
                  return null;
                },
                style: TextStyle(
                  color: Colors.white
                ),
                onFieldSubmitted: (String val) {
                  FocusScope.of(context).requestFocus(textSecondFocusNode);
                },
                textInputAction: TextInputAction.next,
                controller: controllerPassword,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePass = !hidePass;
                      });
                    }, 
                    icon: hidePass ? Icon(Icons.visibility_off) : Icon(Icons.visibility)
                  ),
                  // ignore: deprecated_member_use
                  suffixIconColor: Colors.white.withOpacity(0.2),
                  prefixIcon: Icon(Icons.lock),
                  // ignore: deprecated_member_use
                  prefixIconColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(),
                  labelText: "Mật khẩu",
                  labelStyle: TextStyle(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.2))
                )
              ),

            const SizedBox(height: 20),
            
            TextFormField(
              obscureText: hidePass ? true : false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng xác nhận lại mật khẩu';
                } if (value !=  controllerPassword.text) {
                  return 'Mật khẩu không trùng khớp';
                }
                return null;  
              },
              style: TextStyle(
                color: Colors.white
              ),
              focusNode: textSecondFocusNode,
              textInputAction: TextInputAction.done,
              controller: controllerConfirmPass,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      hidePass = !hidePass;
                    });
                  }, 
                  icon: hidePass ? Icon(Icons.visibility_off) : Icon(Icons.visibility)
                ),
                // ignore: deprecated_member_use
                suffixIconColor: Colors.white.withOpacity(0.2),
                prefixIcon: Icon(Icons.lock),
                // ignore: deprecated_member_use
                prefixIconColor: Colors.white.withOpacity(0.2),
                border: OutlineInputBorder(),
                labelText: "Xác nhận mật khẩu",
                labelStyle: TextStyle(
                // ignore: deprecated_member_use
                 color: Colors.white.withOpacity(0.2))
              )
            ),
            const SizedBox(height: 5),
          ],
        )
      );
    }
  }