import 'package:flutter/cupertino.dart';
import 'package:flutter_anichat/locator.dart';
import 'package:flutter_anichat/model/user.dart';
import 'package:flutter_anichat/repository/user_repository.dart';
import 'package:flutter_anichat/services/auth_service.dart';

enum ViewState { Idle, Busy }

class UserModel with ChangeNotifier implements AuthService {
  UserRepository _userRepository = locator<UserRepository>();
  static UserAcc _user;

  UserAcc get user => _user;

  ViewState _state = ViewState.Idle;
  ViewState get state => _state;

  set state(ViewState state) {
    _state = state;
    notifyListeners();
  }

  UserModel() {
    currentUser();
  }
  @override
  Future<UserAcc> createAccountWithEmailAndPassword(
      String email, String password) async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.createAccountWithEmailAndPassword(
          email, password);
      if (_user != null) {
        return _user;
      } else
        return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  Future<UserAcc> currentUser() async {
    state = ViewState.Busy;
    try {
      _user = await _userRepository.currentUser();
      if (_user != null) {
        return _user;
      } else
        return null;
    } catch (e) {
      print("Viewmodeldeki usermodelde hata var " + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserAcc> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      state = ViewState.Busy;
      UserAcc _user =
          await _userRepository.loginWithEmailAndPassword(email, password);
      if (_user != null) {
        return _user;
      } else
        return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;
      bool sonuc = await _userRepository.signOut();
      _user = null;
      return sonuc;
    } catch (e) {
      print("USERMODEL SIGNOUT HATA : " + e.toString());
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserAcc> createAccountWithUserData() async {
    try {
      state = ViewState.Busy;
      // print("Şuan busy : " + state.toString());
      _user = await _userRepository.createAccountWithUserData();
      if (_user != null) {
        return _user;
      } else {
        return null;
      }
    } catch (e) {
      print("Başarısız createaccwithuserdata");
    } finally {
      // print("Şuan idle");
      state = ViewState.Idle;
    }
  }
}
