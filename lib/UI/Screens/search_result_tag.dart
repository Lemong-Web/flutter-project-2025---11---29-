import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/UI/Screens/detail_screen.dart';
import 'package:manga_app/model/manga_model.dart';

class SearchResultTag extends StatefulWidget {
  final String searchQuery;
  final List<String>? selectedTags;
  
  const SearchResultTag({super.key, required this.searchQuery, required this.selectedTags});

  @override
  State<SearchResultTag> createState() => _SearchResultTagState();
}

class _SearchResultTagState extends State<SearchResultTag> {
  Dio dio = Dio();
  late Future<List<MangaModel>> data;

  Future<List<MangaModel>> fetchSearchResult({String? searchQuery, List<String>? selectedTag}) async {
    String url = "https://b0ynhanghe0.github.io/comic/categorized.json";
    final response = await dio.get(url);
    List<MangaModel> manhua = [];
    
    for(final tag in selectedTag ?? []) {
      final List<dynamic>? body = response.data[tag];

      if (body != null) {
        manhua.addAll(
          body.map((e) => MangaModel.fromJson(e)).toList()
        );
      }
    }

    manhua = {
      for (var m in manhua) m.storyid: m
    }.values.toList();
    
    if (searchQuery != null && searchQuery.isNotEmpty) {
      manhua = manhua.where((a) {
        return a.storyname.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
    return manhua;
  }

  @override
  void initState() {
    super.initState();
    data = fetchSearchResult(
      searchQuery: widget.searchQuery, 
      selectedTag: widget.selectedTags);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF393D5E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF393D5E),
        title: Text(widget.searchQuery),
      ),
      body: FutureBuilder(
        future: data, 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            List<MangaModel> manhua = snapshot.data!;
            return _buildUI(manhua);
          } else {
            return const Center(child: Text("Cannot load data"));
          }
        }),
      );
    }

    Widget _buildUI(List<MangaModel> manhua) {
      return SizedBox(
      height: 700,
      child: ListView.builder(
        itemCount: manhua.length,
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
                            storyid: manhua[index].storyid, 
                            storyname: manhua[index].storyname, 
                            storyothername: manhua[index].storyothername, 
                            storyimage: manhua[index].storyimage, 
                            storydes: manhua[index].storydes, 
                            storygenres: manhua[index].storygenres,
                            urllinkcraw: manhua[index].urllinkcraw, 
                            storytauthor: manhua[index].storytauthor, views: manhua[index].views);
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
                          child: Image.network(manhua[index].storyimage),
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
                              manhua[index].storyname,
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
                              manhua[index].storydes,
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