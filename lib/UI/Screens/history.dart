import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/UI/Screens/detail_screen.dart';
import 'package:manga_app/UI/Widget/search_container.dart';
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
  bool isConnected = false;

  Future<List<MangaModel>> loadData() async {
    try {
      final response = await dio.get(url);
      List<dynamic> body = response.data;
      return body.map((e) {
        return MangaModel.fromJson(e);
      }).toList();
    } on DioException {
        if (mounted) {
          setState(() {
            isConnected = true;
          });
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

    historyList.sort((a, b) {
      int indexA = historyIds.indexOf(a.storyid);
      int indexB = historyIds.indexOf(b.storyid);
      return indexB.compareTo(indexA);
    });
  }

  Future<void> retry() async {
    setState(() {
      isConnected = true;
      _history = loadHistory();
    });
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
            return isConnected 
              ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off,
                    color: Colors.white,
                    size: 40),
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: [
                          Color(0xff2BFF88),
                          Color(0xff2BD2FF),
                          Color(0xffFA8BFF)
                        ]
                      ).createShader(bounds);
                    },
                    child: Text(
                      "Lỗi kết nối với mạng, vui lòng thử lại sau.",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontSize: 15
                      )),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                      ),
                    ),
                    onPressed: () async {
                      try {
                        await dio.get(url);
                        retry();
                      } on DioException catch (e) {
                        if (e.response == null) {
                          if (!mounted) return;
                          setState(() {
                            isConnected = false;
                          });
                        }
                      }
                    }, 
                    child: ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          colors: [
                            Color(0xff2BFF88),
                            Color(0xff2BD2FF),
                            Color(0xffFA8BFF)
                          ]
                        ).createShader(bounds);
                      },
                    child: Text("Thử lại"))
                  ),
                ],
              ),
            )
            : Padding(
                padding: const EdgeInsets.only(top: 10, left: 0, right: 0, bottom: 10),
                child: ListView.builder(
                  itemCount: historyList.length,
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
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                    storyid: historyList[index].storyid,
                                    storyname: historyList[index].storyname, 
                                    storyothername: historyList[index].storyothername, 
                                    storyimage: historyList[index].storyimage, 
                                    storydes: historyList[index].storydes, 
                                    storygenres: historyList[index].storygenres, 
                                    urllinkcraw: historyList[index].urllinkcraw, 
                                    storytauthor: historyList[index].storytauthor, views: historyList[index].views)));
                                  },
                                  child: SearchContainer(
                                    image: Image.network(historyList[index].storyimage)
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
                                          historyList[index].storyname,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Inter",
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            historyList[index].storydes,
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                      ]
                                    ),
                                  ),
                                )
                              ]
                            )
                          )
                        );
                      }
                    )
                  );
                }
              }),
            );
          }
        }
