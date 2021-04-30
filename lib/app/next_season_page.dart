import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_anichat/app/user_add_anime_to_mylist.dart';
import 'package:flutter_anichat/locator.dart';
import 'package:flutter_anichat/model/anime.dart';
import 'package:flutter_anichat/my_widgets/add_anime_to_my_list.dart';
import 'package:flutter_anichat/services/myanimelist_api_call_methods.dart';
import 'package:flutter_anichat/utils/utils.dart';

import 'anime_detail_page.dart';

class NextSeasonPage extends StatefulWidget {
  @override
  _NextSeasonPageState createState() => _NextSeasonPageState();
}

class _NextSeasonPageState extends State<NextSeasonPage> {
  static String dropDownMenuValue = "TV(new)";
  static List<Anime> nextSeasonAnimeList;
  MyAnimeListApiCall _myAnimeListApiCall = locator<MyAnimeListApiCall>();
  String nextSeason = "";
  bool yukleniyorMu = false;
  Utils _utils = locator<Utils>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nextSeason = _myAnimeListApiCall.nextSeason;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: RefreshIndicator(
          onRefresh: () {
            setState(() {
              nextSeasonAnimeList = null;
            });
            return Future.delayed(Duration(seconds: 1));
          },
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.1,
                height: MediaQuery.of(context).size.height / 11.84,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    createDropDownMenu(),
                    Container(
                      padding: EdgeInsets.only(right: 60),
                      child: Text(
                        "$nextSeason 2021",
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
      child: (nextSeasonAnimeList == null || yukleniyorMu)
          ? FutureBuilder(
              future: _myAnimeListApiCall
                  .nextSeasonAnimeleriGetir(dropDownMenuValue),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                nextSeasonAnimeList = snapshot.data;
                return (nextSeasonAnimeList == null || yukleniyorMu)
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
      itemCount: nextSeasonAnimeList.length,
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
                                id: nextSeasonAnimeList[index].id,
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
                          Image.network(nextSeasonAnimeList[index].medium,
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
                                            nextSeasonAnimeList[index].mean == 0
                                                ? "N/A"
                                                : nextSeasonAnimeList[index]
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
                                            nextSeasonAnimeList[index]
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
                                    )
                                  ],
                                ),
                              ),
                              AddAnimeToMyList(
                                ontap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UserAddAnimeToMyList(
                                                anime:
                                                    nextSeasonAnimeList[index],
                                              ))).then((value) {
                                    setState(() {
                                      // refresh state of Page1
                                    });
                                  });
                                },
                                icon: nextSeasonAnimeList[index].myListStatus ==
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
                                  color: nextSeasonAnimeList[index].myListStatus == null
                                      ? Colors.white
                                      : Map.from(nextSeasonAnimeList[index]
                                                  .myListStatus)['status'] ==
                                              "completed"
                                          ? Colors.blue[900]
                                          : Map.from(nextSeasonAnimeList[index].myListStatus)['status'] ==
                                                  "watching"
                                              ? Colors.green
                                              : Map.from(nextSeasonAnimeList[index].myListStatus)[
                                                          'status'] ==
                                                      "dropped"
                                                  ? Colors.red
                                                  : Map.from(nextSeasonAnimeList[index]
                                                              .myListStatus)['status'] ==
                                                          "plan_to_watch"
                                                      ? Colors.grey
                                                      : Colors.yellow,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                width:
                                    MediaQuery.of(context).size.width / 16.91,
                                height:
                                    MediaQuery.of(context).size.height / 10.97,
                                anime: nextSeasonAnimeList[index],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        _utils.doControlStringLength(
                            nextSeasonAnimeList[index].title, 45),
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400),
                        maxLines: 2,
                      ),
                      _utils.genreKontrol(nextSeasonAnimeList[index])
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
                .nextSeasonAnimeleriGetir(dropDownMenuValue)
                .then((value) {
              if (mounted) {
                setState(() {
                  nextSeasonAnimeList = value;
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
