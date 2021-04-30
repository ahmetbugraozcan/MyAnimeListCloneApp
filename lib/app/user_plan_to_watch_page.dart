import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_anichat/locator.dart';
import 'package:flutter_anichat/model/anime.dart';
import 'package:flutter_anichat/model/user.dart';
import 'package:flutter_anichat/my_widgets/add_anime_to_my_list.dart';
import 'package:flutter_anichat/services/myanimelist_api_call_methods.dart';
import 'package:flutter_anichat/utils/utils.dart';
import 'package:flutter_anichat/viewmodel/user_model.dart';

import 'anime_detail_page.dart';

class UserPlanToWatchPage extends StatefulWidget {
  @override
  _UserPlanToWatchPageState createState() => _UserPlanToWatchPageState();
}

class _UserPlanToWatchPageState extends State<UserPlanToWatchPage> {
  MyAnimeListApiCall _myAnimeListApiCall = locator<MyAnimeListApiCall>();
  UserModel _userModel = locator<UserModel>();
  UserAcc _userAcc;
  Utils _utils = locator<Utils>();

  static List<Anime> planToWatchList = [];
  @override
  void initState() {
    super.initState();
    _userAcc = _userModel.user;
    if (_myAnimeListApiCall.list.length >= 0) {
      planToWatchList = _myAnimeListApiCall
          .planToWatchListeyiDondur(_myAnimeListApiCall.list);
      // print(_userAcc.numItemsPlanToWatch);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _userAcc.numItemsPlanToWatch == null
        ? RefreshIndicator(
            onRefresh: () {
              return Future.delayed(Duration(seconds: 3));
            },
            child: Center(
              child: Text("Bir anime izlenecekler listesinde değil"),
            ),
          )
        : _myAnimeListApiCall.list.length <= 0
            ? RefreshIndicator(
                onRefresh: () {
                  if (this.mounted) {
                    setState(() {
                      _myAnimeListApiCall
                          .userListGetir(_userAcc.numItems)
                          .then((value) {
                        planToWatchList = [];
                        if (this.mounted) {
                          setState(() {
                            planToWatchList = _myAnimeListApiCall
                                .planToWatchListeyiDondur(value);
                          });
                        }
                      });
                    });
                  }
                  return Future.delayed(Duration(seconds: 3));
                },
                child: Container(
                  child: Center(
                      child: FutureBuilder(
                    future: planToWatchList.length <= 0
                        ? _myAnimeListApiCall.userListGetir(_userAcc.numItems)
                        : null,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                      } else {
                        planToWatchList = _myAnimeListApiCall
                            .planToWatchListeyiDondur(snapshot.data);
                        // print(planToWatchList.length.toString() +
                        //     " datamızın uzunluğu");
                      }
                      return planToWatchList.length <= 0
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : buildPlanToWatchPageView();
                    },
                  )),
                ),
              )
            : RefreshIndicator(
                onRefresh: () {
                  if (this.mounted) {
                    setState(() {
                      _myAnimeListApiCall
                          .userListGetir(_userAcc.numItems)
                          .then((value) {
                        planToWatchList = [];
                        if (this.mounted) {
                          setState(() {
                            planToWatchList = _myAnimeListApiCall
                                .planToWatchListeyiDondur(value);
                          });
                        }
                      });
                    });
                  }
                  return Future.delayed(Duration(seconds: 3));
                },
                child: Center(
                  child: buildPlanToWatchPageView(),
                ),
              );
  }

  ListView buildPlanToWatchPageView() {
    return ListView.builder(
        itemCount: planToWatchList.length,
        itemBuilder: (BuildContext context, int index) {
          var anime = planToWatchList[index];
          return Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => AnimeDetailPage(
                                id: anime.id,
                              )));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Image.network(anime.medium,
                          // scale: 3,
                          width: MediaQuery.of(context).size.width / 5.12,
                          height: MediaQuery.of(context).size.height / 5.63,
                          fit: BoxFit.fill, loadingBuilder:
                              (BuildContext context, Widget child,
                                  ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: MediaQuery.of(context).size.width / 5.12,
                          height: MediaQuery.of(context).size.height / 5.63,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: 1,
                            ),
                          ),
                        );
                      }),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width:
                                    MediaQuery.of(context).size.width / 1.536,
                                child: Text(
                                  _utils.doControlStringLength(anime.title, 55),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Text(
                                  _utils.basHarfiBuyukYaz(anime.mediaType) +
                                      ", " +
                                      _utils.dateAndSeason(anime.startDate),
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 13),
                                ),
                              ),
                              // Container(
                              //   margin: EdgeInsets.symmetric(
                              //       vertical: 25),
                              //   width: 230,
                              //   height: 10,
                              //   color: Colors.grey,
                              // ),
                              SizedBox(
                                height: anime.title.length < 25 ? 10 : 0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 10, bottom: 4),
                                    color: Colors.grey[300],
                                    width: MediaQuery.of(context).size.width /
                                        1.66,
                                    height: MediaQuery.of(context).size.height /
                                        53.81,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: anime.numWatchedEpisodes != 0
                                              ? anime.numEpisodes == 0
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1.66 /
                                                      2
                                                  : anime.numWatchedEpisodes /
                                                      anime.numEpisodes *
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1.66
                                              : 0,
                                          color: anime.animeUserStatus ==
                                                  "completed"
                                              ? Colors.blue[900]
                                              : Colors.green[500],
                                          constraints: BoxConstraints(
                                            minWidth: 0,
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.66,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                        text: anime.numWatchedEpisodes == null
                                            ? "??"
                                            : anime.numWatchedEpisodes
                                                .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                            color: Colors.black),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: anime.numEpisodes == 0
                                                  ? " / " + "?? EP"
                                                  : " / " +
                                                      anime.numEpisodes
                                                          .toString() +
                                                      " EP",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w300))
                                        ]),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.height / 12.8,
                            height: MediaQuery.of(context).size.height / 11.58,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black38),
                                borderRadius: BorderRadius.circular(4)),
                            child: AddAnimeToMyList(
                              margin: EdgeInsets.all(2),
                              anime: anime,
                              width: MediaQuery.of(context).size.width / 12.8,
                              height:
                                  MediaQuery.of(context).size.height / 19.73,
                              icon: Icon(
                                Icons.edit,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.black54,
                height: 1,
              ),
            ],
          );
        });
  }
}
