import 'package:flutter/material.dart';
import 'package:flutter_anichat/app/sign_up_page.dart';
import 'package:flutter_anichat/app/tab_page.dart';
import 'package:flutter_anichat/locator.dart';
import 'package:flutter_anichat/model/user.dart';
import 'package:flutter_anichat/viewmodel/user_model.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _emailKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  UserModel _userModel = locator<UserModel>();
  String _email;
  String _password;
  bool _parolaGizle = true;
  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        centerTitle: true,
        title: Text(
          "MAL",
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 40),
            child: Column(
              children: [
                RaisedButton(
                  color: Colors.black,
                  child: Text(
                    "            Sign in with Apple                             ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  onPressed: () {},
                ),
                RaisedButton(
                  color: Colors.white,
                  child: Text(
                    "            Sign in with Google                             ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  onPressed: () {},
                ),
                RaisedButton(
                  color: Color(0xFF4267b2),
                  child: Text(
                    "            Sign in with Facebook                             ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  onPressed: () {},
                ),
                RaisedButton(
                  color: Color(0xFF1DA1F2),
                  child: Text(
                    "            Sign in with Twitter                             ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  onPressed: () {},
                ),
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 9.86,
                  width: MediaQuery.of(context).size.width / 1.09,
                  child: TextFormField(
                    key: _emailKey,
                    validator: (girilenEmail) {
                      if (girilenEmail.isEmpty) {
                        setState(() {
                          _errorMessage =
                              '* Incorrect username and/or password';
                        });
                      } else {}
                      _email = girilenEmail;
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Username",
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 9.86,
                  width: MediaQuery.of(context).size.width / 1.09,
                  child: TextFormField(
                    obscureText: _parolaGizle,
                    key: _passwordKey,
                    validator: (girilenSifre) {
                      if (girilenSifre.length < 3) {
                        setState(() {
                          _errorMessage =
                              '* Incorrect username and/or password';
                        });
                      } else {}
                      _password = girilenSifre;
                      return null;
                    },
                    decoration: InputDecoration(
                      suffix: _iconButtonOlustur(),
                      hintText: "Password",
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: () async {
                    if (_emailKey.currentState.validate()) {
                      // print('Email Başarılı');
                    }
                    if (_passwordKey.currentState.validate()) {
                      // print("Şifre başarılı");
                    }
                    if (_emailKey.currentState.validate() &&
                        _passwordKey.currentState.validate()) {
                      UserAcc _user = await _userModel
                          .loginWithEmailAndPassword(_email, _password);
                      if (_user != null) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TabPage(user: _user)));
                      } else {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text("Email veya şifre yanlış"),
                        ));
                      }
                    }
                  },
                  color: Colors.blue[800],
                  child: Text(
                    "                            Sign in                             ",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                Text("Don't have an account?",
                    style: TextStyle(color: Colors.black54)),
                FlatButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                  child: Text(
                    "Create Account",
                    style: TextStyle(color: Colors.blue[900]),
                  ),
                ),
                FlatButton(
                  onPressed: () {},
                  child: Text(
                    "Continue as Guest",
                    style: TextStyle(color: Colors.blue[900]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconButtonOlustur() {
    return GestureDetector(
      child: Icon(
        Icons.remove_red_eye,
      ),
      onTap: () {
        setState(() {
          _parolaGizle = !_parolaGizle;
        });
        print(_parolaGizle.toString());
      },
    );
  }
}
