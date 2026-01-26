import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/UI/Screens/detail_screen.dart';
import 'package:manga_app/UI/Screens/search_result.dart';
import 'package:manga_app/model/manga_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchResultTag extends StatefulWidget {
  final String searchQuery;
  final List<String>? selectedTags;
  
  const SearchResultTag({super.key, required this.searchQuery, required this.selectedTags});

  @override
  State<SearchResultTag> createState() => _SearchResultTagState();
}

class _SearchResultTagState extends State<SearchResultTag> {
  Dio dio = Dio();
  bool layoutChange = false;
  late Future<List<MangaModel>> data;
  TextEditingController _textEditingController = TextEditingController();

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

  void saveHistory(String storyID) async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('userID') ?? '';
    await prefs.setString('history_${uid}_$storyID', storyID);
  }

  @override
  void initState() {
    super.initState();
    data = fetchSearchResult(
      searchQuery: widget.searchQuery, 
      selectedTag: widget.selectedTags);
    _textEditingController = TextEditingController(text: widget.searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.6;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              height: 40,
              width: width,
              child: TextField(
                controller: _textEditingController,
                textInputAction: TextInputAction.search,
                style: TextStyle(
                ),
                decoration: InputDecoration(
                  filled: true,
                  // ignore: deprecated_member_use
                  hint: const Text(
                    "Tìm kiếm",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                ),
                onSubmitted: (value) {
                  final searchText = value.trim();
                  if (searchText.isEmpty) return;

                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context) => SearchResult(searchKey: searchText)));
                },
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                setState(() {
                  layoutChange = !layoutChange;
                });
              }, 
              icon: Icon(Icons.layers_outlined)
            )
          ],
        ),
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
            if(manhua.isEmpty) {
              return Center(
                child: Text(
                  "Không có kết quả cho ${widget.searchQuery}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter'
                )),
              );
            }
            return layoutChange
              ? _buildGidView(manhua)
              : _buildUI(manhua);
          } else {
            return const Center(child: Text("Không tải được dữ liệu"));
          }
        }),
      );
    }

    Widget _buildUI(List<MangaModel> manhua) {
      return SizedBox(
      child: ListView.builder(
        itemCount: manhua.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: GestureDetector(
              onTap: () {
                saveHistory(manhua[index].storyid);
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
                width: 326,
                height: 157,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12, left: 12, bottom: 12, right: 8),
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
                                  fontSize: 20,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                manhua[index].storydes,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
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
            ),
          );
        }
      ),
    );
  }
  Widget _buildGidView(List<MangaModel> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.55,
        ),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 8),
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  // ignore: deprecated_member_use
                  color: Theme.of(context).colorScheme.surface,
                ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      data[index].storyname,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold
                      ), 
                    ),
                  ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}