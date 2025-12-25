// import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:manga_app/UI/Screens/search_result.dart';
import 'package:manga_app/UI/Screens/search_result_tag.dart';
import 'package:manga_app/UI/Screens/tagpage.dart';
import 'package:manga_app/UI/Widget/tagbutton.dart';
import 'package:manga_app/UI/Widget/trending.dart';
import 'package:manga_app/model/filter.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:manga_app/model/manga_model.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String searchKey = "";
  bool isSelected = false;
  List<String> searchText = [];
  List<Filter>? selectedFilterList = [];
  List<String>? selectedTag = [];

  void searchHistory(List<String>? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final uid =prefs.getString('userID') ?? "";
    await prefs.setStringList("searchValue_$uid", value!);
  }

  void loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final uid =prefs.getString('userID') ?? "";
    setState(() {
      searchText = prefs.getStringList("searchValue_$uid") ?? [];
    });
  }

  void removeSearchistory(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final uid =prefs.getString('userID') ?? "";
    setState(() {
      searchText.removeAt(index);
      prefs.setStringList("searchValue_$uid", searchText);
    });
  }

  void removeEntireHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final uid =prefs.getString('userID') ?? "";
    setState(() {
      searchText.clear();
      prefs.setStringList("searchValue_$uid", searchText);
    });
  }

  @override
  void initState() {
    super.initState();
    loadSearchHistory();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF393D5E),
      body: _buildUI(),
    );
  }
  
  Widget _buildUI() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 20),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    // ignore: deprecated_member_use
                    color: Color(0xFF393D5E).withOpacity(0.6)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)
                    ),
                    filled: true,
                    // ignore: deprecated_member_use
                    fillColor: Color(0xFFA0A1AD),
                    suffixIcon: CustomPopup(
                    content: StatefulBuilder(
                      builder: (context, setPopupState) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: filterList.map((filter) {
                              final isSelected = selectedTag!.contains(filter.name);
        
                              return ChoiceChip(
                                label: Text(filter.name),
                                selected: isSelected,
                                selectedColor: Colors.blue,
                                onSelected: (value) {
                                  setPopupState(() {
                                    if (value) {
                                      selectedTag!.add(filter.name);
                                    } else {
                                      selectedTag!.remove(filter.name);
                                    }
                                  });
                                  setState(() {});
                                },
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                    child: const Icon(Icons.tune),
                  ),
                ),
                  onSubmitted: (value) {
                    setState(() {
                      searchKey = value;
                      searchText.add(value);
                      searchHistory(searchText);
                  });   
                    if (selectedTag!.isNotEmpty) {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SearchResultTag(searchQuery: searchKey, selectedTags: selectedTag)));
                        } else {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SearchResult(searchKey: searchKey)));
                        } 
                      },
                    ),
                  ),
        
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: selectedTag!.map<Widget>((e) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          e,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                           onPressed: () {
                            setState(() {
                              selectedTag!.remove(e);
                            });
                          }, 
                          icon: Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          )
                        )
                      ],
                    )
                  );
                }
              ).toList()
                          ),
        
              Padding(
                padding: const EdgeInsets.only(right: 120, bottom: 10),
                child: const Text(
                  "Most Searched Manhua",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: "Ubuntu",
                    fontWeight: FontWeight.bold)
                  ),
                ),
        
              Trending(),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Tagbutton(text: "#Action", onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Tagpage(tag: "action")));
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Tagbutton(text: "#Comedy", onPressed: () {}),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Tagbutton(text: "#Fantasy", onPressed: () {}),
                  )
                ],
              ),
              const SizedBox(height: 10),
        
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Tagbutton(
                      text: "#Supernatural", 
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Tagpage(tag: "Supernatural")));
                      }
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Tagbutton(text: "#Manhua", onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Tagpage(tag: "manhua")));
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Tagbutton(text: "#Romance", onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Tagpage(tag: "romance")));
                    }),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 50, right: 180),
                    child: const Text(
                      "Recent",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Ubuntu",
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      )),
                  ),
                    ShaderMask(
                      shaderCallback: (bound) {
                        return LinearGradient(
                          colors: [
                            Color(0xffFA8BFF),
                            Color(0xff2BD2FF)
                          ]
                        ).createShader(bound);
                      },
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            removeEntireHistory();
                          });
                        },
                        child: Text(
                          "Clear",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          )),
                      ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 170,
                    child: ListView.builder(
                      itemCount: searchText.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 33),
                          child: ListTile(
                            minTileHeight: 10,
                            title: Text(
                              searchText[index],
                              style: TextStyle(
                                color: Color(0xffB8B8B8),
                                fontFamily: "Ubuntu"
                              ),
                            ),
                          trailing: Padding(
                            padding: const EdgeInsets.only(right: 65),
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle
                              ),
                              child: ShaderMask(
                                shaderCallback: (bounds) {
                                  return LinearGradient(
                                    colors: [
                                      Color(0xffFA8BFF),
                                      Color(0xff2BD2FF)
                                    ]
                                  ).createShader(bounds);
                                },
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    setState(() {
                                      removeSearchistory(index);
                                    });
                                  }, 
                                  icon: Icon(
                                    Icons.clear,
                                    size: 20,
                                    color: Colors.white,
                                  )
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                )
              ],
            ),
          ),
        );
      }
    }