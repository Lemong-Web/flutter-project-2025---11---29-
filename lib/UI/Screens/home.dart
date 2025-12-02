// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/UI/Screens/detail_screen.dart';
import 'package:manga_app/UI/Widget/trending.dart';
import 'package:manga_app/UI/Widget/view.dart';
import 'package:manga_app/model/manga_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String searchKey = "";
  
  @override
  void initState() {
    super.initState();
  }

  Future <List<MangaModel>> fetchData({String? searchText}) async {
    final dio = Dio();
    String url = "https://b0ynhanghe0.github.io/comic/home.json";
    final response = await dio.get(url);
    final List<dynamic> body = response.data;
    List<MangaModel> list = body.map((e) {
       return MangaModel.fromJson(e);
    }).toList();

    if (searchText != null && searchText.isNotEmpty) {
      // Where là 1 hàm lọc filter
      // nó duyệt qua từng phần tử trong List, kiểm tra điều kiện bên trong, và chỉ giữ lại phần tử có điều kiện = true
      // trả về Iterable nên phải toList()
      list = list.where((manga) {
        // đây là điều kiện của Where
        // nếu phần tử có chứa tên truyện trùng với nội dung Search, thì điều kiện = true và được dữ lại
        return manga.storyname.toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    }
    return list;
  }
   
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MangaModel>>(
      future: fetchData(searchText: searchKey), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError){
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          List<MangaModel> manga = snapshot.data!;
          return _buildUI(manga);
        } else {
          return const Center(child: Text("Found no data"));
        }
      } 
    );
  }

  Widget _buildUI(List<MangaModel> manga) {
    return Scaffold(
      backgroundColor: const Color(0xFF393D5E),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            SafeArea(
              child: Align(
                child: Image.asset(
                  "assets/img/Comics.png",
                  height: 24,
                  width: 110,
                )
              ),
            ),
            const SizedBox(height: 10),
            Padding (
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: TextField(
                onSubmitted: (value) {
                  setState(() {
                    searchKey = value;
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    // ignore: deprecated_member_use
                    color: Color(0xFF393D5E).withOpacity(0.6),
                  ),
                  hint: Text (
                    "Manhua",
                    style: TextStyle(
                      // ignore: deprecated_member_use
                      color: Color(0xFF393D5E).withOpacity(0.6),
                      fontFamily: "Ubuntu",
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  filled: true,
                  fillColor: Color(0xFFA0A1AD),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 200, top: 10),
              child: Text(
                "Trending Manhua",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontFamily: "Ubuntu",
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
           Trending(),
           Padding(
             padding: const EdgeInsets.only(right: 260, top: 8),
             child: Text(
              "Manhua!",
              style: TextStyle(
                fontFamily: "Ubuntu",
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white
                ),
              ),
            ),
            SizedBox(
              height: 600,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisExtent: 180
                ),
                itemCount: manga.length,
                itemBuilder: (context, index) {
                  final data = manga[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(
                        storyid: data.storyid, 
                        storyname: data.storyname, 
                        storyothername: data.storyothername, 
                        storyimage: data.storyimage, 
                        storydes: data.storydes, 
                        storygenres: data.storydes, 
                        urllinkcraw: data.urllinkcraw, 
                        storytauthor: data.storytauthor, views: data.views)));  
                    },
                    child: view (
                      storyid: data.storyid, 
                      storyname: data.storyname, 
                      storyothername: data.storyothername, 
                      storyimage: data.storyimage, 
                      storydes: data.storydes, 
                      storygenres: data.storygenres, 
                      urllinkcraw: data.urllinkcraw, 
                      storytauthor: data.storytauthor, views: data.views),
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      );
    }
  }