import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manga_app/UI/Screens/tagpage.dart';
import 'package:manga_app/UI/Widget/tagbutton.dart';
import 'package:manga_app/UI/Widget/trending.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF393D5E),
      body: _buildUI(),
    );
  }
  
  Widget _buildUI() {
    return SafeArea(
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
                  fillColor: Color(0xFFA0A1AD)
                ),
              ),
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
                    child: Text(
                      "Clear",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      )),
                    )
                  ],
                )
              ],
            ),
          );
        }
      }