// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/UI/Screens/detail_screen.dart';
import 'package:manga_app/UI/Widget/search_container.dart';
import 'package:manga_app/model/manga_model.dart';

class SearchResult extends StatefulWidget {
  final String searchKey;
   
  const SearchResult({
    super.key,
    required this.searchKey,
  });

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  Dio dio = Dio();

  Future <List<MangaModel>> fetchData({String? searchKey}) async {
    String url = "https://b0ynhanghe0.github.io/comic/home.json";
    final response = await dio.get(url);
    final List<dynamic> body = response.data;
    List<MangaModel> manhua = body.map((e) {
      return MangaModel.fromJson(e);
    }).toList();
     if (searchKey!.isNotEmpty) {
      manhua = manhua.where((a) {
        return a.storyname.toLowerCase().contains(searchKey.toLowerCase());
      }).toList();
    }
    return manhua;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF393D5E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF393D5E),
        title: Text(
          '"${widget.searchKey}"',
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Inter",
            fontSize: 20,
            fontWeight: FontWeight.bold
          )
        ),
      ),
      body: FutureBuilder(
        future: fetchData(searchKey: widget.searchKey), 
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final data = snapshot.data;
            return _buildUI(data!);
          } else {
            return const Center(child: Text("No data found"));
          }
        }
      ),
    );
  }
  Widget _buildUI( List<MangaModel> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
          child: Container(
            width: 326,
            height: 157,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              // ignore: deprecated_member_use
              color: Color(0xffFFFFFF).withOpacity(0.2)
            ),
            child: Row(
              children: [
                SearchContainer(
                  image: Image.network(data[index].storyimage)
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: SizedBox(
                    width: 240,
                    height: 350,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data[index].storyname,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Inter"
                          ),
                        ),
                        SizedBox(
                          height: 75,
                          child: Text(
                            data[index].storydes,
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(
                              storyid: data[index].storyid, 
                              storyname: data[index].storyname, 
                              storyothername: data[index].storyothername, 
                              storyimage: data[index].storyimage, 
                              storydes: data[index].storydes, 
                              storygenres: data[index].storygenres, 
                              urllinkcraw: data[index].urllinkcraw, 
                              storytauthor: data[index].storytauthor, views: data[index].views)));
                          },
                          child: Container(
                            padding: EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xff2BD2FF),
                                  Color(0xff2BFF88)
                                ]
                              ),
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                // ignore: deprecated_member_use
                                color: Color(0xE6FFFFFF),
                                borderRadius: BorderRadius.circular(12)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text("Đọc truyện"),
                              ),
                            ),
                          ),
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
    );
  }
}