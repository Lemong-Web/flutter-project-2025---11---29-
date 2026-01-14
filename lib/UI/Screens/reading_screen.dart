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
  bool nextChap = false;
  bool loadNextChap = false;
  bool runOutofChap = false;
  bool chapterOne = false;
  final ScrollController _scrollController = ScrollController();
  double processValue = 0.0;
  late Future<ChapterDetail> _futureStory;
  late Future<NumberModel> listchapter;
  Timer? _hideTimer;
  late int currentChapter;
  List<String> chapters = [];
  // ignore: non_constant_identifier_names
  bool chapter_loaded = false;
  bool isLoadingChapter = false;
  
  
    
  void _showAppBarTemp() {
    setState(() {
      doubleTap = !doubleTap;
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

  String? getNextChapter() {
    if (!chapter_loaded) return null;

    final index = chapters.indexOf(widget.chapterID);
    if(index == -1 || index + 1 >= chapters.length) return null;
    if(index == chapters.length) {
      setState(() {
        runOutofChap = true;
      });
    }

    return chapters[index + 1];
  }

  void goNext() {
    final goNextChap = getNextChapter();
    if (goNextChap == null) return;

    Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => ReadingScreen(
        storyID: widget.storyID, 
        chapterID: goNextChap, 
        initalPage: 0)));
    }
  
  String? previousChapter() {
    if(!chapter_loaded) return null;

    final index = chapters.indexOf(widget.chapterID);
    if(index == - 1 || index - 1 <= -1) return null;
    if (index == 0) {
      setState(() => chapterOne = true);
    }

    return chapters[index - 1];
  }

  void goBack() {
    final goBackChap = previousChapter();
    if (goBackChap == null) return;

    Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => ReadingScreen(
        storyID: widget.storyID, 
        chapterID: goBackChap, 
        initalPage: 0)));
    }
  

  @override
  void dispose() {
    _hideTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _futureStory = fetchStory();
    listchapter = fetchListChapters();

    fetchListChapters().then((data) {
      if (!mounted) return;
      setState(() {
        chapters = data.chapters;
        chapter_loaded = true;
      });
    });

     _scrollController.addListener(() {
        processValue = _scrollController.offset / _scrollController.position.maxScrollExtent;
        if (processValue < 0.0) {
          processValue = 0.0;
        } 
        if (processValue > 1.0) {
          processValue = 1.0;
        }
        setState(() {});

        if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent + 100 && !loadNextChap) {
          setState(() => loadNextChap = true);

          Future.delayed(const Duration(seconds: 2), () {
            if(!mounted) return;
            goNext();

            if (!mounted) return;
            setState(() {
              loadNextChap = false;
            });
          });
        } 
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
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF393D5E),
      appBar: doubleTap 
        ? AppBar(
          automaticallyImplyLeading: true,
          title: FutureBuilder(
            future: listchapter, 
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("Có lỗi");
              } if (snapshot.hasData) {
                final chapters = snapshot.data!.chapters;
                final currentIndex = chapters.indexOf(widget.chapterID);
                return Text("Chương $currentIndex");
              } else {
                return const Text("Có lỗi");
              }
            }
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context), 
            icon: Icon(Icons.arrow_back)),
          foregroundColor: const Color(0xffffffff),
          // ignore: deprecated_member_use
          backgroundColor: Color(0xFF393D5E).withOpacity(0.3),
          elevation: 0,
        )
        : null,

      bottomNavigationBar: doubleTap
        ? BottomAppBar(
          height: 40,
          // ignore: deprecated_member_use
          color: Color(0xFF393D5E).withOpacity(0.3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              chapterOne 
                ? const SizedBox.shrink()
                : GestureDetector(
                    onTap: () {
                      goBack();
                    },
                    child: Icon(Icons.arrow_back),
                  ),

              runOutofChap
                ? const SizedBox.shrink()
                : GestureDetector(
                    onTap: () {
                      goNext();
                    },
                    child: Icon(Icons.arrow_forward),
                  )
              ],
            ),
          )
        : const SizedBox.shrink(),


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
              return ListView.builder(
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
                  physics: const AlwaysScrollableScrollPhysics (
                    parent: BouncingScrollPhysics() 
                  ),
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Padding (
                            padding: const EdgeInsets.symmetric(vertical: 1),
                            child: Image.network(
                              listDetail.lstImage[index],
                              fit: BoxFit.contain,
                            ),
                          );
                        },
                        childCount: listDetail.lstImage.length
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: loadNextChap 
                      ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                      : const SizedBox.shrink()
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