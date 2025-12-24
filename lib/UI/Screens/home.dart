// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/UI/Screens/detail_screen.dart';
import 'package:manga_app/UI/Widget/trending.dart';
import 'package:manga_app/UI/Widget/view.dart';
import 'package:manga_app/model/filter.dart';
import 'package:manga_app/model/manga_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String tag = '';
  String searchKey = "";
  String userID = "";
  int _current = 0;
  bool tagSearch = false;
  final CarouselSliderController _controller = CarouselSliderController();
  late Future <List<MangaModel>> data;
  List<Filter> selectedTagList = [];
  List<String> selectedTag = [];
  
  // void uidGet() async {
  //   final prefs = await SharedPrefesrences.getInstance();
  //   final String? uid = prefs.getString('userID');
  //   setState(() {
  //     userID = uid ?? "";
  //   });
  // }

  void openFilterDialog() async {
    await FilterListDialog.display<Filter>(
      context,
      listData: filterList,
      selectedListData: selectedTagList,
      choiceChipLabel: (item) => item!.name,
      validateSelectedItem: (list, item) => list!.contains(item),
      onItemSearch: (item, query) => true,
      choiceChipBuilder: (context, item, isSelected) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected! ? Colors.blue : Colors.grey,
            )
          ),
          child: Text(
            item.name,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey),
            ),
          );
        },
      onApplyButtonClick: (list) {
        if (list == null || list.isEmpty) {
          setState(() {
            selectedTagList = [];
            selectedTag = [];
            tagSearch = false;
            data = fetchData();
          });
          return
          Navigator.pop(context);
        } 
        setState(() {
          selectedTagList = List<Filter>.from(list);
          selectedTag = selectedTagList.map((e) => e.name).whereType<String>().toList();
          tagSearch = true;
          data = fetchDataTag();
        });
        Navigator.pop(context);
      },
    );
  }

  Future<List<MangaModel>> fetchDataTag() async {
    if (selectedTag.isEmpty) return [];
    final Dio dio = Dio();
    final response = await dio.get("https://b0ynhanghe0.github.io/comic/categorized.json");
    final data = response.data;
    if (data is! Map<String, dynamic>) return [];
    final Map<String, MangaModel> uniqueMap = {};
    for (final tag in selectedTag) {
      final List<dynamic> list = data[tag] ?? [];
      for (final e in list) {
        final manhua = MangaModel.fromJson(e);
        uniqueMap[manhua.storyid] = manhua;
      }
    }
  return uniqueMap.values.toList();
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
  void initState() {
    super.initState();
    data = tagSearch ? fetchDataTag() : fetchData(searchText: searchKey);
    // uidGet();
  }
   
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MangaModel>>(
      future: data, 
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
                    data = fetchData(searchText: searchKey);
                  });   
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () {
                      openFilterDialog();
                    }, 
                    icon: Icon(Icons.tune)),
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
            padding: const EdgeInsets.only(right: 200, bottom: 10),
            child: const Text(
              "Have Concluded!",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontFamily: 'Inter')
              ),
          ),

          Container(
            width: 326,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12)
            ),
            padding: EdgeInsets.all(2),
            child: CarouselSlider(
              carouselController: _controller,
              items: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox.expand(
                    child: Image.asset(
                      "assets/img/wallpaper1.avif", fit: BoxFit.cover),
                  ),
                ),
                
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox.expand(
                    child: Image.asset(
                      "assets/img/wallpaper2.jpg", fit: BoxFit.cover),
                  ),
                ),

                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox.expand(
                    child: Image.asset(
                      "assets/img/wallpaper3.jpg", fit: BoxFit.cover),
                  ),
                ),
              ], 
              options: CarouselOptions(
                autoPlay: true,
                enableInfiniteScroll: true,
                viewportFraction: 1,
                autoPlayCurve: Curves.fastOutSlowIn,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(microseconds: 800),
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }
              )
            ),
          ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 3; i++)
              Container(
                width: 8,
                height: 8,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == i ? Colors.blue : Colors.grey
                ),
              )
            ],
          ),

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
              height: tagSearch ? null : 2190,
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
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
                      storytauthor: data.storytauthor, views: data.views));
                    }
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }