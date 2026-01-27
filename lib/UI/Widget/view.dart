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
        Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                Color(0xffFA8BFF),
                Color(0xff2BD2FF)
              ]
            )
          ),
          child: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(12),
            child: Image.network(
              storyimage, 
              width: 90,
              height: 120,
              fit: BoxFit.cover
            )
          ),
        ),

        const SizedBox(height: 6),

        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: SizedBox(
            height: 40,
            width: 90,
            child: Text(
              storyname,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: "Ubuntu"
              )
            ),
          ),
        ),
      ],
    );
  }
}