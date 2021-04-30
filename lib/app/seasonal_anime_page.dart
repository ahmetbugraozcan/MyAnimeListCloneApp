import 'package:flutter/material.dart';
import 'package:flutter_anichat/app/anime_detail_page.dart';
import 'package:flutter_anichat/locator.dart';
import 'package:flutter_anichat/model/anime.dart';
import 'package:flutter_anichat/services/myanimelist_api_call_methods.dart';

//Bu classı bağlayıcı ortak class olarak düşünmüştüm seasonal animeler için ancak işe yaramadı silmiyorum belki düzeltirim
class SeasonalAnimePage extends StatefulWidget {
  String season;
  SeasonalAnimePage({@required String season}) {
    this.season = season;
  }

  @override
  _SeasonalAnimePageState createState() => _SeasonalAnimePageState();
}

class _SeasonalAnimePageState extends State<SeasonalAnimePage> {
  static String dropDownMenuValue = "TV(new)";
  static List<Anime> seasonalAnimeList;
  MyAnimeListApiCall _myAnimeListApiCall = locator<MyAnimeListApiCall>();
  String lastSeason = "";
  bool yukleniyorMu = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // lastSeason = _myAnimeListApiCall.lastSeason;
    lastSeason = widget.season;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 1.1,
              height: MediaQuery.of(context).size.width / 11.84,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  createDropDownMenu(),
                  Container(
                    padding: EdgeInsets.only(right: 60),
                    child: Text(
                      "$lastSeason 2020",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
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
    );
  }

  Flexible buildFlexible() {
    return Flexible(
      child: (seasonalAnimeList == null || yukleniyorMu)
          ? FutureBuilder(
              future: widget.season == "Fall"
                  ? _myAnimeListApiCall
                      .lastSeasonAnimeleriGetir(dropDownMenuValue)
                  : widget.season == "Winter"
                      ? _myAnimeListApiCall
                          .thisSeasonAnimeleriGetir(dropDownMenuValue)
                      : _myAnimeListApiCall
                          .nextSeasonAnimeleriGetir(dropDownMenuValue),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                seasonalAnimeList = snapshot.data;
                return (seasonalAnimeList == null || yukleniyorMu)
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
      itemCount: seasonalAnimeList.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AnimeDetailPage()));
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
                            seasonalAnimeList[index].medium,
                            fit: BoxFit.fill,
                            width: MediaQuery.of(context).size.width / 2.2,
                            height: MediaQuery.of(context).size.height / 3,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 4),
                            width: MediaQuery.of(context).size.width / 4.2,
                            height: MediaQuery.of(context).size.height / 14,
                            color: Color.fromRGBO(256, 256, 256, 0.7),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 4, top: 2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        seasonalAnimeList[index]
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
                                  padding:
                                      const EdgeInsets.only(left: 4, top: 2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        seasonalAnimeList[index]
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
                        ],
                      ),
                      Text(
                        doControlStringLength(
                            seasonalAnimeList[index].title, 45),
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400),
                        maxLines: 2,
                      ),
                      genreKontrol(seasonalAnimeList[index])
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
            widget.season == "Fall"
                ? _myAnimeListApiCall
                    .lastSeasonAnimeleriGetir(dropDownMenuValue)
                : widget.season == "Winter"
                    ? _myAnimeListApiCall
                        .thisSeasonAnimeleriGetir(dropDownMenuValue)
                    : _myAnimeListApiCall
                        .nextSeasonAnimeleriGetir(dropDownMenuValue)
                        .then((value) {
                        setState(() {
                          seasonalAnimeList = value;
                          yukleniyorMu = false;
                        });
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

  doControlStringLength(String string, int sinir) {
    String newString = "";
    if (string.length > sinir) {
      for (int i = 0; i < sinir; i++) {
        newString += string[i];
      }
      newString += "...";
    } else {
      return string;
    }
    return newString;
  }

  //O anki animenin kategorilerini döndüren fonksiyon. liste doluyor yukarıdaki kısımdaki yerde bir şekilde bu kategorileri yerleştir
  genreKontrol(Anime anime) {
    String genres = "";
    for (int i = 0; i < anime.genres.length; i++) {
      var animeGenre = Map<String, dynamic>.from(anime.genres[i]);
      if (i == 0) {
        genres += animeGenre["name"] + ", ";
      } else if (i == anime.genres.length - 1) {
        genres += animeGenre["name"];
      } else {
        genres += animeGenre["name"] + ", ";
      }
    }
    var dondurulecekGenres = doControlStringLength(genres, 27);
    return Text(
      dondurulecekGenres,
      style: TextStyle(
        fontSize: 12,
        color: Colors.black54,
      ),
    );
  }

//YARIM FONKSİYON. BU FONKSİYON SAYILARIN BASAMAKLARI ARASINA VİRGÜLLERİNİ YERLEŞTİRİR. virgülsayacı kaç tane virgül atılacağını belirler.
//Önce sayıyı tersten yazdır. her 3 elemanda 1 kere virgül koy. eğer virgül sayacını geçtiyse diğer elemanları da yazdır bitir.
// doControlIntLength(int integer) {
//   String string = integer.toString();
//   String tersInteger = '';
//   int stringLength = string.length;
//   int virgulSayaci = -1;
//   int i = 0;
//   while (stringLength > 0) {
//     stringLength = stringLength - 3;
//     virgulSayaci++;
//   }
//   while (integer > 0) {
//     for (int j = 0; j < 3; j++) {
//       if (i > virgulSayaci) {
//         break;
//       }
//       tersInteger += (integer % 10).toString();
//       integer = ((integer - (integer % 10)) / 10).toInt();
//     }
//     tersInteger += ",";
//   }
//
//   return tersInteger;
// }
}
