import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/UI/Screens/bookshelf.dart';
import 'package:manga_app/UI/Screens/detail_screen.dart';
import 'package:manga_app/model/manga_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  Dio dio = Dio();
  String url = "https://b0ynhanghe0.github.io/comic/home.json";
  List<MangaModel> manhuaList = [];
  List<MangaModel> historyList = [];
  late Future<void> _history;

  Future<List<MangaModel>> loadData() async {
    try {
      final response = await dio.get(url);
      List<dynamic> body = response.data;
      return body.map((e) {
        return MangaModel.fromJson(e);
      }).toList();
    } on DioException {
       if (mounted) {
        
       }
    }
    return [];
  }

  Future<void> loadHistory() async {
    manhuaList = await loadData();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('userID') ?? '';
    List<String> keys = prefs.getKeys().where((k) => k.startsWith("history_${uid}_")).toList();
    List<String> historyIds = keys.map((keys) {
      return keys.replaceFirst("history_${uid}_", "");
    }).toList();

    historyList = manhuaList.where((manhua) {
      return historyIds.contains(manhua.storyid);
    }).toList();
  }

  @override
  void initState() {
    _history = loadHistory();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF393D5E),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Lịch sử",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: const Color(0xFF393D5E),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Bookshelf()));
            }, 
            icon: Icon(
              Icons.list,
              color: Colors.white,
              size: 30,
            )
          )
        ],
      ),
      body: FutureBuilder(
        future: _history, 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (historyList.isEmpty) {
            return const Center(child: Text(
              "Danh sách lịch sử hiện đang trống",
                style: TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: 18 )));
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 90 / 120
                ), 
                itemCount: historyList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                          return DetailScreen(
                            storyid: historyList[index].storyid, 
                            storyname: historyList[index].storyname, 
                            storyothername: historyList[index].storyothername, 
                            storyimage: historyList[index].storyimage, 
                            storydes: historyList[index].storydes, 
                            storygenres: historyList[index].storygenres,
                            urllinkcraw: historyList[index].urllinkcraw, 
                            storytauthor: historyList[index].storytauthor, views: historyList[index].views);
                        }));
                      },
                      child: Container(
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xffFA8BFF),
                              Color(0xff2BD2FF)
                            ]
                          )
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            historyList[index].storyimage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  } 
                 
                ),
            );
            }
          }),
        );
      }
    }