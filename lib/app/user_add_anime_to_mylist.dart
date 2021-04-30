import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_anichat/locator.dart';
import 'package:flutter_anichat/model/anime.dart';
import 'package:flutter_anichat/services/myanimelist_api_call_methods.dart';
import 'package:flutter_anichat/utils/utils.dart';
import 'package:numberpicker/numberpicker.dart';

class UserAddAnimeToMyList extends StatefulWidget {
  Anime anime;
  UserAddAnimeToMyList({@required this.anime});

  @override
  _UserAddAnimeToMyListState createState() => _UserAddAnimeToMyListState();
}

// MEDIAQUERY'E GÖRE BOYUTLARI DÜZENLE
class _UserAddAnimeToMyListState extends State<UserAddAnimeToMyList> {
  bool isclicked = false;
  MyAnimeListApiCall _myAnimeListApiCall;
  String seciliButon;
  Anime anime;
  int animeProgress;
  int animeScore;
  NumberPicker progressPicker;
  NumberPicker scorePicker;
  bool tiklandiMi = false;
  String scoreString = "";
  Utils _utils;
  String startDate = "Start Date";
  String finishDate = "Finish Date";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _utils = locator<Utils>();
    _myAnimeListApiCall = locator<MyAnimeListApiCall>();
    seciliButon = "plan_to_watch";
    animeProgress = 0;
    animeScore = 0;
    anime = widget.anime;
    if (anime.myListStatus == null) {
      seciliButon = "plan_to_watch";
      animeProgress = 0;
    } else {
      anime.animeUserStatus =
          Map<String, dynamic>.from(anime.myListStatus)["status"];
      seciliButon = "${anime.animeUserStatus}";
      animeProgress =
          Map<String, dynamic>.from(anime.myListStatus)["num_episodes_watched"];
      animeScore = Map<String, dynamic>.from(anime.myListStatus)["score"];
      // startDate = Map<String, dynamic>.from(anime.myListStatus)["start_date"] ??
      //     "Start Date";
      // finishDate =
      //     Map<String, dynamic>.from(anime.myListStatus)["finish_date"] ??
      //         "Finish Date";
    }
    scoreString = getScoreText(animeScore);
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    //plan_to_watch, watching, completed, droppped, on_hold
    // Anime anime = widget.anime;
    //setstate her state yenilediğinde değerler sıfırlanıyor o yüzden bunları initstatede 1 kez başlatabilmenin bir yolunu bulabilirsek iyi olur
    scorePicker = NumberPicker.horizontal(
        listViewHeight: screenHeight * 0.076,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue[900], width: 1.4),
        ),
        textStyle: TextStyle(fontSize: screenWidth * 0.046),
        highlightSelectedValue: false,
        initialValue: animeScore,
        // numberToDisplay: 5,
        minValue: 0,
        maxValue: 10,
        onChanged: (value) {
          //burayı el ile tetiklemenin bir yolunu bul
          setState(() {
            animeScore = value;
            scoreString = getScoreText(value);
          });
        });
    progressPicker = NumberPicker.horizontal(
        listViewHeight: screenHeight * 0.076,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue[900], width: 1.4),
        ),
        textStyle: TextStyle(fontSize: screenWidth * 0.046),
        highlightSelectedValue: false,
        initialValue: animeProgress,
        // numberToDisplay: 5,
        minValue: 0,
        maxValue: anime.status == "Not Yet Aired" ? 3 : anime.numEpisodes,
        onChanged: (value) {
          setState(() {
            animeProgress = value;
          });
        });

    return Stack(
      children: [
        Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(screenHeight * 0.07),
            child: AppBar(
              actions: [
                FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    setState(() {
                      isclicked = true;
                    });
                    _myAnimeListApiCall
                        .updateAnime(
                            seciliButon, animeScore, animeProgress, anime.id)
                        .then((value) {
                      Map<String, dynamic> guncellenenAnime = value;
                      anime.myListStatus = guncellenenAnime;
                      Navigator.pop(context, true);
                    });
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(
                        color: Colors.blue[900],
                        fontSize: screenWidth * 0.041,
                        fontWeight: FontWeight.w500),
                  ),
                )
              ],
              backgroundColor: Colors.white,
              leading: IconButton(
                color: Colors.black54,
                icon: Icon(
                  Icons.close,
                  size: screenWidth * 0.057,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              elevation: 1,
              title: Text(""),
            ),
          ),
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.025,
                        horizontal: screenWidth * 0.057),
                    child: Text(
                      anime.title,
                      style: TextStyle(fontSize: screenWidth * 0.036),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.057),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Status",
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: screenWidth * 0.0364),
                        ),
                        Text(
                          anime.status,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: screenWidth * 0.0364),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: screenHeight * 0.02533,
                        left: screenWidth * 0.05729),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            if (anime.status == "Not Yet Aired") {
                            } else {
                              setState(() {
                                seciliButon = "watching";
                              });
                            }
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height / 14.8,
                            width: MediaQuery.of(context).size.width / 4.04,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: seciliButon == "watching"
                                    ? Colors.green
                                    : Colors.white,
                                border: Border.all(
                                    width: 0.6, color: Colors.black38)),
                            child: Align(
                              child: Text(
                                "Watching",
                                style: TextStyle(
                                    color: seciliButon == "watching"
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: screenWidth * 0.0364),
                              ),
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (anime.status == "Not Yet Aired") {
                            } else {
                              setState(() {
                                if (seciliButon != "completed") {
                                  tiklandiMi = true;
                                  animeProgress = anime.numEpisodes;
                                }
                                seciliButon = "completed";

                                if (tiklandiMi) {
                                  new Future.delayed(
                                      new Duration(milliseconds: 100), () {
                                    try {
                                      if (seciliButon == "completed") {
                                        animeProgress = anime.numEpisodes;
                                        progressPicker
                                            .animateInt(animeProgress);
                                      }
                                    } catch (e) {
                                      print(
                                          "Silently catching exception from picker ${e.toString()}"); // Controller not attached to any
                                    }
                                  });
                                }

                                tiklandiMi = false;
                              });
                            }
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height / 14.8,
                            width: MediaQuery.of(context).size.width / 4.04,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: seciliButon == "completed"
                                    ? Colors.blue[900]
                                    : Colors.white,
                                border: Border.all(
                                    width: 0.6, color: Colors.black38)),
                            child: Align(
                              child: Text(
                                "Completed",
                                style: TextStyle(
                                    color: seciliButon == "completed"
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: screenWidth * 0.0364),
                              ),
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              seciliButon = "plan_to_watch";
                            });
                          },
                          child: Container(
                            margin:
                                EdgeInsets.only(right: screenWidth * 0.05729),
                            height: MediaQuery.of(context).size.height / 14.8,
                            width: MediaQuery.of(context).size.width / 4.04,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: seciliButon == "plan_to_watch"
                                    ? Colors.grey
                                    : Colors.white,
                                border: Border.all(
                                    width: 0.6, color: Colors.black38)),
                            child: Align(
                              child: Text(
                                "Plan to Watch",
                                style: TextStyle(
                                    color: seciliButon == "plan_to_watch"
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: screenWidth * 0.0364),
                              ),
                              alignment: Alignment.center,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: screenHeight * 0.02027,
                        left: screenWidth * 0.05729),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              seciliButon = "on_hold";
                            });
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height / 14.8,
                            width: MediaQuery.of(context).size.width / 4.04,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: seciliButon == "on_hold"
                                    ? Colors.orange[400]
                                    : Colors.white,
                                border: Border.all(
                                    width: 0.6, color: Colors.black38)),
                            child: Align(
                              child: Text(
                                "On Hold",
                                style: TextStyle(
                                    color: seciliButon == "on_hold"
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: screenWidth * 0.0364),
                              ),
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              seciliButon = "dropped";
                            });
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height / 14.8,
                            width: MediaQuery.of(context).size.width / 4.04,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: seciliButon == "dropped"
                                    ? Colors.red[700]
                                    : Colors.white,
                                border: Border.all(
                                    width: 0.6, color: Colors.black38)),
                            child: Align(
                              child: Text(
                                "Dropped",
                                style: TextStyle(
                                    color: seciliButon == "dropped"
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: screenWidth * 0.0364),
                              ),
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 14.8,
                          width: MediaQuery.of(context).size.width / 4.04,
                          margin: EdgeInsets.only(right: screenWidth * 0.057),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: screenHeight * 0.0253,
                        left: screenWidth * 0.05729,
                        right: screenWidth * 0.05729),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Progress",
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: screenWidth * 0.0364),
                        ),
                        Text(
                          anime.numEpisodes == 0
                              ? "? EP"
                              : (anime.numEpisodes.toString() + " EP"),
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: screenWidth * 0.0364),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: screenHeight * 0.033,
                    ),
                    child: Container(
                      child: Center(
                        child: anime.status == "Not Yet Aired"
                            ? Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width /
                                        2.56,
                                    height: MediaQuery.of(context).size.height /
                                        13.55,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width /
                                        2.47,
                                    height: MediaQuery.of(context).size.height /
                                        13.55,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: Colors.blue[900]
                                                    .withOpacity(0.7),
                                                width: 1.4),
                                          ),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                8.53,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                13.15,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Opacity(
                                                opacity: 0.7,
                                                child: Text(
                                                  "0",
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenWidth * 0.046),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Opacity(
                                          opacity: 0.7,
                                          child: Text(
                                            "1",
                                            style: TextStyle(
                                                fontSize: screenWidth * 0.046),
                                          ),
                                        ),
                                        Opacity(
                                          opacity: 0.7,
                                          child: Text(
                                            "  2",
                                            style: TextStyle(
                                                fontSize: screenWidth * 0.046),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            : progressPicker,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: screenHeight * 0.0253,
                        left: screenWidth * 0.05729,
                        right: screenWidth * 0.05729),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Score",
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: screenWidth * 0.036),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.01302,
                          vertical: screenHeight * 0.0084),
                      height: MediaQuery.of(context).size.height / 23.68,
                      color: Colors.blue[900],
                      child: Text(
                        scoreString,
                        style: TextStyle(
                            color: Colors.white, fontSize: screenWidth * 0.036),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: screenHeight * 0.01689,
                    ),
                    child: Container(
                      child: Center(
                        child: scorePicker,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: screenHeight * 0.0422,
                        left: screenWidth * 0.05729,
                        right: screenWidth * 0.05729),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Date",
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: screenWidth * 0.036),
                        ),
                        Text(
                          _utils.dateYaz(anime.startDate) +
                              (anime.endDate == "???"
                                  ? " - "
                                  : " - " + _utils.dateYaz(anime.endDate)),
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: screenWidth * 0.036),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 19.73,
                  ),
                  Divider(
                    height: screenHeight * 0.035,
                    color: Colors.black38,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.031),
                    child: FlatButton.icon(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      label: Text(
                        "Remove from list",
                        style: TextStyle(
                            color: Colors.red, fontSize: screenWidth * 0.036),
                      ),
                      onPressed: () {
                        showAlertDialog(context, anime);

                        // anime.myListStatus = null;
                        // _myAnimeListApiCall.removeAnime(anime.id);
                        // Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.delete,
                        size: screenWidth * 0.046,
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        isclicked == false
            ? Container()
            : Container(
                color: Colors.transparent,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              )
      ],
    );
  }

  showAlertDialog(BuildContext context, Anime anime) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(
        "Cancel",
        style: TextStyle(
            color: Colors.blue[900],
            fontSize: MediaQuery.of(context).size.width * 0.036),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "YES",
        style: TextStyle(
            color: Colors.blue[900],
            fontSize: MediaQuery.of(context).size.width * 0.036),
      ),
      onPressed: () {
        anime.myListStatus = null;
        Navigator.pop(context);
        setState(() {
          isclicked = true;
        });
        _myAnimeListApiCall.removeAnime(anime.id).then((value) {
          anime.myListStatus = null;
          Navigator.pop(context, true);

          // });
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        "Are you sure you want to delete this anime?",
        style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.036),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String getScoreText(int animeScore) {
    if (animeScore == 0) {
      return "Not Yet Scored";
    } else if (animeScore == 1) {
      return "Appalling";
    } else if (animeScore == 2) {
      return "Horrible";
    } else if (animeScore == 3) {
      return "Very Bad";
    } else if (animeScore == 4) {
      return "Bad";
    } else if (animeScore == 5) {
      return "Average ";
    } else if (animeScore == 6) {
      return "Fine";
    } else if (animeScore == 7) {
      return "Good";
    } else if (animeScore == 8) {
      return "Very Good";
    } else if (animeScore == 9) {
      return "Great";
    } else if (animeScore == 10) {
      return "Masterpiece";
    } else {
      return "???";
    }
  }
}
