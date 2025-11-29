// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/model/number_model.dart';


class DetailScreen extends StatefulWidget {
   final String storyid;
   final String storyname;
   final String storyothername;
   final String storyimage;
   final String storydes;
   final String storygenres;
   final String urllinkcraw;
   final String storytauthor;
   final String views;

  const DetailScreen({
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
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF393D5E),
      appBar: AppBar(
        backgroundColor: Color(0xFF393D5E),
        title: const Center(
          child: Text(
            "Manhua", 
            style: TextStyle(
              color: Colors.white, 
              fontSize: 24, 
              fontFamily: "Ubuntu", fontWeight: FontWeight.bold))),
      ),
    );
  }
}