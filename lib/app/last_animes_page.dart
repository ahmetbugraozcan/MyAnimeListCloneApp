import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_anichat/app/anime_detail_page.dart';
import 'package:flutter_anichat/app/seasonal_anime_page.dart';
import 'package:flutter_anichat/app/user_add_anime_to_mylist.dart';
import 'package:flutter_anichat/locator.dart';
import 'package:flutter_anichat/model/anime.dart';
import 'package:flutter_anichat/my_widgets/add_anime_to_my_list.dart';
import 'package:flutter_anichat/services/myanimelist_api_call_methods.dart';
import 'package:flutter_anichat/services/oauth_auth_service.dart';
import 'package:flutter_anichat/utils/utils.dart';

class LastAnimesPage extends StatefulWidget {
  @override
  _LastAnimesPageState createState() => _LastAnimesPageState();
}

// example
// padding: EdgeInsets.symmetric(vertical: screenHeight * 0.1, horizontal: screenWidth * 0.8),
// // this means give 10% of screen height as vertical value and 80% of screen width as horizontal value
class _LastAnimesPageState extends State<LastAnimesPage> {
  static String dropDownMenuValue = "TV(new)";
  static List<Anime> lastSeasonAnimeList;
  MyAnimeListApiCall _myAnimeListApiCall = locator<MyAnimeListApiCall>();
  String lastSeason = "";
  bool yukleniyorMu = false;
  Utils _utils = locator<Utils>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lastSeason = _myAnimeListApiCall.lastSeason;
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: RefreshIndicator(
          onRefresh: () {
            setState(() {
              lastSeasonAnimeList = null;
            });
            return Future.delayed(Duration(seconds: 1));
          },
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.1,
                height: MediaQuery.of(context).size.height / 15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    createDropDownMenu(),
                    Container(
                      padding: EdgeInsets.only(right: screenWidth * 0.15625),
                      child: Text(
                        "$lastSeason 2020",
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
      child: (lastSeasonAnimeList == null || yukleniyorMu)
          ? FutureBuilder(
              future: _myAnimeListApiCall
                  .lastSeasonAnimeleriGetir(dropDownMenuValue),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                lastSeasonAnimeList = snapshot.data;
                return (lastSeasonAnimeList == null || yukleniyorMu)
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
        mainAxisSpacing: 0,
        crossAxisCount: 2,
        // mainAxisSpacing: MediaQuery.of(context).size.height / 70,
        crossAxisSpacing: 0,
        childAspectRatio: 0.61,
      ),
      itemCount: lastSeasonAnimeList.length,
      itemBuilder: (BuildContext context, int index) {
        var screenHeight = MediaQuery.of(context).size.height;
        var screenWidth = MediaQuery.of(context).size.width;
        return Column(
          children: [
            //expanded vardı üstünde
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => AnimeDetailPage(
                              id: lastSeasonAnimeList[index].id,
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
                        Image.network(
                          lastSeasonAnimeList[index].medium,
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width / 2.2,
                          height: MediaQuery.of(context).size.height / 3,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: MediaQuery.of(context).size.height / 3,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: screenHeight * 0.0067),
                              width: MediaQuery.of(context).size.width / 4.2,
                              height: MediaQuery.of(context).size.height / 14,
                              color: Color.fromRGBO(256, 256, 256, 0.7),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: screenWidth * 0.010,
                                        top: screenHeight * 0.0033),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          lastSeasonAnimeList[index].mean == 0.0
                                              ? "N/A"
                                              : lastSeasonAnimeList[index]
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
                                    padding: EdgeInsets.only(
                                        left: screenWidth * 0.010,
                                        top: screenHeight * 0.0033),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          lastSeasonAnimeList[index]
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
                            //DİĞER SAYFALARA DA EKLENECEK
                            //API DEKİ GET ANIME DETAILS KISMINDAN YAPILACAK
                            AddAnimeToMyList(
                              ontap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UserAddAnimeToMyList(
                                              anime: lastSeasonAnimeList[index],
                                            ))).then((value) {
                                  setState(() {
                                    // refresh state of Page1
                                  });
                                });
                              },
                              icon: lastSeasonAnimeList[index].myListStatus ==
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
                                color: lastSeasonAnimeList[index]
                                            .myListStatus ==
                                        null
                                    ? Colors.white
                                    : Map.from(lastSeasonAnimeList[index].myListStatus)['status'] ==
                                            "completed"
                                        ? Colors.blue[900]
                                        : Map.from(lastSeasonAnimeList[index]
                                                    .myListStatus)['status'] ==
                                                "watching"
                                            ? Colors.green
                                            : Map.from(lastSeasonAnimeList[index].myListStatus)['status'] ==
                                                    "dropped"
                                                ? Colors.red
                                                : Map.from(lastSeasonAnimeList[index]
                                                            .myListStatus)['status'] ==
                                                        "plan_to_watch"
                                                    ? Colors.grey
                                                    : Colors.yellow,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              width: MediaQuery.of(context).size.width / 10.97,
                              height:
                                  MediaQuery.of(context).size.height / 16.91,
                              anime: lastSeasonAnimeList[index],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.0033),
                      child: Text(
                        _utils.doControlStringLength(
                            lastSeasonAnimeList[index].title, 45),
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                        maxLines: 2,
                      ),
                    ),
                    _utils.genreKontrol(lastSeasonAnimeList[index])
                  ],
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
                .lastSeasonAnimeleriGetir(dropDownMenuValue)
                .then((value) {
              if (mounted) {
                setState(() {
                  lastSeasonAnimeList = value;
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
