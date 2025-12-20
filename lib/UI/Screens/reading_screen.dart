// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/UI/Widget/drawerbtn.dart';
import 'package:manga_app/model/chapter_detail.dart';
import 'package:manga_app/model/number_model.dart';
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
  bool doubleTap = false;
  final ScrollController _scrollController = ScrollController();
  double processValue = 0.0;
  late Future<ChapterDetail> _futureStory;
  late Future<NumberModel> listchapter;
  Timer? _hideTimer;
  
  void _showAppBarTemp() {
    setState(() {
      doubleTap = true;
    });

    _hideTimer?.cancel();

    _hideTimer = Timer( const Duration(seconds: 6), () {
      if (mounted) {
        setState(() {
          doubleTap = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    _futureStory = fetchStory();
    listchapter = fetchListChapters();
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


  Dio dio = Dio();
  Future <ChapterDetail> fetchStory() async {
    final response = await dio.get("https://b0ynhanghe0.github.io/comic/chapter/${widget.storyID}/${widget.chapterID}");
    final data = response.data;
    return ChapterDetail.fromJson(data);
  }

  Future<NumberModel> fetchListChapters() async {
    final response = await dio.get(
      "https://b0ynhanghe0.github.io/comic/chapter/${widget.storyID}/listchapter.json",
    );
    final data = response.data;
    return NumberModel.fromJson(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF393D5E),
      appBar: doubleTap 
        ? AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context), 
            icon: Icon(Icons.arrow_back)),
          foregroundColor: const Color(0xffffffff),
          // ignore: deprecated_member_use
          backgroundColor: Color(0xFF393D5E).withOpacity(0.3),
          elevation: 0,
        )
        : null,

      body: _buildUI(),
      endDrawer: Drawer(
        backgroundColor: const Color(0xFF393D5E),
        width: 240,
        shape: BeveledRectangleBorder(),
        child: FutureBuilder(
          future: listchapter, 
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              final listChapters = snapshot.data!;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount (
                  crossAxisCount: 2,
                  mainAxisExtent: 50
                ),
                  itemCount: listChapters.chapters.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(10),
                      child: Drawerbtn(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => ReadingScreen(
                                storyID: widget.storyID, 
                                chapterID: listChapters.chapters[index],
                                initalPage: 0)));
                              }, 
                              chapNumber: 'Chap ${listChapters.chapters[index].replaceAll('json', '')}'
                            ),
                          );
                        } 
                      );
                    } else {
                      return const Center(child: Text("Failed to load the list"));
                    } 
                  }
                )
              ),
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
              GestureDetector(
                onDoubleTap: _showAppBarTemp,
                child: CustomScrollView(
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
                progressColor: Colors.blue
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