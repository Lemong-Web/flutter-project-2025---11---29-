// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/UI/Screens/detail_screen.dart';
import 'package:manga_app/UI/Widget/search_container.dart';
import 'package:manga_app/model/manga_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool layoutChange = false;
  bool isSearch = true;
  Dio dio = Dio();
  late Future <List<MangaModel>> searchedManhua; 
  TextEditingController _textEditingController = TextEditingController();


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

  void saveHistory(String storyID) async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('userID') ?? '';
    await prefs.setString('history_${uid}_$storyID', storyID);
  }

  @override
  void initState() {
    super.initState();
    searchedManhua = fetchData(searchKey: widget.searchKey);
    _textEditingController = TextEditingController(
      text: widget.searchKey
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.6;
    return Scaffold(
      backgroundColor: const Color(0xFF393D5E),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF393D5E),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 40,
              width: width,
              child: TextField(
                controller: _textEditingController,
                style: TextStyle(
                  color: Colors.white
                ),
                decoration: InputDecoration(
                  filled: true,
                  // ignore: deprecated_member_use
                  fillColor: Colors.white.withOpacity(0.2),
                  hint: const Text(
                    "Tìm kiếm",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey
                  )),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                ),
                onSubmitted: (value) {
                  final keyword = value.trim();
                  if (keyword.isEmpty) return;

                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context) => SearchResult(searchKey: keyword)));
                },
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  layoutChange = !layoutChange;
                });
              }, 
              icon: Icon( isSearch ? Icons.layers_outlined : null) 
            )
          ],
        ),
      ),
      
      body: FutureBuilder(
          future: searchedManhua, 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              final data = snapshot.data;
              if (data!.isEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if(mounted) {
                    setState(() {
                      isSearch = false;
                    });
                  } 
                });
                return Center( 
                  child: Text(
                    "Không tìm thấy '${widget.searchKey}' trong App.",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ))
                  );
                }
              return layoutChange 
                ? _buildUIGridView(data) 
                : _buildUIListView(data);
            } else {
              return const Center(child: Text("No data found"));
            }
          }
        ),
      );
    }

  Widget _buildUIListView(List<MangaModel> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Container(
            height: 157,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              // ignore: deprecated_member_use
              color: Color(0xffFFFFFF).withOpacity(0.2)
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    saveHistory(data[index].storyid);
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
                  child: SearchContainer(
                    image: Image.network(data[index].storyimage)
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.55,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data[index].storyname,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Inter",
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Expanded(
                          child: Text(
                            data[index].storydes,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

    Widget _buildUIGridView(List<MangaModel> data) {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 10,
          childAspectRatio: 0.57,
        ),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              // ignore: deprecated_member_use
              color: Color(0xffFFFFFF).withOpacity(0.2)
            ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: () {
                    saveHistory(data[index].storyid);
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(data[index].storyimage, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  data[index].storyname,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold
                  ), 
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}