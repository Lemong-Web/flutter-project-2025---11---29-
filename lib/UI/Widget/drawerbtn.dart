// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class Drawerbtn extends StatelessWidget {
  final VoidCallback onPressed;
  final String chapNumber;
  
  const Drawerbtn({
    super.key,
    required this.onPressed, 
    required this.chapNumber,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Color(0xff2BFF88),
              Color(0xff2BD2FF),
              Color(0xffFA8BFF)
            ]
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Color(0xFF393D5E),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: ShaderMask(
              shaderCallback: (bound) {
                return LinearGradient(
                  colors: [
                    Color(0xff2BD2FF),
                    Color(0xff2BFF88)
                  ]
                ).createShader(bound);
              },
              child: Text(
                chapNumber, 
                style: TextStyle(
                  color: Colors.white
                )
              ),
            )
          ),
        ),
      ),
    );
  }
}
