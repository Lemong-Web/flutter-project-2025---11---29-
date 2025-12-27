// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:manga_app/UI/Screens/auth_layout.dart';

class Splash extends StatefulWidget {

  const Splash({
    super.key,
  });

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => AuthLayout())
        );
      });
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF393D5E),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Stack(
      children: [
        Center(child: Image.asset("assets/img/Comics.png")),
        Positioned(
          bottom: 50,
          left: 155,
          child: const Text (
            "VERSION 0.0.8",
            style: TextStyle (
              color: Colors.white,
              fontSize: 15
            ),
          ),
        )
      ],
    );
  }
}