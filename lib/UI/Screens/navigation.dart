import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:manga_app/UI/Screens/TrangChu/home.dart';
import 'package:manga_app/UI/Screens/profile.dart';
import 'package:manga_app/UI/Screens/search.dart';
import 'package:manga_app/UI/Screens/tabBar.dart';
import 'package:manga_app/provider/theme.dart';
import 'package:provider/provider.dart';

class Navigation extends StatefulWidget {
  
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.themeMode == 
        ThemeMode.dark ? Color(0xFF393D5E) : Color(0xFFF2F3F9),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          Home(),
          Search(),
          Tabbar(),
          Profile(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: [
                // ignore: deprecated_member_use
                Color(0xffFA8BFF).withOpacity(0.7),
                // ignore: deprecated_member_use
                Color(0xff2BD2FF).withOpacity(0.7),
                // ignore: deprecated_member_use
                Color(0xff2BFF88).withOpacity(0.7)
              ]
            )
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              color: themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.red,
              rippleColor: Colors.grey,
              hoverColor: Colors.grey,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              activeColor: themeProvider.themeMode == ThemeMode.dark ? Colors.yellow : Colors.orange,
              tabActiveBorder: Border.all(color: Colors.yellow),
              gap: 8,
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: "Trang chủ"),
                GButton(
                  icon: Icons.search,
                  text: "Tìm kiếm"),
                GButton(
                  icon: Icons.book,
                  text: "Giá sách"),
                GButton(
                  icon: Icons.account_circle,
                  text: "Tài khoản"),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: _onItemTapped,
              ),
            ),
          ),
        ),
      );
    }
  }