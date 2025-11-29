import 'package:flutter/material.dart';
// ignore: camel_case_types
class view extends StatelessWidget {
  final String storyid;
  final String storyname;
  final String storyothername;
  final String storyimage;
  final String storydes;
  final String storygenres;
  final String urllinkcraw;
  final String storytauthor;
  final String views;
  
  const view({
    super.key,
    required this.storyid,
    required this.storyname,
    required this.storyothername,
    required this.storyimage,
    required this.storydes,
    required this.storygenres,
    required this.urllinkcraw,
    required this.storytauthor,
    required this.views,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(12),
          child: Image.network(
            storyimage, 
            width: 90,
            height: 120,
            fit: BoxFit.cover)),
            const SizedBox(height: 6),
            SizedBox(
              height: 40,
              width: 100,
              child: Text(
                storyname,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Ubuntu"
                )
              ),
            ),
          ],
        );
      }
    }