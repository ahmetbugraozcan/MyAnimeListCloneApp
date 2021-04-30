import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_anichat/app/landing_page.dart';
import 'package:flutter_anichat/app/tab_page.dart';
import 'package:flutter_anichat/app/welcome_page.dart';
import 'package:flutter_anichat/locator.dart';
import 'package:flutter_anichat/model/user.dart';
import 'package:flutter_anichat/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class OAuthLoginPage extends StatefulWidget {
  @override
  _OAuthLoginPageState createState() => _OAuthLoginPageState();
}

class _OAuthLoginPageState extends State<OAuthLoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Image> images = [
      Image.asset(
        "assets/wallpaper.jpg",
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        fit: BoxFit.cover,
      ),
      Image.asset(
        "assets/wallpaper2.jpg",
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        fit: BoxFit.cover,
      )
    ];
    Random random = new Random();
    int randomNumber = random.nextInt(images.length);
    final _userModel = Provider.of<UserModel>(context, listen: true);
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Stack(
          children: [
            Container(
              child: images[randomNumber],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    child: RaisedButton(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                      onPressed: () async {
                        UserAcc _userAcc =
                            await _userModel.createAccountWithUserData();
                        if (_userAcc != null) {
                        } else {
                          print("Bir hata oluştu.. OAuth Login Page");
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("Giriş işlemi başarısız oldu..."),
                          ));
                        }
                      },
                      child: Text("Login"),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
