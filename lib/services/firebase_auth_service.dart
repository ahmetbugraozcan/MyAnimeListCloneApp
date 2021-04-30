import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_anichat/locator.dart';
import 'package:flutter_anichat/model/user.dart';
import 'package:flutter_anichat/services/auth_service.dart';
import 'package:flutter_anichat/services/firebase_user_service.dart';
import 'package:flutter_anichat/viewmodel/user_model.dart';

class FirebaseAuthService implements AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUserService _userService = locator<FirebaseUserService>();
  @override
  Future<UserAcc> createAccountWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential _credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      UserAcc _user = _userFromFirebase(_credential.user);
      _userService.kullaniciAlanlariniOlustur(_user);
      return _user;
    } catch (ex) {
      print(ex.toString());
      return null;
    }
  }

  UserAcc _userFromFirebase(User user) {
    if (user == null) {
      return null;
    } else {
      UserAcc _userAcc = UserAcc.withEmail(email: user.email, uID: user.uid);
      return _userAcc;
    }
  }

  @override
  Future<UserAcc> currentUser() async {
    User _firebaseUser = await _auth.currentUser;
    UserAcc _currentUser = _userFromFirebase(_firebaseUser);
    return _currentUser;
  }

  @override
  Future<UserAcc> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential _credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      UserAcc _userAcc = _userFromFirebase(_credential.user);
      return _userAcc;
    } catch (ex) {
      print("Firebase auth service loginwithemailandpasswordde hata oluştu");
      return null;
    }
  }

  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      print("Çıkış yaparken hata oluştu : " + e.toString());
      return false;
    }
  }

  @override
  Future<UserAcc> createAccountWithUserData() {
    // TODO: implement createAccountWithUserData
    throw UnimplementedError();
  }
}
