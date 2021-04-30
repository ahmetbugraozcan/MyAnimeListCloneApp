import 'package:flutter/material.dart';
import 'package:flutter_anichat/app/tab_page.dart';
import 'package:flutter_anichat/locator.dart';
import 'package:flutter_anichat/model/user.dart';
import 'package:flutter_anichat/viewmodel/user_model.dart';
import 'log_in_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _emailKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();
  UserModel _userModel = locator<UserModel>();
  bool _parolaGizle = true;
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("MAL"),
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
                Row(
                  children: [
                    Container(
                      height: 1.5,
                      width: MediaQuery.of(context).size.width / 2.8,
                      color: Colors.black38,
                    ),
                    Text("  or  "),
                    Container(
                      height: 1.5,
                      width: MediaQuery.of(context).size.width / 2.8,
                      color: Colors.black38,
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 9.86,
                  width: MediaQuery.of(context).size.width / 1.09,
                  child: TextFormField(
                    validator: (girilenEmail) {
                      if (!girilenEmail.contains('@')) {
                        return 'Please enter a valid e-mail';
                      } else {
                        _email = girilenEmail;
                        return null;
                      }
                    },
                    key: _emailKey,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Email",
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
                        return 'Please enter a password more than 3 characters.';
                      } else {
                        _password = girilenSifre;
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      suffix: _iconButtonOlustur(),
                      hintText: "Password",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: () async {
                      if (_passwordKey.currentState.validate()) {}
                      if (_emailKey.currentState.validate()) {}
                      if (_passwordKey.currentState.validate() &&
                          _emailKey.currentState.validate()) {
                        UserAcc _user =
                            await _userModel.createAccountWithEmailAndPassword(
                                _email, _password);
                        if (_user != null) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TabPage(
                                        user: _user,
                                      )));
                        } else {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            duration: Duration(seconds: 1),
                            content: Text("Bu e-posta zaten mevcut"),
                          ));
                          print("Usermodeldeki user null döndü");
                        }
                      }
                    },
                    color: Colors.blue[800],
                    child: Text(
                      "                              Sign Up                               ",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.black54),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LogInPage()));
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.blue[800]),
                        ),
                      ),
                    ],
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
        size: 20,
      ),
      onTap: () {
        setState(() {
          _parolaGizle = !_parolaGizle;
        });
      },
    );
  }
}
