import 'package:flutter/material.dart';
import 'package:flutter_anichat/locator.dart';
import 'package:flutter_anichat/model/user.dart';
import 'package:flutter_anichat/utils/utils.dart';
import 'package:flutter_anichat/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  UserModel _userModel = locator<UserModel>();
  Utils _utils = locator<Utils>();
  UserAcc _userAcc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _userAcc = _userModel.user;
  }

  @override
  Widget build(BuildContext context) {
    var userModel = Provider.of<UserModel>(context, listen: true);
    _userAcc = userModel.user;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height / 12.59),
        child: AppBar(
          title: Text(
            "Edit Profile",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w300, fontSize: 18),
          ),
          elevation: 1,
          backgroundColor: Colors.white,
          leading: new IconButton(
            icon: new Icon(Icons.close, color: Colors.black54),
            onPressed: () => Navigator.of(context).pop(),
          ),
          titleSpacing: 10,
          actions: [
            FlatButton(
              child: Text(
                "Save",
                style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 16,
                    fontWeight: FontWeight.w300),
              ),
              onPressed: () {},
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width / 4.26,
                height: MediaQuery.of(context).size.height / 4.22,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 18),
                    child: Text(
                      "${_userAcc.userName}",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.25,
                      child: Text(
                        "Please use Account Settings to modify your preferred name.",
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 20, top: 10, right: 20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      "Gender",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("${_utils.basHarfiBuyukYaz(_userAcc.gender)}"),
                  ),
                ),
                Divider(
                  color: Colors.black,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.only(top: 14, bottom: 10),
                      child: Text(
                        "Birthday",
                        style: TextStyle(color: Colors.black54),
                      )),
                ),
                InkWell(
                  onTap: () {},
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(_utils.dateYaz(_userAcc.birthday)),
                  ),
                ),
                Divider(
                  color: Colors.black,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 14, bottom: 10),
                    child: Text(
                      "Location",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _userAcc.location,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.black,
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 16.91,
          ),
          Divider(
            color: Colors.black,
            thickness: 0.3,
            height: 1,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 12),
              child: Text(
                "All profile information will be publicly available.",
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13),
              ),
            ),
          )
        ],
      ),
    );
  }
}
