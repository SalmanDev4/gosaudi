import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signInWithEmail(String email, String password);
  Future<String> signUpWithEmail(String username, String email, String password);
  Future<void> resetPassword(String email);
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<String> signUpWithEmail(String username, String email, String password) async {
    UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    try{
      await user.user.sendEmailVerification();
      return user.user.uid;
    } catch (e){
      print('An Error occured while trying to send email verification');
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

}