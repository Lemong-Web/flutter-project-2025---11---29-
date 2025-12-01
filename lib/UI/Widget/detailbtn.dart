import 'package:flutter/material.dart';

class Detailbtn extends StatelessWidget {
  final VoidCallback onPressed;
  
  const Detailbtn({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff2BD2FF),
              Color(0xff2BFF88)
            ]
          ),
          borderRadius: BorderRadius.circular(12)
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Color(0xFF393D5E)
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [
                     Color(0xff2BD2FF),
                     Color(0xff2BFF88)
                  ]
                ).createShader(bounds);
              },
              child: const Text(
                "READ",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Inter"
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}