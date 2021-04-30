import 'package:flutter_anichat/locator.dart';
import 'package:flutter_anichat/model/user.dart';
import 'package:flutter_anichat/services/auth_service.dart';
import 'package:flutter_anichat/services/firebase_auth_service.dart';
import 'package:flutter_anichat/services/oauth_auth_service.dart';

enum AppMode { DEBUG, RELEASE, RELEASEOAUTH }

class UserRepository implements AuthService {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  OAuthService _oAuthService = locator<OAuthService>();
  AppMode appMode = AppMode.RELEASEOAUTH;
  @override
  Future<UserAcc> createAccountWithEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.RELEASE) {
      UserAcc _user = await _firebaseAuthService
          .createAccountWithEmailAndPassword(email, password);
      if (_user != null) {
        return _user;
      } else
        return null;
    } else if (appMode == AppMode.RELEASEOAUTH) {
      return null;
    }
  }

  @override
  Future<UserAcc> currentUser() async {
    if (appMode == AppMode.RELEASE) {
      return await _firebaseAuthService.currentUser();
    } else if (appMode == AppMode.RELEASEOAUTH) {
      return await _oAuthService.currentUser();
    }
  }

  @override
  Future<UserAcc> loginWithEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.RELEASE) {
      UserAcc _user =
          await _firebaseAuthService.loginWithEmailAndPassword(email, password);
      if (_user != null) {
        return _user;
      } else
        return null;
    } else if (appMode == AppMode.RELEASEOAUTH) {}
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.RELEASE) {
      return await _firebaseAuthService.signOut();
    } else if (appMode == AppMode.RELEASEOAUTH) {
      return await _oAuthService.signOut();
    }
  }

  @override
  Future<UserAcc> createAccountWithUserData() async {
    if (appMode == AppMode.RELEASEOAUTH) {
      return await _oAuthService.createAccountWithUserData();
    }
  }
}
