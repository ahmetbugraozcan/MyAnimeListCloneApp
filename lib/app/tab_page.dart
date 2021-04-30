import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_anichat/app/last_animes_page.dart';
import 'package:flutter_anichat/app/search_page.dart';
import 'package:flutter_anichat/app/log_in_page.dart';
import 'package:flutter_anichat/app/oauth_login_page.dart';
import 'package:flutter_anichat/app/profile_page.dart';
import 'package:flutter_anichat/app/seasonal_page.dart';
import 'package:flutter_anichat/app/user_all_anime_page.dart';
import 'package:flutter_anichat/app/user_completed_anime_page.dart';
import 'package:flutter_anichat/app/user_dropped_page.dart';
import 'package:flutter_anichat/app/user_on_hold_page.dart';
import 'package:flutter_anichat/app/user_plan_to_watch_page.dart';
import 'package:flutter_anichat/app/user_watching_anime_page.dart';
import 'package:flutter_anichat/model/user.dart';
import 'package:flutter_anichat/repository/user_repository.dart';
import 'package:flutter_anichat/services/firebase_auth_service.dart';
import 'package:flutter_anichat/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

import '../locator.dart';
import 'my_list_page.dart';
import 'this_season_page.dart';
import 'archive_page.dart';
import 'next_season_page.dart';

class TabPage extends StatefulWidget {
  final UserAcc user;

  TabPage({Key key, @required this.user}) : super(key: key);
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with TickerProviderStateMixin {
  TabController _seasonalTabController;
  TabController _myListTabController;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  UserRepository repository = locator<UserRepository>();

  int bottomBarCurrentIndex = 0;
  int seasonalTabBarCurrentIndex = 0;
  int mylistTabBarCurrentIndex = 0;
  UserModel _userModel;
  List<Widget> _bottomTabSayfalari;
  List<Widget> _seasonalPageTabSayfalari;
  List<Widget> _myListPageTabSayfalari;

  UserAcc _currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _currentUser = widget.user;
    _seasonalTabController = TabController(length: 3, vsync: this);
    _myListTabController = TabController(length: 6, vsync: this);
    _myListPageTabSayfalari = [
      // ALL - WATCHING - COMPLETED - ON HOLD - DROPPED - PLAN TO WATCH
      UserAllAnimePage(),
      UserWatchingAnimePage(),
      UserCompletedAnimePage(),
      UserOnHoldPage(),
      UserDroppedPage(),
      UserPlanToWatchPage(),
    ];
    _seasonalPageTabSayfalari = [
      LastAnimesPage(),
      ThisSeasonPage(),
      NextSeasonPage(),
      // ArchivePage(),
    ];

    _bottomTabSayfalari = <Widget>[
      HomePage(),
      SeasonalPage(),
      MyListPage(
        currentUser: widget.user,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModel>(context, listen: true);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        drawer: drawerOlustur(),
        appBar: AppBar(
          elevation: 0,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Container(
                  width: MediaQuery.of(context).size.width / 10.97,
                  height: MediaQuery.of(context).size.height / 16.91,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(_currentUser.profilePhotoUrl),
                    ),
                  ),
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          title: Image.asset(
            "assets/myanimelist_symbol.png",
            scale: 5,
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF2e51a2),
          bottom: bottomBarCurrentIndex == 1
              ? seasonalBottomTabOlustur()
              : bottomBarCurrentIndex == 2 ? myListBottomTabOlustur() : null,
        ),
        bottomNavigationBar: bottomNavigationBarOlustur(),
        key: _scaffoldKey,
        body: Container(
          child: bottomBarCurrentIndex == 0
              ? _bottomTabSayfalari[bottomBarCurrentIndex]
              : bottomBarCurrentIndex == 1
                  ? _seasonalPageTabSayfalari[seasonalTabBarCurrentIndex]
                  : _myListPageTabSayfalari[mylistTabBarCurrentIndex],
        ),
      ),
    );
  }
  //

  Widget drawerOlustur() {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 5.92,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                Future.delayed(Duration(milliseconds: 500)).then((value) =>
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => ProfilePage())));
              },
              child: DrawerHeader(
                padding: EdgeInsets.fromLTRB(
                    screenWidth * 0.041,
                    screenHeight * 0.027,
                    screenWidth * 0.041,
                    screenHeight * 0.013),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.black,
                        width: screenWidth * 0.0013,
                        style: BorderStyle.solid),
                  ),
                ),
                margin: EdgeInsets.all(screenWidth * 0),
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: screenWidth * 0.08,
                        child: _currentUser.profilePhotoUrl == null
                            ? Icon(
                                Icons.person,
                                size: screenWidth * 0.08,
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          _currentUser.profilePhotoUrl),
                                      fit: BoxFit.fill),
                                ),
                              ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: screenWidth * 0.020,
                                top: screenHeight * 0.030),
                            child: Text(
                              _currentUser.userName == null
                                  ? "UserName"
                                  : _currentUser.userName,
                              style: TextStyle(
                                  color: Colors.blue[800],
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth * 0.036),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: screenWidth * 0.020,
                                top: screenHeight * 0.008),
                            child: Text(
                              "Profile",
                              style: TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth * 0.036),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 74,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 16.91,
            child: FlatButton(
              onPressed: () {},
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Account Settings",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: screenWidth * 0.036),
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 16.91,
            child: FlatButton(
              onPressed: () {},
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "App Settings",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: screenWidth * 0.036),
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.black,
            height: screenHeight * 0.027,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 16.91,
            child: FlatButton(
              onPressed: () {},
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Help / FAQ",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: screenWidth * 0.036),
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 16.91,
            child: FlatButton(
              onPressed: () {},
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Contact Support",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: screenWidth * 0.036),
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.black,
            height: screenHeight * 0.027,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 16.91,
            child: FlatButton(
              onPressed: () {},
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Terms of Use",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: screenWidth * 0.036),
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 16.91,
            child: FlatButton(
              onPressed: () {},
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Privacy Policy",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: screenWidth * 0.036),
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 16.91,
            child: FlatButton(
              onPressed: () {},
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Cookie Policy",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: screenWidth * 0.036),
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 16.91,
            child: FlatButton(
              onPressed: () {},
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Notice at Collection",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: screenWidth * 0.036),
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 16.91,
            child: FlatButton(
              onPressed: () {},
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Open Source License",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: screenWidth * 0.036),
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 10.76,
          ),
          Divider(
            color: Colors.black,
            height: screenHeight * 0.027,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 16.91,
            child: FlatButton(
              onPressed: () {
                // //Future delayed then yapıp sign outu onun içinde yapabilir o sırada sign out olurken bir circularprogressindicator gösterebiliriz.
                // Future.delayed(Duration(seconds: 1));
                _userModel.signOut();
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Logout",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: screenWidth * 0.036),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget myListBottomTabOlustur() {
    return TabBar(
      indicatorColor: Colors.white,
      isScrollable: true,
      controller: _myListTabController,
      onTap: (seciliIndex) {
        setState(() {
          mylistTabBarCurrentIndex = seciliIndex;
        });
      },
      tabs: [
        Tab(
          child: Text(
            "ALL",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
        Tab(
          child: Text(
            "Watching",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
        Tab(
          child: Text(
            "Completed",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
        Tab(
          child: Text(
            "On Hold",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
        Tab(
          child: Text(
            "Dropped",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
        Tab(
          child: Text(
            "Plan to Watch",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  Widget seasonalBottomTabOlustur() {
    return TabBar(
      indicatorColor: Colors.white,
      controller: _seasonalTabController,
      onTap: (seciliIndex) {
        setState(() {
          seasonalTabBarCurrentIndex = seciliIndex;
        });
      },
      tabs: [
        Tab(
          child: Text(
            "Last",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
        Tab(
          child: Text(
            "This Season",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
        Tab(
          child: Text(
            "Next",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
        // Tab(
        //   child: Container(
        //     child: Text(
        //       "Archive",
        //       style: TextStyle(fontWeight: FontWeight.w400),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  bottomNavigationBarOlustur() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      elevation: 16,
      currentIndex: bottomBarCurrentIndex,
      onTap: (int secilenIndex) {
        setState(() {
          bottomBarCurrentIndex = secilenIndex;
        });
      },
      items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
            title: Text("Search")),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_today,
            ),
            title: Text("Seasonal")),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
            ),
            title: Text("My List")),
      ],
    );
  }
}
