import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_anichat/app/user_add_anime_to_mylist.dart';
import 'package:flutter_anichat/locator.dart';
import 'package:flutter_anichat/model/anime.dart';
import 'package:flutter_anichat/services/myanimelist_api_call_methods.dart';
import 'package:flutter_anichat/utils/utils.dart';

//widthleri heightleri mediaquery ile düzenle

class AnimeDetailPage extends StatefulWidget {
  int id;
  AnimeDetailPage({@required int id}) {
    this.id = id;
  }

  @override
  _AnimeDetailPageState createState() => _AnimeDetailPageState();
}

//Utilse taşıdığımız methodlarla buradakileri değiştir
class _AnimeDetailPageState extends State<AnimeDetailPage>
    with TickerProviderStateMixin {
  Color floatingButtonColor;
  Color floatingButtonIconColor;
  Anime anime;
  String lessSynopsis;
  String synopsisFull;
  MyAnimeListApiCall _myAnimeListApiCall = locator<MyAnimeListApiCall>();
  Utils _utils = locator<Utils>();
  IconData icon;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    icon = Icons.keyboard_arrow_down;
    floatingButtonColor = Colors.white;
    floatingButtonIconColor = Colors.blue[900];
    //setstate yap rengi değişsin
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: anime == null
          ? null
          : FloatingActionButton(
              elevation: 5,
              backgroundColor: floatingButtonColor,
              child: Icon(
                Icons.playlist_add,
                color: floatingButtonIconColor,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => UserAddAnimeToMyList(
                              anime: anime,
                            )));
              },
            ),
      appBar: AppBar(
        elevation: 0,
        title: Image.asset(
          "assets/myanimelist_symbol.png",
          scale: 5,
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF2e51a2),
      ),
      body: FutureBuilder(
        future: _myAnimeListApiCall.animeDetaylariniGetir(id: widget.id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          anime = snapshot.data;
          if (snapshot.hasData && anime.myListStatus != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
                  anime.animeUserStatus =
                      Map<String, dynamic>.from(anime.myListStatus)["status"];
                  floatingButtonColor = anime.animeUserStatus == null
                      ? Colors.white
                      : anime.animeUserStatus == "completed"
                          ? Colors.blue[900]
                          : anime.animeUserStatus == "watching"
                              ? Colors.green
                              : anime.animeUserStatus == "dropped"
                                  ? Colors.red
                                  : anime.animeUserStatus == "on_hold"
                                      ? Colors.yellow
                                      : Colors.grey;
                  floatingButtonIconColor = anime.animeUserStatus == null
                      ? Colors.blue[900]
                      : Colors.white;
                }));
          } else if (snapshot.hasData) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => setState(() {}));
          }
          return anime == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [
                        Container(),
                        Container(
                          height: MediaQuery.of(context).size.height / 8,
                          color: Color(0xFF2e51a2),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.black54, width: 0.8),
                                  ),
                                  margin: EdgeInsets.all(20),
                                  width:
                                      MediaQuery.of(context).size.width / 1.66,
                                  height:
                                      MediaQuery.of(context).size.height / 2.27,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: CarouselSlider.builder(
                                      itemCount: anime.pictures.length,
                                      itemBuilder: (context, index) {
                                        return Image.network(
                                            Map<String, dynamic>.from(anime
                                                .pictures[index])["medium"],
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent
                                                        loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.66,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2.27,
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        });
                                      },
                                      options: CarouselOptions(
                                          enableInfiniteScroll: false,
                                          enlargeCenterPage: false,
                                          viewportFraction: 1,
                                          aspectRatio: 0.8),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 65, left: 35),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          "Score",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                        ),
                                      ),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(top: 1.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                anime.mean == 0.0
                                                    ? "N/A"
                                                    : "${anime.mean}",
                                                style: TextStyle(
                                                    fontSize: 24,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          )),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: Text(
                                          "Rank",
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          anime.rank == null
                                              ? "N/A"
                                              : "#${anime.rank}",
                                          style: TextStyle(
                                            color: Colors.blue[900],
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Text("Popularity",
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 10)),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          "#${anime.popularity}",
                                          style: TextStyle(
                                              color: Colors.blue[900],
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Text("Members",
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 10)),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          "${anime.numListUsers}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                "${anime.title}",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 30.0, top: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "${anime.mediaType.toUpperCase()}, ${anime.startDate.split("-")[0]}",
                                  ),
                                  Text(
                                    "|",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  Text("${anime.status}",
                                      style: TextStyle(
                                          color: anime.status == "Airing"
                                              ? Colors.green
                                              : Colors.black)),
                                  Text(
                                    "|",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  anime.numEpisodes != 0 &&
                                          anime.averageEpisodeDuration != 0
                                      ? Text(
                                          "${anime.numEpisodes} ep, ${(anime.averageEpisodeDuration / 60).toInt()} min.",
                                        )
                                      : anime.averageEpisodeDuration == 0 &&
                                              anime.numEpisodes != 0
                                          ? Text(
                                              "${anime.numEpisodes} ep, ? min.",
                                            )
                                          : Text(
                                              "? ep, ? min",
                                            ),
                                ],
                              ),
                            ),
                            anime.genres.length == 0 || anime.genres == null
                                ? Container()
                                : Container(
                                    padding: EdgeInsets.all(0),
                                    margin: EdgeInsets.only(top: 10),
                                    color: Colors.grey[400],
                                    child: GridView.builder(
                                        shrinkWrap: true,
                                        itemCount: anime.genres.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                          childAspectRatio: 2.6,
                                          mainAxisSpacing: 0,
                                          crossAxisSpacing: 0,
                                        ),
                                        itemBuilder: (context, index) {
                                          return Chip(
                                            padding: EdgeInsets.all(0),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(6))),
                                            label: Text(
                                              "${Map<String, dynamic>.from(anime.genres[index])["name"]}",
                                              style: TextStyle(
                                                  color: Colors.blue[900],
                                                  fontSize: 13),
                                            ),
                                          );
                                        }),
                                  ),
                            anime.synopsis.length > 1
                                ? Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: AnimatedSize(
                                          vsync: this,
                                          duration:
                                              const Duration(milliseconds: 200),
                                          child: anime.synopsis == null
                                              ? ""
                                              : Text(
                                                  icon ==
                                                          Icons
                                                              .keyboard_arrow_down
                                                      ? _utils
                                                          .doControlStringLength(
                                                              anime.synopsis,
                                                              211)
                                                      : "${anime.synopsis}",
                                                ),
                                        ),
                                      ),
                                      anime.synopsis.length > 100
                                          ? InkWell(
                                              onTap: () {
                                                setState(() {
                                                  if (icon ==
                                                      Icons
                                                          .keyboard_arrow_down) {
                                                    icon =
                                                        Icons.keyboard_arrow_up;
                                                  } else {
                                                    icon = Icons
                                                        .keyboard_arrow_down;
                                                  }
                                                });
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    29.6,
                                                child: FlatButton(
                                                  child: Icon(
                                                    icon,
                                                    color: Colors.grey,
                                                    size: 30,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (icon ==
                                                          Icons
                                                              .keyboard_arrow_down) {
                                                        icon = Icons
                                                            .keyboard_arrow_up;
                                                      } else {
                                                        icon = Icons
                                                            .keyboard_arrow_down;
                                                      }
                                                    });
                                                  },
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                    ],
                                  )
                                : Column(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  // child: Text("Video"),
                                  // width: 400,
                                  // height: 200,
                                  // color: Colors.red,
                                  ),
                            ),
                            Map<String, dynamic>.from(
                                            anime.alternativeTitles)["en"]
                                        .toString()
                                        .length >
                                    1
                                ? Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "English",
                                            style: TextStyle(fontSize: 11),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "${Map<String, dynamic>.from(anime.alternativeTitles)["en"]}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 200,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Source",
                                              style: TextStyle(fontSize: 11),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 12.0),
                                              child: Text(
                                                _utils.basHarfiBuyukYaz(
                                                    anime.source),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Studio",
                                              style: TextStyle(fontSize: 11),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 12.0),
                                              child: Text(
                                                anime.studios.length == 0
                                                    ? "Unknown"
                                                    : "${Map<String, dynamic>.from(anime.studios[0])["name"]}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13),
                                                maxLines: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Rating",
                                              style: TextStyle(fontSize: 11),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              ratingYazdir(anime.rating),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width /
                                        2.25,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Season",
                                              style: TextStyle(fontSize: 11),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 12.0),
                                              child: Text(
                                                anime.startSeason == null
                                                    ? "?"
                                                    : "${_utils.basHarfiBuyukYaz(Map<String, dynamic>.from(anime.startSeason)["season"])} ${Map<String, dynamic>.from(anime.startSeason)["year"]}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Aired",
                                              style: TextStyle(fontSize: 11),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 12.0),
                                              child: Text(
                                                "${_utils.dateYaz(anime.startDate)}to ${_utils.dateYaz(anime.endDate)}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13),
                                                maxLines: 3,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Licensor",
                                              style: TextStyle(fontSize: 11),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Unknown",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(),
                                ],
                              ),
                            ),
                            anime.relatedAnime.length > 0
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0, left: 22.0, bottom: 10),
                                    child: Row(
                                      children: [
                                        Text(
                                          "${Map<String, dynamic>.from(anime.relatedAnime[0])["relation_type_formatted"]}",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            _utils.doControlStringLength(
                                                Map<String, dynamic>.from(
                                                        anime.relatedAnime[0])[
                                                    "node"]["title"],
                                                36),
                                            style: TextStyle(
                                                color: Colors.blue[900]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(),
                                  ),
                            anime.recommendations.length >= 1
                                ? Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height /
                                        4.55,
                                    child: ListView.builder(
                                      addAutomaticKeepAlives: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: anime.recommendations.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (context) => AnimeDetailPage(
                                                        id: Map<String,
                                                            dynamic>.from(anime
                                                                .recommendations[
                                                            index])["node"]["id"])));
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 3),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4.26,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                4.55,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Stack(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .bottomStart,
                                                  children: [
                                                    Image.network(
                                                      "${Map<String, dynamic>.from(anime.recommendations[index])["node"]["main_picture"]["medium"]}",
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              4.26,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              4.93,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 3.0,
                                                              bottom: 3.0),
                                                      child: Text(
                                                        "${Map<String, dynamic>.from(anime.recommendations[index])["node"]["title"]}",
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          shadows: <Shadow>[
                                                            Shadow(
                                                              offset: Offset(
                                                                  1.0, 12.0),
                                                              blurRadius: 12.0,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            Shadow(
                                                              offset: Offset(
                                                                  1.0, 1.0),
                                                              blurRadius: 12.0,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: 10,
                            ),
                            watchingMembers(anime.statistics, "Watching"),
                            watchingMembers(1, "Completed"),
                            watchingMembers(30, "On Hold"),
                            watchingMembers(0.5, "Dropped"),
                            watchingMembers(150, "Plan to Watch"),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 12.0, right: 10),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "All members : ${anime.numListUsers}",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 12),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 5.92,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  // bunu bir sınıfa aktarsak daha iyi olabilir sanırım
  Padding watchingMembers(Object object, String string) {
    String yazilacakString = string;
    //
    if (string.contains(" ")) {
      string = string.replaceAll(" ", "_");
      string = string.toLowerCase();
    }

    var sayiString = Map<dynamic, dynamic>.from(anime.statistics)["status"]
        ["${string.toLowerCase()}"];
    sayiString = sayiString.toString();
    double sayi = double.parse(sayiString);
    double width = sayi / 1000;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 8, right: 8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              alignment: Alignment.centerRight,
              width: MediaQuery.of(context).size.width / 4.8,
              child: Text(
                "$yazilacakString",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                maxLines: 1,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              constraints: BoxConstraints(
                  minWidth: 1,
                  maxWidth: MediaQuery.of(context).size.width / 1.536),
              //BoxConstraints(minWidth: 100, maxWidth: 200), constrainsts e eklersen minimum ve maksimum büyüklüğünü belirleyebilirsin
              height: MediaQuery.of(context).size.height / 29.6,
              width: width,
              color: Colors.blue[900],
              child: Align(
                alignment: Alignment.centerRight,
                // width büyüklüğüne göre text içeride ya da dışarıda olacak
                child: width >= MediaQuery.of(context).size.width / 2.56
                    ? Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Text(
                          "$sayiString",
                          style: TextStyle(color: Colors.white, fontSize: 11),
                          maxLines: 1,
                        ),
                      )
                    : null,
              ),
            ),
          ),
          width < MediaQuery.of(context).size.width / 2.56
              ? Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    "$sayiString",
                    style: TextStyle(color: Colors.black54, fontSize: 11),
                    maxLines: 1,
                  ),
                )
              : SizedBox(
                  height: 0,
                  width: 0,
                )
        ],
      ),
    );
  }

  Transform createChip(String type) {
    return Transform(
      transform: Matrix4.identity()..scale(0.8),
      child: Chip(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6))),
        label: Text(
          "$type",
          style: TextStyle(color: Colors.blue[300], fontSize: 15),
        ),
        backgroundColor: Colors.black87,
      ),
    );
  }

  String ratingYazdir(String rating) {
    if (rating.contains("_")) {
      rating = rating.replaceAll("_", "-");
      rating = rating.toUpperCase();
      return rating;
    }
    rating = rating.toUpperCase();
    return rating;
  }
}
