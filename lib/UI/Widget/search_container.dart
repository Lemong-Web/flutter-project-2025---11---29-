import 'package:flutter/material.dart';

class SearchContainer extends StatelessWidget {
  final Image image;

  const SearchContainer({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Color(0xff2BD2FF),
              Color(0xff2BFF88)
            ]
          )
        ),
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(12),
          child: image
        ),
      ),
    );
  }
}