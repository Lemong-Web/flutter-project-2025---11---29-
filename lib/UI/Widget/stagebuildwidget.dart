// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class Stagebuildwidget extends StatelessWidget {
  final String imgUrl;
  final String desc;
  final String title;
  
  const Stagebuildwidget({
    super.key,
    required this.imgUrl,
    required this.desc,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(12)
            ),
            margin: const EdgeInsets.only(top: 20),
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(12),
              child: Image.asset(imgUrl, fit: BoxFit.cover)),
          ),

          const SizedBox(height: 20),
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [
                  Color(0xff2BFF88),
                  Color(0xff2BD2FF),
                  Color(0xffFA8BFF)
                ]
              ).createShader(bounds);
            },
            child: Text(
              title,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Ubuntu'
              )),
            ),
          
          const SizedBox(height: 10), 
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [
                  Color(0xff2BFF88),
                  Color(0xff2BD2FF),
                  Color(0xffFA8BFF)
                ]
              ).createShader(bounds);
            },
            child: Text(
              desc,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Ubuntu'
              )),
            )
          ],
        ),
      );
    }
  }
