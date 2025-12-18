import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ValueNotìier dùng để quản lý trạng thái của AuthService trong ứng dụng Flutter.
// Nó cho phép các widget lắng nghe và phản hồi khi có sự thay đổi trong trạng thái xác thực người dùng.
// Bằng cách sử dụng ValueNotifier, chúng ta có thể dễ dàng cập nhật giao diện người dùng khi 
// người dùng đăng nhập, đăng xuất hoặc khi có sự thay đổi khác liên quan đến xác thực.
ValueNotifier<AuthService> authService = ValueNotifier(AuthService()); 

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email, 
      password: password
    );
  }

  Future<UserCredential> createAccount({
    required String email,
    required String password
  }) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email, 
      password: password);
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> resetPassword({
    required String email,
  }) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    AuthCredential credential =
      EmailAuthProvider.credential (email: email, password: password);
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.delete();
    await firebaseAuth.signOut();
  }

  Future<void> resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null ) {
      throw Exception('User havent login or user dont have a email');
    }
    AuthCredential credential =
      EmailAuthProvider.credential(email: user.email!, password: currentPassword);
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.updatePassword(newPassword);
  }
}