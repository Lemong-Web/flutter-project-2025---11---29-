// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/UI/Screens/reading_screen.dart';
import 'package:manga_app/UI/Widget/detailbtn.dart';
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
  bool isFavorite = false;

  Dio dio = Dio();
  Future<NumberModel> fetchChapters() async {
    final response = await dio.get("https://b0ynhanghe0.github.io/comic/chapter/${widget.storyid}/listchapter.json");
    final data = response.data;
    return NumberModel.fromJson(data);
  }

  @override
  void initState() {
    super.initState();
  }

  void isFavoritebool() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF393D5E),
      appBar: AppBar(
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
                  fontFamily: "Ubuntu", fontWeight: FontWeight.bold)),
                Spacer(),
                IconButton(
                  onPressed: () {
                    isFavoritebool();
                  }, 
                  icon: Icon(
                    Icons.favorite,
                    color: isFavorite ? Colors.red : Colors.white)
                ),
            ],
          )),
        ),

      body: FutureBuilder(
        future: fetchChapters(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error ${snapshot.error}"));
          } else if (snapshot.hasData) {
            List<NumberModel> chapters = [snapshot.data!];
            final chapterlist = snapshot.data!;
            return Column(
              children: [
                _buildUIwallpaper(),
                _buildUIdetail(chapters),
                Expanded(
                  child: _buildUIlist(chapters, chapterlist))
              ],
            );
          } else {
            return const Center(child: Text("No data found"));
          }
        }
      ),
    );
  }
  Widget _buildUIwallpaper() {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(18),
        child: Image.asset("assets/img/placeholder.jpg", fit: BoxFit.cover,),
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
                fontWeight: FontWeight.bold
              ),
            ),
            Row(
              children: [
                Text(
                  "${widget.views} Views - ",
                  style: TextStyle(
                    color: Color(0xffABACB6),
                    fontFamily: "Inter"
                  )),
                Text(
                  "${chapters[0].totalChapters} Chapters",
                  style: TextStyle(
                    color: Color(0xffABACB6),
                    fontFamily: "Inter"
                  )
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
                  fontWeight: FontWeight.bold)
                ),
              SizedBox(
                height: 100,
                width: 350,
                child: SingleChildScrollView(
                  child: Text(
                    widget.storydes,
                    style: TextStyle(
                      color: Color(0xffABACB6),
                    )),
                  ),
                )
              ],
            ),
          ),
        );
      }
    Widget _buildUIlist( List<NumberModel> chapters , chapterlist) {
      return Container(
        width: 350,
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: Color(0xffFFFFFF).withOpacity(0.2),
          borderRadius: BorderRadius.circular(12)
        ),
        child: ListView.builder(
         itemCount: chapterlist.chapters.length,
         itemBuilder: (context, index) {
          return ListTile(
              title: ShaderMask(
                shaderCallback: (bound) {
                  return LinearGradient(
                    colors: [
                      Color(0xff2BD2FF),
                      Color(0xff2BFF88)
                    ]
                  ).createShader(bound);
                },
                child: Text(
                  "Chapter (${chapterlist.chapters[index].replaceAll('.json', '')})",
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Inter",
                  ),
                ),
              ),
              trailing: Detailbtn(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ReadingScreen(
                    storyID: widget.storyid, 
                    chapterID: chapterlist.chapters[index], 
                    initalPage: index)));
                }
              ),
            );
          }
        ),
      );
    }
  }