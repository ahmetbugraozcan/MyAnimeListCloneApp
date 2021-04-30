import 'package:flutter_anichat/model/user.dart';

abstract class AuthService {
  Future<UserAcc> createAccountWithEmailAndPassword(
      String email, String password);
  Future<UserAcc> createAccountWithUserData();
  Future<UserAcc> currentUser();
  Future<UserAcc> loginWithEmailAndPassword(String email, String password);
  Future<bool> signOut();
}
