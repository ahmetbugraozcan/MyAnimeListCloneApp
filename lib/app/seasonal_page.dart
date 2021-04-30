import 'package:flutter/material.dart';
import 'package:flutter_anichat/app/tab_page.dart';
import 'package:flutter_anichat/services/oauth_auth_service.dart';

class SeasonalPage extends StatefulWidget {
  @override
  _SeasonalPageState createState() => _SeasonalPageState();
}

class _SeasonalPageState extends State<SeasonalPage> {
  OAuthService oAuthService = OAuthService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Text(
            "BU SAYFAYA GELDİĞİMİZDE TAB PAGEDE BULUNAN APPBARTABLARI DEĞİŞTİĞİNDE BU SAYFANIN GÖVDESİ DEĞİŞECEK"));
  }
}
