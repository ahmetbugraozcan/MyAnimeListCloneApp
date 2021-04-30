import 'package:flutter/material.dart';
import 'package:flutter_anichat/app/tab_page.dart';
import 'package:flutter_anichat/app/log_in_page.dart';
import 'package:flutter_anichat/app/welcome_page.dart';
import 'package:flutter_anichat/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

import 'oauth_login_page.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context, listen: true);
    if (_userModel.state == ViewState.Idle) {
      if (_userModel.user == null) {
        Future.delayed(Duration(seconds: 1));
        // return LogInPage();
        return OAuthLoginPage();
      } else {
        Future.delayed(Duration(seconds: 1));
        return TabPage(user: _userModel.user);
      }
    } else {
      return WelcomePage();
    }
  }
}
