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
  List<MangaModel> manhuaList = [];
  List<MangaModel> favoriteManhua = [];

   @override
  void initState() {
    super.initState();
    loadShelf();
  }

  Future<void> loadShelf() async {
    manhuaList = await fetchData();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> keys = prefs.getKeys().where((k) => k.startsWith("favorite_")).toList();
    List<String> favoriteIds = keys.where((keys) {
      return prefs.getBool(keys) ?? false;
    }).map((keys) {
      return keys.replaceFirst("favorite_", "");
    }).toList();
    
    // favoriteIds trả về những key là "true", loại bỏ "favorite_ chỉ giữ lại id",
    // favoriteIDs so sánh với danh sách truyện, trả về trong danh sách những truyện có trùng ID bên trong nó
    // Nói chính xác hơn là manhuaList được lọc để trả về manhua trùng id với favoriteIds
    favoriteManhua = manhuaList.where((manhua) {
      return favoriteIds.contains(manhua.storyid.toString());
    }).toList();
  }
  
  Future <List<MangaModel>> fetchData() async {
    Dio dio = Dio();
    final response = await dio.get("https://b0ynhanghe0.github.io/comic/home.json"); 
    List<dynamic> body = response.data;
    return body.map((e) {
      return MangaModel.fromJson(e);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF393D5E),
        title: Text(
          "BookShelf",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Inter",
            fontWeight: FontWeight.bold,
            fontSize: 24
        )),
      ),
      backgroundColor: Color(0xFF393D5E),
      body: FutureBuilder(
        future: loadShelf(), 
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (favoriteManhua.isEmpty) {
            return const Center(child: Text('No favorite manhua found.'));
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
    );
  }
}