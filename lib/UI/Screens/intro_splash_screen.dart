import 'dart:async';
import 'package:flutter/material.dart';
import 'package:manga_app/UI/Screens/intro_ask.dart';
import 'package:manga_app/UI/Widget/stagebuildwidget.dart';
import 'package:manga_app/model/splash_model.dart';

class IntroSplashScreen extends StatefulWidget {
  const IntroSplashScreen({super.key});

  @override
  State<IntroSplashScreen> createState() => _IntroSplashScreenState();
}

class _IntroSplashScreenState extends State<IntroSplashScreen> {
  int currentIndex = 0;
  Timer? timer;
  int start = 14;
  bool _hasFinished = false;
  final PageController _pageController = PageController();

  void startTimer() async {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec, 
      (Timer timer) {
        if (start == 0 && !_hasFinished) {
          setState(()  {
            _hasFinished = true;
            timer.cancel();
            Navigator.push(context, MaterialPageRoute(builder: (context) => IntroAsk()));
          });
        } else {
          setState(() {
            start--;
          });
        }
      }
    );
  }

  Future<void> handleTimeout() async {
    for (int i = 0; i < screenList.length; i++) {
      await Future.delayed(const Duration(seconds: 2));
      if (i < screenList.length - 1) {
        if(_pageController.hasClients) {
          _pageController.nextPage(
          duration: const Duration(milliseconds: 500), 
          curve: Curves.easeIn
          );
        }
      }
    }
  }

  @override
  void initState() {
    startTimer();
    Timer(const Duration(seconds: 3), handleTimeout); 
    super.initState();   
  }

  @override
  void dispose() {
    timer!.cancel();
    _pageController.dispose();
    super.dispose();
  }
  
  List<SplashModel> screenList = [
    SplashModel(
      "assets/img/reading.jpg", 
      "Đọc những Manhua mới nhất, được cập nhật trên App",
      "Đọc chuyện"),
    SplashModel(
      "assets/img/ClickFavo.jpg", 
      "Tạo danh sách Manhua yêu thích của riêng bạn trong App, bằng cách nhấn nút yêu thích",
      "Yêu thích"),
    SplashModel(  
      'assets/img/share_stories.jpg', 
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
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
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
                    title: screenList[index].title
                  );
                }
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                screenList.length,
                (index) => buildDot(index: index)
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () async {
                    timer!.cancel();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => IntroAsk()));
                  }, 
                  child: Text("Bỏ qua ($start)")
                ),
              ),
            ),
            const SizedBox(height: 20)
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

   
  