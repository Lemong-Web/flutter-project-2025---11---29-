import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/UI/Screens/detail_screen.dart';
import 'package:manga_app/model/manga_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Trending extends StatefulWidget {
  const Trending({super.key});

  @override
  State<Trending> createState() => _TrendingState();
}

class _TrendingState extends State<Trending> {
  late Future<List<MangaModel>> date;
  @override
  void initState() {
    date = fetchData();
    super.initState();
  }

  void saveHistory(String storyID) async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('userID') ?? '';
    await prefs.setString('history_${uid}_$storyID', storyID);
  }

  Future <List<MangaModel>> fetchData() async {
    final dio = Dio();
    final response = await dio.get("https://b0ynhanghe0.github.io/comic/categorized.json");
    final List<dynamic> body = response.data["hot"];
    return body.map((e) {
      return MangaModel.fromJson(e);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MangaModel>>(
      future: date, 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData){
          List<MangaModel> manga = snapshot.data!;
          return _buildUI(context, manga);
        } else {
          return const Center(child: Text("No data found!"));
        }
      }
    );
  }
  Widget _buildUI(BuildContext context, List<MangaModel> manga) {
  return SizedBox(
      height: 180,
      child: ListView.builder(
        itemCount: manga.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              saveHistory(manga[index].storyid);
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => DetailScreen(
                    storyid: manga[index].storyid,
                    storyname: manga[index].storyname,
                    storyothername: manga[index].storyothername,
                    storyimage: manga[index].storyimage,
                    storydes: manga[index].storydes,
                    storygenres: manga[index].storygenres,
                    urllinkcraw: manga[index].urllinkcraw,
                    storytauthor: manga[index].storytauthor,
                    views: manga[index].views,
                  )
                )
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 15, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xffFA8BFF),
                          Color(0xff2BD2FF)
                        ]
                      )
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        manga[index].storyimage,
                        width: 90,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 100, 
                    height: 35, 
                    child: Text(
                      manga[index].storyname,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontFamily: "Ubuntu",
                        fontWeight: FontWeight.bold,
                        fontSize: 12
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


