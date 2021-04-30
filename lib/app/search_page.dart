import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_anichat/app/anime_detail_page.dart';
import 'package:flutter_anichat/app/user_add_anime_to_mylist.dart';
import 'package:flutter_anichat/locator.dart';
import 'package:flutter_anichat/model/anime.dart';
import 'package:flutter_anichat/my_widgets/add_anime_to_my_list.dart';
import 'package:flutter_anichat/services/myanimelist_api_call_methods.dart';
import 'package:flutter_anichat/utils/utils.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //butonlara isactive diye bir değişken oluştur save e basıldığında false olsunlar
  Utils utils = locator<Utils>();
  static List<Anime> animeList;
  MyAnimeListApiCall _myAnimeListApiCall = locator<MyAnimeListApiCall>();
  final myController = TextEditingController();
  bool isLoading;
  bool isLoaded;
  String kelime;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  //Klavye açıkken profile gidince hata var düzelt
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(8),
              ),
              margin: EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
              width: MediaQuery.of(context).size.width / 1.16,
              height: MediaQuery.of(context).size.height / 59.2,
              child: TextField(
                controller: myController,
                onSubmitted: (var string) {
                  if (string.length < 3) {
                    print("En az 3 karakter girmelisin");
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      backgroundColor: Colors.white,
                      duration: Duration(seconds: 1),
                      content: Container(
                        child: Text(
                          "Enter 3 or more characters.",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ));
                  } else {
                    setState(() {
                      kelime = string;
                      isLoading = true;
                    });
                    // print("Submit edildi : " + kelime);
                    _myAnimeListApiCall.arananAnimeList = [];
                    if (_myAnimeListApiCall.arananAnimeList.length == 0) {
                      _myAnimeListApiCall
                          .arananAnimeleriGetir(kelime)
                          .then((tumAnimeler) {
                        setState(() {
                          animeList = tumAnimeler;
                          //Burada body'i ayarlamamız gerekiyor. Girilen stringe göre bir parametre daha true false yapıp body oluşturabiliriz
                          isLoading = false;
                          isLoaded = true;
                        });
                      });
                    } else {
                      setState(() {
                        animeList = _myAnimeListApiCall.arananAnimeList;

                        isLoaded = true;
                        isLoading = false;
                      });
                    }
                  }
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          myController.clear();
                          _myAnimeListApiCall.arananAnimeList = [];
                          kelime = "";
                          isLoaded = false;
                          isLoading = false;
                        });
                        //kelime de boş atanacak
                      },
                      child: Icon(Icons.close)),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 23,
                  ),
                ),
              )),
        ],
        centerTitle: true,
        backgroundColor: Color(0xFF2e51a2),
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : isLoaded == true
              ? buildSearchedPage()
              : (_myAnimeListApiCall.top10FavoritedAnime.length == 0 ||
                      _myAnimeListApiCall.top10AiringAnime.length == 0 ||
                      _myAnimeListApiCall.top10Anime.length == 0 ||
                      _myAnimeListApiCall.top10FavoritedAnime.length == 0)
                  ? FutureBuilder(
                      future: _myAnimeListApiCall.searchPageIcerikleriniGetir(),
                      builder: (BuildContext context, AsyncSnapshot snapShot) {
                        if (snapShot.data != null && snapShot.data) {
                          return buildSearchPageBody();
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    )
                  : buildSearchPageBody(),
    );
  }

  Widget buildSearchedPage() {
    return Container(
      child: RefreshIndicator(
        onRefresh: () {
          setState(() {
            _myAnimeListApiCall.arananAnimeleriGetir(kelime).then((value) {
              setState(() {
                var list = _myAnimeListApiCall.arananAnimeList;
                _myAnimeListApiCall.arananAnimeList = [];
                _myAnimeListApiCall.arananAnimeList = list;
              });
            });
          });
          return Future.delayed(Duration(seconds: 4));
        },
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _myAnimeListApiCall.arananAnimeList.length,
          itemBuilder: (BuildContext context, int index) {
            Anime anime = _myAnimeListApiCall.arananAnimeList[index];
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => AnimeDetailPage(
                                  id: anime.id,
                                ))).then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    color: Colors.transparent,
                    height: MediaQuery.of(context).size.height / 5.92,
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 5.48,
                          height: MediaQuery.of(context).size.height / 5.92,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Image.network(
                                anime.mainPicture == null
                                    ? "https://www.allianceplast.com/wp-content/uploads/2017/11/no-image.png"
                                    : Map.from(anime.mainPicture)["medium"],
                                fit: BoxFit.contain,
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 6),
                                color: Colors.black.withOpacity(0.8),
                                width: MediaQuery.of(context).size.width / 8.53,
                                height:
                                    MediaQuery.of(context).size.height / 25.7,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      anime.mean == 0.0
                                          ? "N/A"
                                          : anime.mean.toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 13,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width /
                                        1.536,
                                    child: Text(
                                      anime.title,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 6),
                                    child: Text(
                                      utils.basHarfiBuyukYaz(
                                              anime.mediaType + ", ") +
                                          anime.numEpisodes.toString() +
                                          " EP, " +
                                          utils.dateAndSeason(anime.startDate),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  SizedBox(
                                    height: anime.title.length >=
                                            MediaQuery.of(context).size.height /
                                                19.73
                                        ? MediaQuery.of(context).size.height /
                                            59.2
                                        : MediaQuery.of(context).size.height /
                                            19.73,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        anime.numListUsers.toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54),
                                      ),
                                      Icon(
                                        Icons.person_outline,
                                        size: 15,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 40),
                                child: AddAnimeToMyList(
                                    ontap: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  UserAddAnimeToMyList(
                                                    anime: anime,
                                                  ))).then((value) {
                                        setState(() {
                                          // refresh state of Page1
                                        });
                                      });
                                    },
                                    margin: EdgeInsets.all(2),
                                    anime: anime,
                                    width: MediaQuery.of(context).size.width /
                                        12.8,
                                    height: MediaQuery.of(context).size.height /
                                        19.73,
                                    icon: anime.myListStatus == null
                                        ? Icon(
                                            Icons.playlist_add,
                                            color: Colors.black54,
                                          )
                                        : Icon(
                                            Icons.playlist_add_check,
                                            color: Colors.white,
                                          ),
                                    decoration: BoxDecoration(
                                      color: anime.myListStatus == null
                                          ? Colors.white
                                          : Map.from(anime.myListStatus)[
                                                      'status'] ==
                                                  "completed"
                                              ? Colors.blue[900]
                                              : Map.from(anime.myListStatus)[
                                                          'status'] ==
                                                      "watching"
                                                  ? Colors.green
                                                  : Map.from(anime.myListStatus)[
                                                              'status'] ==
                                                          "dropped"
                                                      ? Colors.red
                                                      : Map.from(anime.myListStatus)[
                                                                  'status'] ==
                                                              "plan_to_watch"
                                                          ? Colors.grey
                                                          : Colors.yellow,
                                      borderRadius: BorderRadius.circular(4),
                                    )),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                  color: Colors.black38,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  SingleChildScrollView buildSearchPageBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 12),
              child: Text(
                "Top 10 Anime",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3.94,
              child: ListView.builder(
                  addAutomaticKeepAlives: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _myAnimeListApiCall.top10Anime.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => AnimeDetailPage(
                                    id: _myAnimeListApiCall
                                        .top10Anime[index].id)));
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        width: MediaQuery.of(context).size.width / 3.84,
                        // child: Text(_myAnimeListApiCall.top10Anime[index].title),
                        child: Image.network(
                            _myAnimeListApiCall.top10Anime[index].medium,
                            fit: BoxFit.cover),
                      ),
                    );
                  }),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 5, left: 12),
              child: Text(
                "Top 10 Airing",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3.94,
              child: ListView.builder(
                  addAutomaticKeepAlives: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _myAnimeListApiCall.top10AiringAnime.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => AnimeDetailPage(
                                    id: _myAnimeListApiCall
                                        .top10AiringAnime[index].id)));
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        width: MediaQuery.of(context).size.width / 3.84,
                        child: Image.network(
                            _myAnimeListApiCall.top10AiringAnime[index].medium,
                            fit: BoxFit.cover),
                        // child: Text(
                        //     _myAnimeListApiCall.top10AiringAnime[index].title),
                      ),
                    );
                  }),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 5, left: 12),
              child: Text(
                "Top 10 Upcoming",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3.94,
              child: ListView.builder(
                  addAutomaticKeepAlives: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _myAnimeListApiCall.top10UpcomingAnime.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => AnimeDetailPage(
                                    id: _myAnimeListApiCall
                                        .top10UpcomingAnime[index].id)));
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        width: MediaQuery.of(context).size.width / 3.84,
                        child: Image.network(
                            _myAnimeListApiCall
                                .top10UpcomingAnime[index].medium,
                            fit: BoxFit.cover),
                        // child: Text(
                        //     _myAnimeListApiCall.top10UpcomingAnime[index].title),
                      ),
                    );
                  }),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 5, left: 12),
              child: Text(
                "Top 10 Favorited",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3.94,
              child: ListView.builder(
                  addAutomaticKeepAlives: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _myAnimeListApiCall.top10FavoritedAnime.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => AnimeDetailPage(
                                    id: _myAnimeListApiCall
                                        .top10FavoritedAnime[index].id)));
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        width: MediaQuery.of(context).size.width / 3.84,
                        child: Image.network(
                          _myAnimeListApiCall.top10FavoritedAnime[index].medium,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
