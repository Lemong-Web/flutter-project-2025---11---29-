// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/UI/Screens/detail_tabbar.dart';
import 'package:manga_app/UI/Screens/reading_screen.dart';
import 'package:manga_app/UI/Widget/detailbtn.dart';
import 'package:manga_app/model/number_model.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';
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

  void shareManhua() {
    final String shareLink = widget.urllinkcraw;
    // ignore: deprecated_member_use
    Share.share(shareLink);
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
    return FutureBuilder(
      future: chapters,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: const CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<NumberModel> chapters = [snapshot.data!];
          final listchapter = snapshot.data!;
          return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Center(
              child: Row(
                children: [
                  Text(
                    "Manhua",
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: "Ubuntu",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  IconButton( 
                    onPressed: () {
                      shareManhua();
                  }, icon: Icon(Icons.share)),
                  IconButton(
                    onPressed: () {
                      saveStatus(widget.storyid);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          action: SnackBarAction(
                            label: "Ok",
                            onPressed: () {}
                          ),
                          content: Text(lastStatus 
                            ? "Truyện đã được xóa khỏi danh sách"
                            : "Truyện đã được lưu vào danh sách"),
                           duration: const Duration(milliseconds: 1500
                          ),
                           width: 350.0,
                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
                           behavior: SnackBarBehavior.floating,
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        )
                      );
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildUIwallpaper(),
                const SizedBox(height: 10),
                _buildUIdetail(chapters),
                const SizedBox(height: 5),
                _buildUIlist(chapters, listchapter),
              ],
            ),
          ),
          bottomNavigationBar: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReadingScreen(
                    storyID: widget.storyid,
                    chapterID: lastIndex == null
                      ? listchapter.chapters[0]
                      : listchapter.chapters[lastIndex!],
                    initalPage: 0,
                  ),
                ),
              ).then((value) {
                if (value = true) {
                  setState(() {
                    loadLastIndex();
                  });
                }
              }); 
            },
            child: DetailTabbar(listchapter: listchapter, lastIndex: lastIndex,),
          )
        );
      } else {
        return Center(child: const Text("No data found"));
      }
    }
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
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.storyname,
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(
                  "${widget.views} Lượt xem - ",
                  style: TextStyle(
                    color: Color(0xffABACB6),
                    fontFamily: "Inter",
                  ),
                ),
                Text(
                  "${chapters[0].totalChapters} Chương",
                  style: TextStyle(
                    fontFamily: "Inter",
                  ),
                ),
              ],
            ),
          const SizedBox(height: 6),
          Text(
            "Tóm tắt nội dung",
            style: TextStyle(
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
              child: ReadMoreText(
                widget.storydes,
                trimCollapsedText: "Xem thêm",
                trimExpandedText: "Thu gọn",
                style: TextStyle(
                  // ignore: deprecated_member_use
                  fontFamily: 'Inter' 
                ),
                moreStyle: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
    

  Widget _buildUIlist(List<NumberModel> chapters, chapterlist) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: Color.fromARGB(255, 106, 66, 66).withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
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
                  "Chương ${chapterlist.chapters[index].replaceAll('.json', '')}",
                  style: const TextStyle(
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
                  ).then((value) {
                    if (value = true) {
                      setState(() {
                        loadLastIndex();
                      });
                    }
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }

  // Widget _continue(NumberModel chapterlist) {
  //   return Container(
  //     width: double.infinity,
  //     height: 60,
  //     decoration: BoxDecoration(color: const Color(0xFF393D5E)),
  //     child: Center(
  //       child: Container(
  //         padding: EdgeInsets.all(2),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(24),
  //           gradient: LinearGradient(
  //             colors: [Color(0xff9D00FF), Color(0xffc11c84)],
  //           ),
  //         ),
  //         child: GestureDetector(
  //           onTap: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => ReadingScreen(
  //                   storyID: widget.storyid,
  //                   chapterID: lastIndex == null
  //                     ? chapterlist.chapters[0]
  //                     : chapterlist.chapters[lastIndex!],
  //                   initalPage: 0,
  //                 ),
  //               ),
  //             );
  //           },
  //           child: Container(
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(24),
  //               color: Colors.pinkAccent,
  //             ),
  //             child: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Padding(
  //                 padding: const EdgeInsets.all(3.0),
  //                 child: Text(
  //                   lastIndex == null
  //                     ? "Bắt đâu đọc chuyện"
  //                     : "Đọc tiếp từ chương: $lastIndex",
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontFamily: "Inter",
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  }
