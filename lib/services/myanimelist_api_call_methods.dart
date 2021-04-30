import 'package:flutter/cupertino.dart';
import 'package:flutter_anichat/app/user_dropped_page.dart';
import 'package:flutter_anichat/locator.dart';
import 'package:flutter_anichat/model/anime.dart';
import 'package:flutter_anichat/model/user.dart';
import 'package:flutter_anichat/services/oauth_auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MyAnimeListApiCall {
  //son sezonu alıp isteklerimizi son sezon üzerinden gerçekleştiriyoruz.
  String lastSeason = "Fall";
  String thisSeason = "Winter";
  String nextSeason = "Spring";
  OAuthService _oAuthService = locator<OAuthService>();
  List<Anime> list = [];
  List<Anime> arananAnimeList = [];
  List<Anime> top10Anime = [];
  List<Anime> top10AiringAnime = [];
  List<Anime> top10UpcomingAnime = [];
  List<Anime> top10FavoritedAnime = [];

  //********************************************************************************************
//********************************************************************************************
//   Future<Anime> myListeEklemekIcinAnimeDetaylariniDondur(Anime anime) async {
//     var accessToken = await readToken();
//
//     http.Response response;
//     response = await http.get(
//         "https://api.myanimelist.net/v2/anime/${anime.id}?fields=id,title,start_date,end_date,status,my_list_status,num_episodes",
//         headers: <String, String>{'Authorization': 'Bearer $accessToken'});
//     if (response.statusCode == 200) {
//       print(response.body);
//       Map map = await jsonDecode(response.body);
//       Anime anime = Anime.fromJSONAnimeForAddMyListPage(map);
//       return anime;
//     } else {
//       debugPrint("Anime detay apiye bağlanma başarısız");
//       throw Exception("Anime detay HATA MYANIMELIST API CALL METHOD");
//     }
//   }
// ********************************************************************************************
// //********************************************************************************************

  Future<bool> searchPageIcerikleriniGetir() async {
    var accessToken = await readToken();
    //top anime series
    var resultAll = http.Client().get(
      'https://api.myanimelist.net/v2/anime/ranking?ranking_type=all&limit=10',
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
    var resultAiring = http.Client().get(
      'https://api.myanimelist.net/v2/anime/ranking?ranking_type=airing&limit=10',
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
    var resultUpcoming = http.Client().get(
      'https://api.myanimelist.net/v2/anime/ranking?ranking_type=upcoming&limit=10',
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    var resultFavorited = http.Client().get(
      'https://api.myanimelist.net/v2/anime/ranking?ranking_type=favorite&limit=10',
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
    var results = await Future.wait(
        [resultAll, resultAiring, resultUpcoming, resultFavorited]);
    var top10AnimeMap = await jsonDecode(results[0].body);
    for (int i = 0; i < top10AnimeMap["data"].length; i++) {
      Anime anime = Anime.fromJSON(top10AnimeMap, i);
      top10Anime.add(anime);
    }
    var top10AiringAnimeMap = await jsonDecode(results[1].body);
    for (int i = 0; i < top10AiringAnimeMap["data"].length; i++) {
      Anime anime = Anime.fromJSON(top10AiringAnimeMap, i);
      top10AiringAnime.add(anime);
    }
    var top10UpcomingAnimeMap = await jsonDecode(results[2].body);
    for (int i = 0; i < top10UpcomingAnimeMap["data"].length; i++) {
      Anime anime = Anime.fromJSON(top10UpcomingAnimeMap, i);
      top10UpcomingAnime.add(anime);
    }
    var top10FavoritedAnimeMap = await jsonDecode(results[3].body);
    for (int i = 0; i < top10FavoritedAnimeMap["data"].length; i++) {
      Anime anime = Anime.fromJSON(top10FavoritedAnimeMap, i);
      top10FavoritedAnime.add(anime);
    }
    return true;
  }

  //********************************************************************************************
//********************************************************************************************
  List<Anime> listeyiDondur(List<Anime> animelist) {
    list = animelist;
  }

  //********************************************************************************************
//********************************************************************************************
  List<Anime> completedListeyiDondur(List<Anime> animelist) {
    List<Anime> watchingList = [];
    for (int i = 0; i < animelist.length; i++) {
      if (animelist[i].animeUserStatus == "completed") {
        watchingList.add(animelist[i]);
      }
    }
    return watchingList;
  }

  //********************************************************************************************
//********************************************************************************************
  List<Anime> watchingListeyiDondur(List<Anime> animelist) {
    List<Anime> watchingList = [];
    for (int i = 0; i < animelist.length; i++) {
      if (animelist[i].animeUserStatus == "watching") {
        watchingList.add(animelist[i]);
      }
    }
    return watchingList;
  }

  //********************************************************************************************
//********************************************************************************************
  List<Anime> onHoldListeyiDondur(List<Anime> animelist) {
    List<Anime> onHoldList = [];
    for (int i = 0; i < animelist.length; i++) {
      if (animelist[i].animeUserStatus == "on_hold") {
        onHoldList.add(animelist[i]);
      }
    }
    return onHoldList;
  }

  //********************************************************************************************
//********************************************************************************************
  List<Anime> droppedListeyiDondur(List<Anime> animelist) {
    List<Anime> droppedList = [];
    for (int i = 0; i < animelist.length; i++) {
      if (animelist[i].animeUserStatus == "dropped") {
        droppedList.add(animelist[i]);
      }
    }
    return droppedList;
  }

  //********************************************************************************************
//********************************************************************************************
  List<Anime> planToWatchListeyiDondur(List<Anime> animelist) {
    List<Anime> planToWatchList = [];
    for (int i = 0; i < animelist.length; i++) {
      if (animelist[i].animeUserStatus == "plan_to_watch") {
        planToWatchList.add(animelist[i]);
      }
    }
    return planToWatchList;
  } //********************************************************************************************

//********************************************************************************************
  Future<bool> removeAnime(int animeID) async {
    //application/x-www-form-urlencoded

    //Burada sil animeyi listesinden

    var accessToken = await readToken();
    try {
      // list = [];
      var result = await http.Client().delete(
        'https://api.myanimelist.net/v2/anime/$animeID/my_list_status',
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        },
      );
      list = [];
      return true;
    } catch (e) {
      print("Delete anime hata : " + e.toString());
      return false;
    }
  }

  //********************************************************************************************
//********************************************************************************************
  Future<Map<String, dynamic>> updateAnime(
      String status, int score, int numWatchedEpisodes, int animeID) async {
    //application/x-www-form-urlencoded
    var accessToken = await readToken();
    try {
      var result = await http.Client().patch(
          'https://api.myanimelist.net/v2/anime/$animeID/my_list_status',
          headers: <String, String>{
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: {
            'status': status,
            'score': score.toString(),
            'num_watched_episodes': numWatchedEpisodes.toString(),
          });
      Map map = await jsonDecode(result.body);
      list = [];
      return map;
    } catch (e) {
      print("Update anime hata : " + e.toString());
    }
  }

  //********************************************************************************************
//*******************************************************************************************
  /*Future<List<Map<String, dynamic>>> getDoubleData() async {
  var value = <Map<String, dynamic>>[];
  var r1 = http.get('https://www.dart.dev');
  var r2 = http.get('https://www.flutter.dev');
  var results = await Future.wait([r1, r2]); // list of Responses
  for (var response in results) {
    print(response.statusCode);
    value.add(json.decode(response.body));
  }
  return value;
  ÇOK YAVAŞ ÇALIŞIYORSA BU TARZ BİR YAPI DENEYEBİLİRİZ.
}*/

  //Şimdilik bu metodu arama yapılıp entera basınca çalıştırmayı düşünüyorum. Burada bulunan liste tamamen dolduğu zaman bir daha bunun çalışmasına gerek kalmayacak
  Future<List<Anime>> arananAnimeleriGetir(String arananKelime) async {
    int sayac = 0;
    List<Anime> _arananAnimeList = [];
    int limit = 100;
    var accessToken = await readToken();
    var result = await http.Client().get(
      'https://api.myanimelist.net/v2/anime?q=$arananKelime&limit=$limit&fields=list_status,media_type,status,num_episodes,start_date,finish_date,mean,my_list_status,num_list_users',
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (result.statusCode == 200) {
      Map map = await jsonDecode(result.body);
      //ilk mapimiz, ilk 100 anime burada anime olacak, daha sonrakiler bir aşağıdaki while döngüsünde
      for (int i = 0; i < map["data"].length; i++) {
        Anime anime = Anime.fromJSONAnimeForSearchedAnimes(map, i);
        arananAnimeList.add(anime);
      }
      while (true) {
        if (arananAnimeList.length >= 200) {
          break;
        }
        if (map["paging"]["next"] == null) {
          break;
        } else {
          var link = map["paging"]["next"].toString();

          result = await http.Client().get(
            '$link',
            headers: <String, String>{
              'Authorization': 'Bearer $accessToken',
            },
          );
          if (result.statusCode == 200) {
            map = await jsonDecode(result.body);
            for (int i = 0; i < map["data"].length; i++) {
              Anime anime = Anime.fromJSONAnimeForSearchedAnimes(map, i);
              arananAnimeList.add(anime);
            }
          } else {
            print("Hata oluştu : " + result.statusCode.toString());
          }
        }
      }
    }
    _arananAnimeList = arananAnimeList;
    return _arananAnimeList;
  }

  //********************************************************************************************
//********************************************************************************************
  Future<List<Anime>> userListGetir(int limit) async {
    List<Anime> _userAnimeList = [];
    var accessToken = await readToken();
    var result = await http.Client().get(
      'https://api.myanimelist.net/v2/users/@me/animelist?fields=list_status,media_type,status,num_episodes,start_date,finish_date,my_list_status&limit=$limit',
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (result.statusCode == 200) {
      Map map = await jsonDecode(result.body);
      for (int i = 0; i < map["data"].length; i++) {
        Anime anime = Anime.fromJSONAnimeForMyList(map, i);
        _userAnimeList.add(anime);
      }
    }
    airingleriBasaAl(_userAnimeList);
    listeyiDondur(_userAnimeList);
    return _userAnimeList;
  }

//********************************************************************************************
//********************************************************************************************
  void airingleriBasaAl(List<Anime> _userAnimeList) {
    int temp = 0;
    for (int i = 0; i < _userAnimeList.length; i++) {
      if (_userAnimeList[i].status == "Airing" ||
          _userAnimeList[i].animeUserStatus == "watching") {
        var eklenecekEleman = _userAnimeList[i];

        _userAnimeList.removeAt(i);
        _userAnimeList.insert(temp, eklenecekEleman);
        temp++;
      }
    }
  }

//********************************************************************************************
//********************************************************************************************
  Future<List<Anime>> topAnimeleriGetir() async {
    List<Anime> _animeListesi = [];
    int limit = 20;

    http.Response response = await http.get(
        'https://api.myanimelist.net/v0/anime/ranking?ranking_type=all&limit=$limit');
    if (response.statusCode == 200) {
      Map map = await jsonDecode(response.body);
      for (int i = 0; i < limit; i++) {
        Anime anime = Anime.fromJSON(map, i);
        _animeListesi.add(anime);
      }
      return _animeListesi;
      // Anime anime = Anime.fromJSON(map,index);
      // return anime;
    } else {
      print("Apiye bağlanma başarısız");
      throw Exception("Apiye Bağlanamadık");
    }
  }

//********************************************************************************************
//********************************************************************************************
  Future<List<Anime>> thisSeasonAnimeleriGetir(String value) async {
    var accessToken = await readToken();
    //Geçtiğimiz dönemi aldığımız değişken.
    int year = 2021;
    List<Anime> _animelerListesi = [];
    int limit = 75;
    http.Response response;

    response = await http.get(
        'https://api.myanimelist.net/v2/anime/season/2021/${thisSeason.toLowerCase()}?sort=anime_num_list_users&limit=$limit&fields=num_episodes,id,title,genres,start_date,end_date,status,num_list_users,my_list_status,mean,media_type',
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        });

    if (response.statusCode == 200) {
      Map map = await jsonDecode(response.body);

      for (int i = 0; i < limit; i++) {
        Anime anime = Anime.fromJSONwithoutRankWithSeason(map, i);
        //her bir tab değiştiğinde apiye istek atmak yerine tv newleri bir listede tv contları bir listede tutup bu listeleri döndürebiliriz
        //bir kez istek atıp listeleri döndürdükten sonra bir daha istek atmadan dolu listeleri tekrar tekrar gösterebiliriz
        //bunu yapmak daha mantıklı geldi o yüzden aklında geldiği bir zaman bunlarla ilgilen.
        //bunun için şöyle yapabiliriz : if(tv mi ) (e)=> for(tüm animeler)=> tvleri bul tvler listesine at döndür.
        //aynı mantığı tüm tablar için yaparsak her taba bir kez bastığımızda listeler dolacaktır ve bir daha istek atmak zorunda kalmadan animeleri hızlıca getirebiliriz

        if (value == "TV(cont'd)") {
          if (int.parse(anime.startDate.split("-")[0]) < year &&
              anime.mediaType == "tv") {
            _animelerListesi.add(anime);
          } else {}
        } else if (value == "TV(new)") {
          if (int.parse(anime.startDate.split("-")[0]) == year &&
                  anime.mediaType == "tv" ||
              int.parse(anime.startDate.split("-")[0]) == year - 1 &&
                  anime.mediaType == "tv" &&
                  int.parse(anime.startDate.split("-")[1]) == 12) {
            _animelerListesi.add(anime);
          } else {}
        } else if (value == "OVA") {
          if (anime.mediaType == "ova") {
            _animelerListesi.add(anime);
          } else {}
        } else if (value == "ONA") {
          if (anime.mediaType == "ona") {
            _animelerListesi.add(anime);
          } else {}
        } else if (value == "Movie") {
          if (anime.mediaType == "movie") {
            _animelerListesi.add(anime);
          } else {}
        } else if (value == "Special") {
          if (anime.mediaType == "special") {
            _animelerListesi.add(anime);
          } else {}
        }
      }
      return _animelerListesi;
    } else {
      debugPrint("This season apiye bağlanma başarısız");
      throw Exception("This season HATA MYANIMELIST API CALL METHOD");
    }
  }

//********************************************************************************************
//********************************************************************************************
  Future readToken() async {
    //1 kere okuyup değişkene atayabiliriz değişken null değil ise direk hazır değişkenden devam edebiliriz
    final prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.get("accessToken");
    return accessToken;
  }

//********************************************************************************************
//********************************************************************************************
  Future<Anime> animeDetaylariniGetir({@required int id}) async {
    var accessToken = await readToken();
    //sorun yok gibi duruyor
    http.Response response;
    response = await http.get(
        "https://api.myanimelist.net/v2/anime/$id?fields=id,title,main_picture,alternative_titles,start_date,end_date,synopsis,mean,rank,popularity,num_list_users,num_scoring_users,nsfw,created_at,updated_at,media_type,status,genres,my_list_status,num_episodes,start_season,broadcast,source,average_episode_duration,rating,pictures,background,related_anime,related_manga,recommendations,studios,statistics",
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        });
    if (response.statusCode == 200) {
      Map map = await jsonDecode(response.body);
      Anime anime = Anime.fromJSONAnimeWithDetails(map);
      return anime;
    } else {
      debugPrint("Anime detay apiye bağlanma başarısız");
      throw Exception("Anime detay HATA MYANIMELIST API CALL METHOD");
    }
  }

//********************************************************************************************
//********************************************************************************************
  Future<List<Anime>> lastSeasonAnimeleriGetir(String value) async {
    var accessToken = await readToken();
    //Geçtiğimiz dönemi aldığımız değişken.
    int year = 2020;
    List<Anime> _animelerListesi = [];
    int limit = 100;
    http.Response response;

    response = await http.get(
        'https://api.myanimelist.net/v2/anime/season/2020/${lastSeason.toLowerCase()}?sort=anime_num_list_users&limit=$limit&fields=num_episodes,id,title,genres,start_date,end_date,status,num_list_users,my_list_status,mean,media_type',
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        });

    if (response.statusCode == 200) {
      Map map = await jsonDecode(response.body);
      for (int i = 0; i < limit; i++) {
        Anime anime = Anime.fromJSONwithoutRankWithSeason(map, i);

        //her bir tab değiştiğinde apiye istek atmak yerine tv newleri bir listede tv contları bir listede tutup bu listeleri döndürebiliriz
        //bir kez istek atıp listeleri döndürdükten sonra bir daha istek atmadan dolu listeleri tekrar tekrar gösterebiliriz
        //bunu yapmak daha mantıklı geldi o yüzden aklında geldiği bir zaman bunlarla ilgilen.
        //bunun için şöyle yapabiliriz : if(tv mi ) (e)=> for(tüm animeler)=> tvleri bul tvler listesine at döndür.
        //aynı mantığı tüm tablar için yaparsak her taba bir kez bastığımızda listeler dolacaktır ve bir daha istek atmak zorunda kalmadan animeleri hızlıca getirebiliriz

        //ayrıca bir bug var. örneğin tab tv new deyken ovaya geçtin ve ovaları ekrana getirdin. Daha sonra başka bir yere gidip geri döndüğünde
        //tab eski adına geri dönüyor (tv new) ancak ekranda ova olan animeler bulunuyor. Bunu da hallet.

        if (value == "TV(cont'd)") {
          if (int.parse(anime.startDate.split("-")[0]) < year &&
              anime.mediaType == "tv") {
            _animelerListesi.add(anime);
          } else {}
        } else if (value == "TV(new)") {
          if (int.parse(anime.startDate.split("-")[0]) == year &&
              anime.mediaType == "tv") {
            _animelerListesi.add(anime);
          } else {}
        } else if (value == "OVA") {
          if (anime.mediaType == "ova") {
            _animelerListesi.add(anime);
          } else {}
        } else if (value == "ONA") {
          if (anime.mediaType == "ona") {
            _animelerListesi.add(anime);
          } else {}
        } else if (value == "Movie") {
          if (anime.mediaType == "movie") {
            _animelerListesi.add(anime);
          } else {}
        } else if (value == "Special") {
          if (anime.mediaType == "special") {
            _animelerListesi.add(anime);
          } else {}
        }
      }

      return _animelerListesi;
    } else {
      debugPrint("This season apiye bağlanma başarısız");
      throw Exception("This season HATA MYANIMELIST API CALL METHOD");
    }
  }

//********************************************************************************************
//********************************************************************************************
  Future<List<Anime>> nextSeasonAnimeleriGetir(String value) async {
    var accessToken = await readToken();
    //Geçtiğimiz dönemi aldığımız değişken.
    int year = 2021;
    List<Anime> _animelerListesi = [];
    //apide kaç veri olduğunu bilmediğimden dolayı eğer apideki değerden fazla limit girersem çalışmıyor.
    //o yüzden şimdilik elimle limit değerini giriyorum ama bir yolunu bulabilirsem değiştiririm.
    int limit = 45;
    http.Response response;

    response = await http.get(
        'https://api.myanimelist.net/v2/anime/season/2021/${nextSeason.toLowerCase()}?sort=anime_num_list_users&limit=$limit&fields=num_episodes,id,title,genres,start_date,end_date,status,num_list_users,my_list_status,mean,media_type',
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        });

    if (response.statusCode == 200) {
      Map map = await jsonDecode(response.body);
      for (int i = 0; i < limit; i++) {
        Anime anime = Anime.fromJSONwithoutRankWithSeason(map, i);
        //her bir tab değiştiğinde apiye istek atmak yerine tv newleri bir listede tv contları bir listede tutup bu listeleri döndürebiliriz
        //bir kez istek atıp listeleri döndürdükten sonra bir daha istek atmadan dolu listeleri tekrar tekrar gösterebiliriz
        //bunu yapmak daha mantıklı geldi o yüzden aklında geldiği bir zaman bunlarla ilgilen.
        //bunun için şöyle yapabiliriz : if(tv mi ) (e)=> for(tüm animeler)=> tvleri bul tvler listesine at döndür.
        //aynı mantığı tüm tablar için yaparsak her taba bir kez bastığımızda listeler dolacaktır ve bir daha istek atmak zorunda kalmadan animeleri hızlıca getirebiliriz

        //ayrıca bir bug var. örneğin tab tv new deyken ovaya geçtin ve ovaları ekrana getirdin. Daha sonra başka bir yere gidip geri döndüğünde
        //tab eski adına geri dönüyor (tv new) ancak ekranda ova olanlar bulunuyor. Bunu da halletbi ara

        if (value == "TV(cont'd)") {
          if (int.parse(anime.startDate.split("-")[0]) < year &&
              anime.mediaType == "tv") {
            _animelerListesi.add(anime);
          } else {}
        } else if (value == "TV(new)") {
          if (int.parse(anime.startDate.split("-")[0]) == year &&
              anime.mediaType == "tv") {
            _animelerListesi.add(anime);
          } else {}
        } else if (value == "OVA") {
          if (anime.mediaType == "ova") {
            _animelerListesi.add(anime);
          } else {}
        } else if (value == "ONA") {
          if (anime.mediaType == "ona") {
            _animelerListesi.add(anime);
          } else {}
        } else if (value == "Movie") {
          if (anime.mediaType == "movie") {
            _animelerListesi.add(anime);
          } else {}
        } else if (value == "Special") {
          if (anime.mediaType == "special") {
            _animelerListesi.add(anime);
          } else {}
        }
      }

      return _animelerListesi;
    } else {
      debugPrint("This season apiye bağlanma başarısız");
      throw Exception("This season HATA MYANIMELIST API CALL METHOD");
    }
  }
//********************************************************************************************
//********************************************************************************************
}
