import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_anichat/app/edit_profile_page.dart';
import 'package:flutter_anichat/locator.dart';
import 'package:flutter_anichat/model/user.dart';
import 'package:flutter_anichat/utils/utils.dart';
import 'package:flutter_anichat/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  UserModel _userModel = locator<UserModel>();
  Utils _utils = locator<Utils>();
  UserAcc _userAcc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    // _userAcc = _userModel.user;
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var userModel = Provider.of<UserModel>(context, listen: true);
    _userAcc = userModel.user;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Image.asset(
          "assets/myanimelist_symbol.png",
          scale: 5,
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF2e51a2),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 9.8,
            color: Color(0xFF2e51a2),
          ),
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    color: Colors.red,
                    height: MediaQuery.of(context).size.height / 4.4848,
                    width: MediaQuery.of(context).size.width / 4.2,
                    child: Image.network(
                      _userAcc.profilePhotoUrl,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 4.93,
                    width: MediaQuery.of(context).size.width / 1.75,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(_userAcc.userName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.black54,
                                  size: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    "${_utils.dateYaz(_userAcc.joinedAt.substring(0, 10))}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black54),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 26.9,
                              // decoration: BoxDecoration(
                              //   border: Border.all(color: Colors.black38),
                              //   borderRadius:
                              //       BorderRadius.all(Radius.circular(12)),
                              // ),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    side: BorderSide(color: Colors.black54)),
                                elevation: 0,
                                color: Colors.white,
                                child: Text(
                                  "Edit profile",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      (context),
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              EditProfilePage()));
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Icon(
                          Icons.person,
                          color: Colors.black54,
                          size: 15,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          _utils.basHarfiBuyukYaz(_userAcc.gender),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 14.0),
                        child: Icon(
                          Icons.cake,
                          color: Colors.black54,
                          size: 15,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          "${_utils.dateYaz(_userAcc.birthday)}",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 14.0),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.black54,
                          size: 15,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          "${_userAcc.location}",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 20, left: 23, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Anime Days",
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                    Text(
                      "Completed",
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                    Text(
                      "Mean Score",
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 23, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${_userAcc.numDays}",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    Text(
                      "${_userAcc.numItemsCompleted}",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    Text(
                      "${_userAcc.meanScore}",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.blue[900],
                margin: EdgeInsets.only(left: 23, right: 20, top: 5),
                child: Row(
                  children: [
                    Container(
                      width: _userAcc.numDays / 10,
                      height: MediaQuery.of(context).size.height / 45.53,
                      color: Colors.green,
                      constraints: BoxConstraints(
                        minWidth: 0,
                        maxWidth: MediaQuery.of(context).size.width / 1.127,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 13),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                    Text(
                      "${_userAcc.numItemsCompleted + _userAcc.numItemsWatching + _userAcc.numItemsOnHold + _userAcc.numItemsDropped} Anime List Entries",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    //This is for background color
                    color: Colors.white.withOpacity(0.0),
                    //This is for bottom border that is needed
                    border: Border(
                        bottom: BorderSide(color: Colors.black54, width: 0.5))),
                child: TabBar(
                  indicatorWeight: 2,
                  indicatorColor: Colors.blue[900],
                  unselectedLabelColor: Colors.black54,
                  labelColor: Colors.blue[900],
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(
                      icon: Container(
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _tabController.index == 0 ? Icons.favorite : null,
                              size: 12,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 3.0),
                              child: Text("Anime"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Tab(
                      icon: Container(
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _tabController.index == 1 ? Icons.favorite : null,
                              size: 12,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 3.0),
                              child: Text("Characters"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Tab(
                      icon: Container(
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _tabController.index == 2 ? Icons.favorite : null,
                              size: 12,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 3.0),
                              child: Text("People"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('No favorite anime yet.'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('No favorite character yet.'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('No favorite people yet.'),
                      ),
                    ],
                    controller: _tabController,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
