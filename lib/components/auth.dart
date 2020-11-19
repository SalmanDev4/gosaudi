import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signInWithEmail(String email, String password);
  Future<String> signUpWithEmail(String email, String password);
  Future<void> resetPassword(String email);
  Future<void> signOut();
  Future<void> deleteAccount();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<String> signUpWithEmail(String email, String password) async {
    UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    try{
      if(user.user.emailVerified) return user.user.uid;
    } catch (e){
      print('An Error occured while trying  email verification');
      print(e);
    }
    return null;
  }

  @override
  Future<String> signInWithEmail(String email, String password) async{
    UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

    if(user.user.emailVerified) return user.user.uid;
    return null;
  }

  @override
  Future<void> resetPassword(String email) async{
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }

@override
  Future<void> deleteAccount() async{
    if(_firebaseAuth.currentUser.uid.isNotEmpty) {
      _firebaseAuth.currentUser.delete();
    }
  }
}

class EmailValidator{
  static String validate(String value){
    if(value.isEmpty) {
      return "Email can't be empty";
    }
    return null;
  }
}

class PasswordValidator{
  static String validate(String value){
    if(value.isEmpty) {
      return "Password can't be empty";
    }
    return null;
  }
}