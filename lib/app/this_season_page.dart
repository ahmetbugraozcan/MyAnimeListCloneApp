import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_anichat/app/user_add_anime_to_mylist.dart';
import 'package:flutter_anichat/locator.dart';
import 'package:flutter_anichat/model/anime.dart';
import 'package:flutter_anichat/my_widgets/add_anime_to_my_list.dart';
import 'package:flutter_anichat/services/myanimelist_api_call_methods.dart';
import 'package:flutter_anichat/services/oauth_auth_service.dart';
import 'package:flutter_anichat/utils/utils.dart';

import 'anime_detail_page.dart';

class ThisSeasonPage extends StatefulWidget {
  @override
  _ThisSeasonPageState createState() => _ThisSeasonPageState();
}

class _ThisSeasonPageState extends State<ThisSeasonPage> {
  static String dropDownMenuValue = "TV(new)";
  static List<Anime> thisSeasonAnimeList;
  MyAnimeListApiCall _myAnimeListApiCall = locator<MyAnimeListApiCall>();
  String thisSeason = "";
  bool yukleniyorMu = false;
  Utils _utils = locator<Utils>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    thisSeason = _myAnimeListApiCall.thisSeason;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: RefreshIndicator(
          onRefresh: () {
            setState(() {
              thisSeasonAnimeList = null;
            });
            return Future.delayed(Duration(seconds: 1));
          },
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.1,
                height: MediaQuery.of(context).size.height / 11.78,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    createDropDownMenu(),
                    Container(
                      padding: EdgeInsets.only(right: 60),
                      child: Text(
                        "$thisSeason 2021",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w300),
                      ),
                    ),
                    Icon(Icons.menu),
                  ],
                ),
              ),
              buildFlexible(),
            ],
          ),
        ),
      ),
    );
  }

  Flexible buildFlexible() {
    return Flexible(
      child: (thisSeasonAnimeList == null || yukleniyorMu)
          ? FutureBuilder(
              future: _myAnimeListApiCall
                  .thisSeasonAnimeleriGetir(dropDownMenuValue),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                thisSeasonAnimeList = snapshot.data;
                return (thisSeasonAnimeList == null || yukleniyorMu)
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : animeGridView();
              },
            )
          : animeGridView(),
    );
  }

  GridView animeGridView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 0,
        childAspectRatio: 0.76,
      ),
      itemCount: thisSeasonAnimeList.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => AnimeDetailPage(
                                id: thisSeasonAnimeList[index].id,
                              )));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Image.network(thisSeasonAnimeList[index].medium,
                              fit: BoxFit.fill,
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: MediaQuery.of(context).size.height / 3,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: MediaQuery.of(context).size.height / 3,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 4),
                                width: MediaQuery.of(context).size.width / 4.2,
                                height: MediaQuery.of(context).size.height / 14,
                                color: Color.fromRGBO(256, 256, 256, 0.7),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4, top: 2),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            thisSeasonAnimeList[index].mean == 0
                                                ? "N/A"
                                                : thisSeasonAnimeList[index]
                                                    .mean
                                                    .toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          Icon(
                                            Icons.star,
                                            size: 14,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4, top: 2),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            thisSeasonAnimeList[index]
                                                .numListUsers
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          Icon(
                                            Icons.person_outline,
                                            size: 16,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              AddAnimeToMyList(
                                ontap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              UserAddAnimeToMyList(
                                                anime:
                                                    thisSeasonAnimeList[index],
                                              ))).then((value) {
                                    setState(() {
                                      // refresh state of Page1
                                    });
                                  });
                                },
                                icon: thisSeasonAnimeList[index].myListStatus ==
                                        null
                                    ? Icon(
                                        Icons.playlist_add,
                                        color: Colors.black54,
                                      )
                                    : Icon(
                                        Icons.playlist_add_check,
                                        color: Colors.white,
                                      ),
                                decoration: BoxDecoration(
                                  color: thisSeasonAnimeList[index].myListStatus == null
                                      ? Colors.white
                                      : Map.from(thisSeasonAnimeList[index]
                                                  .myListStatus)['status'] ==
                                              "completed"
                                          ? Colors.blue[900]
                                          : Map.from(thisSeasonAnimeList[index].myListStatus)['status'] ==
                                                  "watching"
                                              ? Colors.green
                                              : Map.from(thisSeasonAnimeList[index].myListStatus)[
                                                          'status'] ==
                                                      "dropped"
                                                  ? Colors.red
                                                  : Map.from(thisSeasonAnimeList[index]
                                                              .myListStatus)['status'] ==
                                                          "plan_to_watch"
                                                      ? Colors.grey
                                                      : Colors.yellow,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                width:
                                    MediaQuery.of(context).size.width / 10.97,
                                height:
                                    MediaQuery.of(context).size.height / 16.91,
                                anime: thisSeasonAnimeList[index],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        _utils.doControlStringLength(
                            thisSeasonAnimeList[index].title, 45),
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400),
                        maxLines: 2,
                      ),
                      _utils.genreKontrol(thisSeasonAnimeList[index])
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  createDropDownMenu() {
    return DropdownButton<String>(
      underline: Container(),
      value: dropDownMenuValue,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      onChanged: (String newValue) {
        setState(() {
          //burada tab değişimimizde yeni bir api isteğinde bulunuyoruz dolayısıyla yukleniyorMu değişkeni ile bu aradaki boşlukları kontrol ediyoruz.
          if (newValue != dropDownMenuValue) {
            yukleniyorMu = true;
            dropDownMenuValue = newValue;
            _myAnimeListApiCall
                .thisSeasonAnimeleriGetir(dropDownMenuValue)
                .then((value) {
              if (mounted) {
                setState(() {
                  thisSeasonAnimeList = value;
                  yukleniyorMu = false;
                });
              }
            });
          }
        });
      },
      style: TextStyle(
          fontWeight: FontWeight.w300, color: Colors.black, fontSize: 16),
      items: <String>["TV(new)", "TV(cont'd)", "ONA", "OVA", "Movie", "Special"]
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
