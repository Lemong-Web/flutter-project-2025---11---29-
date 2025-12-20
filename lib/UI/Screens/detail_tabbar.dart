// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:manga_app/model/number_model.dart';

class DetailTabbar extends StatefulWidget {
  final NumberModel listchapter;
  final int? lastIndex;
  
  const DetailTabbar({
    super.key,
    required this.listchapter, 
    required this.lastIndex,
  });

  @override
  State<DetailTabbar> createState() => _DetailTabbarState();
}

class _DetailTabbarState extends State<DetailTabbar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(color: const Color(0xFF393D5E)),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [Color(0xff9D00FF), Color(0xffc11c84)],
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.pinkAccent
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    widget.lastIndex == null
                     ? "Bắt đâu đọc chuyện"
                     : "Đọc tiếp từ chương: ${widget.lastIndex}",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          )
        )
      ),
    );
  }
}