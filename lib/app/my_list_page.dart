import 'package:flutter/material.dart';
import 'package:flutter_anichat/locator.dart';
import 'package:flutter_anichat/model/anime.dart';
import 'package:flutter_anichat/model/user.dart';
import 'package:flutter_anichat/services/myanimelist_api_call_methods.dart';

class MyListPage extends StatefulWidget {
  UserAcc currentUser;
  MyListPage({Key key, @required this.currentUser}) : super(key: key);
  @override
  _MyListPage createState() => _MyListPage();
}

//Buraya geldiğimizde tüm animeleri alıp listeleyebiliriz
//anime completed ise bitirilmiş ise bitirilmiş olanlara at tab sayfasına gönder
class _MyListPage extends State<MyListPage> {
  MyAnimeListApiCall _myAnimeListApiCall = locator<MyAnimeListApiCall>();
  UserAcc _currentUser;
  Anime anime;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentUser = widget.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 36,
                    child: Icon(
                      Icons.person,
                      size: 46,
                    ),
                  ),
                ),
                _currentUser.userName == null
                    ? Text("KULLANICININ LİSTESİNİN BULUNDUĞU SAYFA")
                    : Text(_currentUser.userName),
              ],
            ),
          ),
          Divider(
            height: 4,
          ),
        ],
      ),
    );
  }
}
