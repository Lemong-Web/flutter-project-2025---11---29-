import 'package:flutter/material.dart';
import 'package:manga_app/UI/Screens/login_page.dart';
import 'package:manga_app/UI/Screens/navigation.dart';
import 'package:manga_app/auth_service.dart';

class AuthLayout extends StatefulWidget {
  const AuthLayout({super.key});

  @override
  State<AuthLayout> createState() => _AuthLayoutState();
}

class _AuthLayoutState extends State<AuthLayout> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authService, child){
        return StreamBuilder(
          stream: authService.authStateChanges, 
          builder: (context, snapshot) {
             Widget widget;
             if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
             } else if (snapshot.hasData) {
              widget = const Navigation();
             } else {
              widget = const LoginPage();
             }
             return widget;
          }
        );
      }
    );
  }
}