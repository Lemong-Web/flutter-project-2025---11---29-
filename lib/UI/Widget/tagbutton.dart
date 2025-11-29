// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class Tagbutton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  
  const Tagbutton({
    super.key,
    required this.text,
    required this.onPressed,
  });

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
              Color(0xff2BE9C3),
              Color(0xff2BFF88)
            ]
          ),
          borderRadius: BorderRadius.circular(18)
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF393D5E),
            borderRadius: BorderRadius.circular(18)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ShaderMask(
              shaderCallback: (bound) {
                return LinearGradient(
                  colors: [
                    Color(0xff2BD2FF),
                    Color(0xff2BE9C3),
                    Color(0xff2BFF88)
                  ]
                ).createShader(bound);
              },
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
