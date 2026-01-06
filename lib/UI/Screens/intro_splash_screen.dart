import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/UI/Screens/navigation.dart';
import 'package:manga_app/UI/Widget/stagebuildwidget.dart';
import 'package:manga_app/auth_service.dart';
import 'package:manga_app/model/splash_model.dart';

class IntroSplashScreen extends StatefulWidget {
  const IntroSplashScreen({super.key});

  @override
  State<IntroSplashScreen> createState() => _IntroSplashScreenState();
}

class _IntroSplashScreenState extends State<IntroSplashScreen> {
  int currentIndex = 0;
  final PageController _pageController = PageController();
  
  List<SplashModel> screenList = [
    SplashModel(
      "assets/img/reading.jpg", 
      "Đọc những Manhua mới nhất, được cập nhật trên App",
      "Đọc chuyện"),
    SplashModel(
      "assets/img/ClickFavo.avif", 
      "Tạo danh sách Manhua yêu thích của riêng bạn trong App, bằng cách nhấn nút yêu thích",
      "Yêu thích"),
    SplashModel(
      'assets/img/share_stories.avif', 
      'Chia sẻ những câu chuyện yêu thích của bạn để mọi người cùng tận hưởng', 
      'Chia sẻ'),
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF393D5E),
      ),
        backgroundColor: const Color(0xFF393D5E),
        body: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  currentIndex = value;
                });
              },
              itemCount: screenList.length,
              itemBuilder: (context, index) {
                return Stagebuildwidget(
                  imgUrl: screenList[index].imgStr,
                  desc: screenList[index].desc,
                  title: screenList[index].title);
                }
              ),
              Positioned(
                bottom: 100,
                left: 190,
                child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        screenList.length,
                          (index) => buildDot(index: index)
                      ),
                    ),
                  ),

                  currentIndex < screenList.length - 1
                     ? Positioned(
                        bottom: 20,
                        width: MediaQuery.of(context).size.width,
                        child: Row (
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: currentIndex > 0 
                             ? () {
                             _pageController.previousPage(
                              duration: const Duration(milliseconds: 300), 
                              curve: Curves.ease
                            );
                          }
                             : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0)
                                  )
                                )
                              ), 
                              child: Text(
                                "Trước",
                                style: TextStyle(
                                  fontSize: 18, color: Colors.green)),
                              ),

                        ElevatedButton(
                          onPressed: currentIndex < screenList.length - 1
                          ? () {
                           _pageController.nextPage(
                            duration: const Duration(milliseconds: 300), 
                            curve: Curves.ease);  
                          }
                          : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                bottomLeft: Radius.circular(20.0)
                              )
                            )
                          ),
                          child: Text(
                            "Tiếp theo",
                            style: TextStyle(
                              fontFamily: 'Unbuntu', 
                              fontSize: 18,
                              color: Colors.green),
                          )
                        )
                      ],
                    ),
                  )
                
              : Positioned(
                  bottom: 40,
                  left: MediaQuery.of(context).size.width * 0.36,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE0E0E0),
                      shape:  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      )
                    ),
                    onPressed: () async {
                      final uid = authService.value.currentUser!.uid;
                      final db = FirebaseFirestore.instance;
                      await db.collection('users').doc(uid).set(
                        {'isNewUser': false},
                        SetOptions(merge: true)
                      );
                      // Navigator.pushReplacement(
                      //   context, 
                      //   MaterialPageRoute(builder: (_) => Navigation()));
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
                      child: Text(
                        "Bắt đầu",
                        style: TextStyle(fontSize: 18, color: Colors.green)),
                    )
                  )
                )
              ],
            ),
          );
        }
          
    AnimatedContainer buildDot({int? index}) {
      return AnimatedContainer(
        duration: kThemeAnimationDuration,
        margin: const EdgeInsets.only(right: 5),
        height: 6,
        width: currentIndex == index ? 20 : 6,
        decoration: BoxDecoration(
          color: currentIndex == index ? Colors.amber : Color(0xFFD8D8D8),
          borderRadius: BorderRadius.circular(3)
        ),
      );
    }
  }
  
 


