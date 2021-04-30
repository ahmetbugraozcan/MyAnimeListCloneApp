import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_anichat/model/user.dart';

class FirebaseUserService {
  final firestoreInstance = FirebaseFirestore.instance;
  Future<bool> kullaniciAlanlariniOlustur(UserAcc userAcc) async {
    var sonuc = await firestoreInstance
        .collection("users")
        .doc("${userAcc.userID}")
        .set({
      "email": userAcc.email,
      "userID": userAcc.userID,
      "userName": userAcc.email + "123"
    });
  }
}
