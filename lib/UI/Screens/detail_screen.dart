// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/UI/Screens/reading_screen.dart';
import 'package:manga_app/UI/Widget/detailbtn.dart';
import 'package:manga_app/model/number_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late String firstHalf;
  late String secondHalf;
  bool isExpanded = false;
  bool lastStatus = false;
  bool needWarp = true;
  int? lastIndex;
  late Future<NumberModel> chapters;

  Dio dio = Dio();
  Future<NumberModel> fetchChapters() async {
    final response = await dio.get(
      "https://b0ynhanghe0.github.io/comic/chapter/${widget.storyid}/listchapter.json",
    );
    final data = response.data;
    return NumberModel.fromJson(data);
  }

  void saveLastIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('userID') ?? '';
    await prefs.setInt("last_read_index_${uid}_${widget.storyid}", index);
  }

  void loadLastIndex() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('userID') ?? '';
    setState(() {
      lastIndex = prefs.getInt("last_read_index_${uid}_${widget.storyid}");
    });
  }

  void saveStatus(String storyId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('userID') ?? '';
    setState(() {
      lastStatus = !lastStatus;
    });
    await prefs.setBool("favorite_${uid}_$storyId", lastStatus);
  }

  void loadStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('userID') ?? '';
    setState(() {
      lastStatus = prefs.getBool("favorite_${uid}_${widget.storyid}") ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    chapters = fetchChapters();
    if(widget.storydes.length > 200){
      firstHalf =  widget.storydes.substring(0, 190);
      secondHalf = widget.storydes.substring(191, widget.storydes.length);
    } else {
      firstHalf = widget.storydes;
      secondHalf = "";
      needWarp = false;
    }
    loadLastIndex();
    loadStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF393D5E),
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: Color(0xFF393D5E),
        title: Center(
          child: Row(
            children: [
              const SizedBox(width: 100),
              Text(
                "Manhua",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: "Ubuntu",
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  saveStatus(widget.storyid);
                },
                icon: Icon(
                  Icons.favorite,
                  color: lastStatus ? Colors.red : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),

      body: FutureBuilder(
        future: chapters,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error ${snapshot.error}"));
          } else if (snapshot.hasData) {
            List<NumberModel> chapters = [snapshot.data!];
            final chapterlist = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildUIwallpaper(),
                  const SizedBox(height: 10),
                  _buildUIdetail(chapters),
                  const SizedBox(height: 5),
                  _buildUIlist(chapters, chapterlist),
                  _continue(chapterlist),
                  const SizedBox(height: 15)
                ],
              ),
            );
          } else {
            return const Center(child: Text("No data found"));
          }
        },
      ),
    );
  }

  Widget _buildUIwallpaper() {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(18),
        child: Image.asset("assets/img/placeholder.jpg", fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildUIdetail(List<NumberModel> chapters) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.storyname,
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Inter",
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(
                  "${widget.views} Views - ",
                  style: TextStyle(
                    color: Color(0xffABACB6),
                    fontFamily: "Inter",
                  ),
                ),
                Text(
                  "${chapters[0].totalChapters} Chapters",
                  style: TextStyle(
                    color: Color(0xffABACB6),
                    fontFamily: "Inter",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "Synopsis",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Inter",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            AnimatedSize(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: SizedBox(
                width: 350,
                // ignore: unrelated_type_equality_checks
                child: secondHalf.length == "" 
                  ? Text(widget.storydes, style: TextStyle(color: Colors.grey, fontFamily: 'Inter'))
                  : Column(
                   children: [
                     Text(
                        isExpanded 
                        ? widget.storydes 
                        : firstHalf, style: TextStyle(color: Colors.grey, fontFamily: 'Inter')),
                     IconButton(
                      onPressed: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      }, 
                      icon: needWarp 
                      ? Icon( 
                        isExpanded 
                          ? Icons.arrow_upward
                          : Icons.arrow_downward, color: Colors.white)
                      : SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

  Widget _buildUIlist(List<NumberModel> chapters, chapterlist) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Color(0xffFFFFFF).withOpacity(0.2),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: chapterlist.chapters.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: ShaderMask(
              shaderCallback: (bound) {
                return LinearGradient(
                  colors: [Color(0xff2BD2FF), Color(0xff2BFF88)],
                ).createShader(bound);
              },
              child: Text(
                "Chapter ${chapterlist.chapters[index].replaceAll('.json', '')}",
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "Inter",
                ),
              ),
            ),
            trailing: Detailbtn(
              onPressed: () async {
                saveLastIndex(index);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReadingScreen(
                      storyID: widget.storyid,
                      chapterID: chapterlist.chapters[index],
                      initalPage: index,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _continue(NumberModel chapterlist) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(color: const Color(0xFF393D5E)),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [Color(0xff9D00FF), Color(0xffc11c84)],
            ),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReadingScreen(
                    storyID: widget.storyid,
                    chapterID: lastIndex == null
                      ? chapterlist.chapters[0]
                      : chapterlist.chapters[lastIndex!],
                    initalPage: 0,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.pinkAccent,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    lastIndex == null
                        ? "Bắt đâu đọc chuyện"
                        : "Đọc tiếp từ chương: $lastIndex",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}