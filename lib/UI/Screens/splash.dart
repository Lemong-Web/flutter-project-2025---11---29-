import 'dart:async';
import 'package:flutter/material.dart';
import 'package:manga_app/UI/Screens/navigation.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

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
          MaterialPageRoute(builder: (context) => Navigation())
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
            "VERSION 0.0.1",
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