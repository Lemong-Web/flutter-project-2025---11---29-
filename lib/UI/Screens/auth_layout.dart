import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/UI/Screens/intro_splash_screen.dart';
import 'package:manga_app/UI/Screens/login_page.dart';
import 'package:manga_app/UI/Screens/navigation.dart';

class AuthLayout extends StatefulWidget {
  const AuthLayout({super.key});

  @override
  State<AuthLayout> createState() => _AuthLayoutState();
}

class _AuthLayoutState extends State<AuthLayout> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } if (!snapshot.hasData) {
          return LoginPage();
        } 
          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
              .collection('users')
              .doc(snapshot.data!.uid)
              .snapshots(),
            builder: (context, userSnapshot){
              if (!userSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final data = userSnapshot.data!.data() as Map<String, dynamic>?; 
              final isNewUser = data?['isNewUser'] ?? true;

            return isNewUser
             ? IntroSplashScreen()
             : Navigation();
          }
        );
      }
    );
  }
}