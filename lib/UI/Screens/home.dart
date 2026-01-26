// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/UI/Screens/detail_screen.dart';
import 'package:manga_app/UI/Widget/trending.dart';
import 'package:manga_app/UI/Widget/view.dart';
import 'package:manga_app/model/filter.dart';
import 'package:manga_app/model/manga_model.dart';
import 'package:manga_app/provider/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String urlData = "https://b0ynhanghe0.github.io/comic/home.json";
  int _current = 0;
  bool tagSearch = false;
  bool isInternetConnected = true;
  bool search = false;
  final Dio dio = Dio();
  final CarouselSliderController _controller = CarouselSliderController();
  late Future <List<MangaModel>> data;
  List<Filter> selectedTagList = [];
  List<String> selectedTag = [];
  StreamSubscription? _streamSubscription;

  
  // void uidGet() async {
  //   final prefs = await SharedPrefesrences.getInstance();
  //   final String? uid = prefs.getString('userID');
  //   setState(() {
  //     userID = uid ?? "";
  //   });
  // }

  void saveHistory(String storyID) async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('userID') ?? '';
    await prefs.setString('history_${uid}_$storyID', storyID);
  }

  void openFilterDialog() async {
    await FilterListDialog.display<Filter>(
      context,
      listData: filterList,
      selectedListData: selectedTagList,
      selectedItemsText: "Tag đã chọn",
      applyButtonText: "Áp dụng",
      resetButtonText: "Xóa",
      allButtonText: " Tất cả",
      choiceChipLabel: (item) => item!.name,
      validateSelectedItem: (list, item) => list!.contains(item),
      hideSearchField: true,
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
    List<MangaModel> list = [];
    try {
    final response = await dio.get(urlData);
    final List<dynamic> body = response.data;
    list = body.map((e) {
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
  } on DioException {
      isInternetConnected = false;
    }
  return list;
}

 Future<void> retry() async {
  setState(() {
    isInternetConnected = true;
    data = tagSearch
      ? fetchDataTag()
      : fetchData();
  });
}

  @override
  void initState() {
    super.initState();
    data = tagSearch ? fetchDataTag() : fetchData(searchText: searchKey);
    // uidGet();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
   
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return FutureBuilder<List<MangaModel>>(
      future: data, 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError){
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          List<MangaModel> manga = snapshot.data!;
          return _buildUI(manga, themeProvider);
        } else {
          return const Center(child: Text("Found no data"));
        }
      } 
    );
  }

  Widget _buildUI(List<MangaModel> manga, ThemeProvider themeProvider) {
    return Scaffold(
      // backgroundColor: themeProvider.themeMode == 
      // ThemeMode.dark ? Color(0xFF393D5E) : Color(0xFFF2F3F9),
      body: isInternetConnected 
        ? SingleChildScrollView(
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
            // Padding (
            //   padding: const EdgeInsets.only(left: 30, right: 30),
            //   child: TextField(
            //     controller: controllerManager.controller,
            //     textInputAction: TextInputAction.search,
            //     onSubmitted: (value) {
            //       if (value.isEmpty) return;
            //       setState(() {
            //         searchKey = value;
            //         search = true;
            //         data = fetchData(searchText: searchKey);
            //       });   
            //     },
            //     decoration: InputDecoration(
            //       prefixIcon: Icon(Icons.search),
            //       suffixIcon: IconButton(
            //         onPressed: () {
            //           openFilterDialog();
            //         }, 
            //         icon: Icon(Icons.tune)),
            //       hint: Text (
            //         "Tìm kiếm truyện...",
            //         style: TextStyle(
            //           // ignore: deprecated_member_use
            //           color: Color(0xFF393D5E).withOpacity(0.6),
            //           fontFamily: "Ubuntu",
            //           fontWeight: FontWeight.bold
            //         ),
            //       ),
            //       filled: true,
            //       fillColor: Color(0xFFA0A1AD),
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(12)
            //       ),
            //     ),
            //   ),
            // ),
            
            const SizedBox(height: 10),

            search
              ? const SizedBox.shrink()
              : Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      "Manhua đang nổi",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Ubuntu",
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
    
          search ? const SizedBox.shrink() : Trending(),
          
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => DetailScreen(
                        storyid: manga[3].storyid, 
                        storyname: manga[3].storyname, 
                        storyothername: manga[3].storyothername, 
                        storyimage: manga[3].storyimage, 
                        storydes: manga[3].storydes, 
                        storygenres: manga[3].storygenres, 
                        urllinkcraw: manga[3].urllinkcraw, storytauthor: manga[3].storytauthor, views: manga[3].views)));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox.expand(
                          child: Image.asset(
                            "assets/img/wallpaper4.webp", fit: BoxFit.cover),
                        ),
                      ),
                    ),
                
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => DetailScreen(
                        storyid: manga[0].storyid, 
                        storyname: manga[0].storyname, 
                        storyothername: manga[0].storyothername, 
                        storyimage: manga[0].storyimage, 
                        storydes: manga[0].storydes, 
                        storygenres: manga[0].storygenres, 
                        urllinkcraw: manga[0].urllinkcraw, 
                        storytauthor: manga[0].storytauthor, views: manga[0].views)));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox.expand(
                          child: Image.asset(
                            "assets/img/wallpaper5.jpg", fit: BoxFit.cover),
                        ),
                      ),
                    ),
    
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => DetailScreen(
                        storyid: manga[33].storyid, 
                        storyname: manga[33].storyname, 
                        storyothername: manga[33].storyothername, 
                        storyimage: manga[33].storyimage, 
                        storydes: manga[33].storydes, 
                        storygenres: manga[33].storygenres, 
                        urllinkcraw: manga[33].urllinkcraw, 
                        storytauthor: manga[33].storytauthor, views: manga[0].views)));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox.expand(
                          child: Image.asset(
                            "assets/img/wallpaper6.webp", fit: BoxFit.cover),
                        ),
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
        
        search ? const SizedBox.shrink() :
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
    
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              search ? "Kết quả tìm kiếm" : "Danh sách truyện!",
              style: TextStyle(
                fontFamily: "Ubuntu",
                fontWeight: FontWeight.bold,
                fontSize: 20,
                ),
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
                      saveHistory(data.storyid);
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
                        await dio.get(urlData);
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