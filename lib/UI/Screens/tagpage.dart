// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/UI/Screens/detail_screen.dart';
import 'package:manga_app/model/manga_model.dart';

class Tagpage extends StatefulWidget {
  final String tag;
  
  const Tagpage({
    super.key,
    required this.tag,
  });

  @override
  State<Tagpage> createState() => _TagpageState();
}

class _TagpageState extends State<Tagpage> {
  
  Future <List<MangaModel>> fetchData() async {
    final Dio dio = Dio();
    final response = await dio.get("https://b0ynhanghe0.github.io/comic/categorized.json");
    final List<dynamic> body = response.data[widget.tag];
    return body.map((e) {
      return MangaModel.fromJson(e);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF393D5E),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF393D5E),
        title: Text(
          widget.tag,
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Inter",
            fontSize: 24
          ),
        ),
      ),
      body: FutureBuilder(
        future: fetchData(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(
              "Truyên đang được cập nhật, vui lòng quay lại sau",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: "Inter"
              )));
          } else if (snapshot.hasData) {
            List<MangaModel> manga = snapshot.data!;
            return _buildUI(manga);
          } else {
            return const Center(child: Text("No data found"));
          }
        }
      )
    );
  }
  Widget _buildUI(List<MangaModel> manga) {
    return SizedBox(
      height: 700,
      child: ListView.builder(
        itemCount: manga.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              width: 326,
              height: 157,
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Color(0xffFFFFFF).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12, left: 12, bottom: 12, right: 8),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return DetailScreen(
                            storyid: manga[index].storyid, 
                            storyname: manga[index].storyname, 
                            storyothername: manga[index].storyothername, 
                            storyimage: manga[index].storyimage, 
                            storydes: manga[index].storydes, 
                            storygenres: manga[index].storygenres,
                            urllinkcraw: manga[index].urllinkcraw, 
                            storytauthor: manga[index].storytauthor, views: manga[index].views);
                        }));
                      },
                      child: Container(
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xffFA8BFF),
                              Color(0xff2BD2FF)
                            ]           
                          ),
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(manga[index].storyimage),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              manga[index].storyname,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white, 
                                fontSize: 20,
                                fontFamily: "Ubuntu",
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 78,
                            width: 250,
                            child: Text(
                              manga[index].storydes,
                              style: TextStyle(
                                color: Color(0xffB8B8B8)
                              )
                            )
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}