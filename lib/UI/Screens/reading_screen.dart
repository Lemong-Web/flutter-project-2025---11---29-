// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/model/chapter_detail.dart';

class ReadingScreen extends StatefulWidget {
  final String storyID;
  final String chapterID;
  final int initalPage;

  const ReadingScreen({
    super.key,
    required this.storyID,
    required this.chapterID,
    required this.initalPage,
  });

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {

  @override
  void initState() {
    super.initState();
  }

  Dio dio = Dio();
  Future <ChapterDetail> fetchDetail() async {
    final response = await dio.get("https://b0ynhanghe0.github.io/comic/chapter/${widget.storyID}/${widget.chapterID}");
    final data = response.data;
    return ChapterDetail.fromJson(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF393D5E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF393D5E),
        title: Text(""),
      ),
      body: FutureBuilder(
        future: fetchDetail(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error ${snapshot.error}"));
          } else if (snapshot.hasData) {
            List<ChapterDetail> detail = [snapshot.data!];
            final listDetail = snapshot.data!;
            return _buildUI(detail, listDetail);
          } else {
            return const Center(child: Text("Data not found"));
          }
        }
      )
    );
  }
  Widget _buildUI(List<ChapterDetail> detail, listDetail) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: listDetail.lstImage.length,
      itemBuilder: (context, index) {
        return Center(
          child: Image.network(listDetail.lstImage[index]),
        );
      },
    );
  }
}