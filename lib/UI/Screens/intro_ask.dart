import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/UI/Screens/auth_layout.dart';
import 'package:manga_app/auth_service.dart';
import 'package:manga_app/model/category.dart';

class IntroAsk extends StatefulWidget {
  const IntroAsk({super.key});

  @override
  State<IntroAsk> createState() => _IntroAskState();
}

class _IntroAskState extends State<IntroAsk> {
  List<String> selectedTag = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF393D5E),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: const Text(
                "Thể loại truyện", 
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                )),
              ),
            categorySelect(),
            
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                "Tính cách nhân vật chính",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold
                )),
            ),
            mcTrait(),
        
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                "Giới tính",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold
              )),
            ),
            genderOption(),
            Spacer(),
            nextBtn()
          ],
        ),
      ),
    );
  }

  Widget categorySelect() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 5,
        children: categoryList.map((tag) {
          final isSelected = selectedTag.contains(tag.name);
          return ChoiceChip(
            label: Text(tag.name), 
            selected: isSelected,
            onSelected: (value) {
              if (value) {
                setState(() {
                  selectedTag.add(tag.name);
                });
              } else {
                setState(() {
                  selectedTag.remove(tag.name);
                });
              }
            },
          );
        }).toList()
      ),
    );
  }

  Widget mcTrait() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 5,
        children: mcTraitlist.map((trait) {
          final isTraitSelected = selectedTag.contains(trait.personality);
          return ChoiceChip(
            label: Text(trait.personality), 
            selected: isTraitSelected,
            onSelected: (value) {
              if (value) {
                setState(() {
                  selectedTag.add(trait.personality);
                });
              } else {
                setState(() {
                  selectedTag.remove(trait.personality);
                });
              }
            },
          );
        }).toList()
      ),
    );
  }

  Widget genderOption() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 5,
        children: genderList.map((gender) {
          final genderSelected = selectedTag.contains(gender.gender);
          return ChoiceChip(
            label: Text(gender.gender), 
            selected: genderSelected,
            onSelected: (value) {
              if (value) {
                setState(() {
                  selectedTag.add(gender.gender);
                });
              } else {
                setState(() {
                  selectedTag.remove(gender.gender);
                });
              }
            },
          );
        }).toList()
      ),
    );
  }

  Widget nextBtn() {
    return Padding(
      padding: const EdgeInsets.only(left: 280),
      child: ElevatedButton(
        onPressed: () async {
          final uid = authService.value.currentUser!.uid;
            final db = FirebaseFirestore.instance;
            await db.collection('users').doc(uid).set(
              {'isNewUser': false},
              SetOptions(merge: true),
          );
          if (!mounted) return;

          Navigator.push(context, MaterialPageRoute(builder: (context) => AuthLayout()));
        }, 
        child: Text("Hoàn thành")
      ),
    );
  }
}