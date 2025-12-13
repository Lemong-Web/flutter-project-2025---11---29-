// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/model/chapter_detail.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
  bool toolBarVisible = true;
  final ScrollController _scrollController = ScrollController();
  double processValue = 0.0;
  late Future<ChapterDetail> _futureStory;

  @override
  void initState() {
    super.initState();
    _futureStory = fetchStory();
    _scrollController.addListener(() {
        processValue = _scrollController.offset / _scrollController.position.maxScrollExtent;
        if (processValue < 0.0) {
          processValue = 0.0;
        } 
        if (processValue > 1.0) {
          processValue = 1.0;
        }
        setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Dio dio = Dio();
  Future <ChapterDetail> fetchStory() async {
    final response = await dio.get("https://b0ynhanghe0.github.io/comic/chapter/${widget.storyID}/${widget.chapterID}");
    final data = response.data;
    return ChapterDetail.fromJson(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      backgroundColor: const Color(0xFF393D5E),
      appBar: AppBar(
        foregroundColor: const Color(0xffffffff),
        backgroundColor: const Color(0xFF393D5E),
        title: Text(""),
      ),
      body: _buildUI()
    );
  }

  Widget _buildUI() {
    return FutureBuilder(
      future: _futureStory, 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          final listDetail = snapshot.data!;
          return Stack(
            children:<Widget>[ 
              CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1),
                          child: Image.network(
                            listDetail.lstImage[index],
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                      childCount: listDetail.lstImage.length
                    )
                  )
                ],
              ),

            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: LinearPercentIndicator(
                lineHeight: 10,
                barRadius: Radius.circular(6),
                percent: processValue,
                backgroundColor: Colors.black,
                progressColor: Colors.pink,
                
              )
            )
          ]
        );
        } else {
          return const Center(child: Text("No data available"));
        }
      }
    );
  }
}