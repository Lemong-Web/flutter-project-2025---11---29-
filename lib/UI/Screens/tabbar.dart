// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:manga_app/UI/Screens/bookshelf.dart';
import 'package:manga_app/UI/Screens/history.dart';

class Tabbar extends StatelessWidget {
  const Tabbar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Giá sách",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.history, color: Colors.amber)),
              Tab(icon: Icon(Icons.favorite, color: Colors.amber,)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            History(),
            Bookshelf(),
          ],
        ),
      ),
    );
  }
}
