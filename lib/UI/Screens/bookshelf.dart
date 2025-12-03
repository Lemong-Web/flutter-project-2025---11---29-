// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/model/manga_model.dart';
class Bookshelf extends StatefulWidget {
  const Bookshelf({super.key});

  @override
  State<Bookshelf> createState() => _BookshelfState();
}

class _BookshelfState extends State<Bookshelf> {
  List<MangaModel> mangaList = [];

   @override
  void initState() {
    super.initState();
  }
  
  Future <List<MangaModel>> fetchData() async {
    Dio dio = Dio();
    final response = await dio.get("https://b0ynhanghe0.github.io/comic/home.json"); 
    List<dynamic> body = response.data;
    return body.map((e) {
      return MangaModel.fromJson(e);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF393D5E),
      body: _buildUI(),
    );
  }
  Widget _buildUI() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: AlignmentGeometry.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "BookShelf",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}