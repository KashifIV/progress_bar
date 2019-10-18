import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthImpl {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<String> getCurrentUser();
  Future<void> signOut();
  String getUID();
}

class Auth implements AuthImpl {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String uid = '----';
  String email; 
  String getUID(){
    return uid;
  }
  String getEmail(){
    return email; 
  }
  Future<String> signIn(String email, String password) async {
    this.email = email; 
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user; 
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    this.email = email; 
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<String> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if (user == null)
      return null;
    else {
      email = user.email;
      uid = user.uid;
      return user.uid;
    }
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}