// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/UI/Screens/detail_screen.dart';
import 'package:manga_app/model/manga_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Bookshelf extends StatefulWidget {
  const Bookshelf({super.key});

  @override
  State<Bookshelf> createState() => _BookshelfState();
}

class _BookshelfState extends State<Bookshelf> {
  Dio dio = Dio();
  String url = "https://b0ynhanghe0.github.io/comic/home.json";
  List<MangaModel> manhuaList = [];
  List<MangaModel> favoriteManhua = [];
  late Future<void> shelf;
  bool isInternetConnected = true;

   @override
  void initState() {
    super.initState();
    shelf = loadShelf();
  }

  Future<void> loadShelf() async {
    manhuaList = await fetchData();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('userID') ?? '';
    List<String> keys = prefs.getKeys().where((k) => k.startsWith("favorite_${uid}_")).toList();
    List<String> favoriteIds = keys.where((keys) {
      return prefs.getBool(keys) ?? false;
    }).map((keys) {
      return keys.replaceFirst("favorite_${uid}_", "");
    }).toList();
    
    // favoriteIds trả về những key là "true", loại bỏ "favorite_ chỉ giữ lại id",
    // favoriteIDs so sánh với danh sách truyện, trả về trong danh sách những truyện có trùng ID bên trong nó
    // Nói chính xác hơn là manhuaList được lọc để trả về manhua trùng id với favoriteIds
    favoriteManhua = manhuaList.where((manhua) {
      return favoriteIds.contains(manhua.storyid.toString());
    }).toList();
  }
  
  Future <List<MangaModel>> fetchData() async {
    try {
      final response = await dio.get(url); 
      List<dynamic> body = response.data;
      return body.map((e) {
        return MangaModel.fromJson(e);
      }).toList();
    } on DioException {
      if (mounted) {
        setState(() {
          isInternetConnected = false;
        });
      }
    }
    return [];
  }
  Future<void> retry() async {
    setState(() {
      isInternetConnected = true;
      shelf = loadShelf();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF393D5E),
        title: Text(
          "Giá Sách",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Inter",
            fontWeight: FontWeight.bold,
            fontSize: 24
        )),
      ),
      backgroundColor: Color(0xFF393D5E),
      body: isInternetConnected
        ? FutureBuilder(
        future: shelf, 
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (favoriteManhua.isEmpty) {
            return const Center(child: Text(
              'Trong danh sách hiện không có Manhua.', 
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: 18 )));
          } else {
            return Padding(
              padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio:  90 / 120,
                ),
                itemCount: favoriteManhua.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return DetailScreen(
                          storyid: favoriteManhua[index].storyid, 
                          storyname: favoriteManhua[index].storyname, 
                          storyothername: favoriteManhua[index].storyothername, 
                          storyimage: favoriteManhua[index].storyimage, 
                          storydes: favoriteManhua[index].storydes, 
                          storygenres: favoriteManhua[index].storygenres,
                          urllinkcraw: favoriteManhua[index].urllinkcraw, 
                          storytauthor: favoriteManhua[index].storytauthor, views: favoriteManhua[index].views);
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
                          favoriteManhua[index].storyimage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }
              ),
            );
          }
        }
      )
      : Center(
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
                            isInternetConnected = false;
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
          );
        }
      }