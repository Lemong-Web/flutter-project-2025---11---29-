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
  bool _progressController = false;


  void updatePassword() async {
    try {
      setState(() {
        _progressController = true;
      });
      await authService.value.resetPasswordFromCurrentPassword(
        currentPassword: currentPasswords.text, 
        newPassword: newPasswords.text
        );
        setState(() {
          _progressController = false;
        });
        if(mounted) {
          showDialog(
            context: context, 
            builder: (context) {
              return AlertDialog(
                title: const Text("Thành Công"),
                content: const Text("Đổi mật khẩu thành công"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    child: const Text("Ok")
                  )
                ],
              );
            });
        }
    } catch (e) {
      if(mounted) {
        setState(() {
          _progressController = false;
        });
        showDialog(
          context: context, 
          builder: (context) {
            return AlertDialog(
              title: const Text("Lỗi"),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, 
                  child: const Text("Ok")
                )
              ],
            );
          }
        );
      }
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF393D5E),
      appBar: AppBar(
        backgroundColor: Color(0xFF393D5E),
        foregroundColor: Colors.white,
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
        "Đổi mật khẩu",
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
            const SizedBox(height: 10),
            TextFormField(
              controller: currentPasswords,
              textInputAction: TextInputAction.next,
              style: TextStyle(
                color: Colors.white
              ),
              decoration: InputDecoration(
                label: Text(
                  "Mật khẩu hiện tại",
                  style: TextStyle(
                    color: Colors.white
                )),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 15),
            TextFormField(
              controller: newPasswords,
              textInputAction: TextInputAction.done,
              style: TextStyle(
                color: Colors.white
              ),
              decoration: InputDecoration(
                label: Text(
                  "Mật khẩu mới",
                  style: TextStyle(
                    color: Colors.white                  
                 )),
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
        child: _progressController 
          ? CircularProgressIndicator(
            color: Colors.black
          )
          : Text(
          "Đổi mật khẩu",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ))
        ); 
      }
    }