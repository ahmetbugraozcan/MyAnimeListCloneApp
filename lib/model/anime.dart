import 'package:flutter/cupertino.dart';

class Anime {
  int id;
  String title;
  String medium;

  String large;
  int rank;
  int year;
  String season;
  String startDate;
  double mean;
  int numListUsers;
  String genre;
  String mediaType;

  //---------------------------------------------------------------//
  Object alternativeTitles;
  int popularity;
  int numScoringUsers;
  String synopsis;
  String createdAt;
  int numEpisodes;
  Object startSeason;
  String source;
  String rating;
  List<Object> relatedAnime;
  List<Object> recommendations;
  List<Object> pictures;
  List<Object> genres;
  List<Object> studios;
  Object statistics;
  String status;
  String animeUserStatus;
  int averageEpisodeDuration;
  String endDate;
  int numWatchedEpisodes;
  int score;
  bool isRewatching;
  String userStartDate;
  String userFinishDate;
  String userUpdateDate;
  int userScore;
  Object myListStatus;
  Object mainPicture;
  Anime({this.id, this.title, this.medium, this.large, this.rank});
  Anime.withoutRankWithSeason({
    this.id,
    this.title,
    this.medium,
    this.large,
    this.year,
    this.season,
    this.numListUsers,
    this.startDate,
    this.mean,
    this.genre,
    this.mediaType,
    this.genres,
    this.myListStatus,
    this.endDate,
    this.status,
    this.numEpisodes,
  });

  Anime.withDetails(
      {this.id,
      this.title,
      this.medium,
      this.large,
      this.alternativeTitles,
      this.startDate,
      this.synopsis,
      this.mean,
      this.rank,
      this.popularity,
      this.numListUsers,
      this.numScoringUsers,
      this.mediaType,
      this.createdAt,
      this.status,
      this.genres,
      this.numEpisodes,
      this.startSeason,
      this.source,
      this.rating,
      this.pictures,
      this.relatedAnime,
      this.recommendations,
      this.studios,
      this.statistics,
      this.averageEpisodeDuration,
      this.endDate,
      this.myListStatus});
  Anime.AnimeForMyList({
    this.id,
    this.title,
    this.medium,
    this.large,
    this.status,
    this.score,
    this.numWatchedEpisodes,
    this.isRewatching,
    this.mediaType,
    this.genres,
    this.animeUserStatus,
    this.numEpisodes,
    this.startDate,
    this.endDate,
    this.myListStatus,
  });
  Anime.AnimeForSearchPage(
      {this.mainPicture,
      this.id,
      this.title,
      this.status,
      this.mediaType,
      this.genres,
      this.numEpisodes,
      this.startDate,
      this.endDate,
      this.myListStatus,
      this.numListUsers,
      this.mean});
  Anime.AnimeForAddMyListPage(
      {this.id,
      this.title,
      this.startDate,
      this.endDate,
      this.status,
      this.numEpisodes,
      this.myListStatus});

  // factory Anime.fromJSONDeneme(Map<String, dynamic> gelenMap, int index) {
  //   return Anime(
  //     id: gelenMap['data'][index]['node']['id'],
  //     title: gelenMap['data'][index]['node']['title'],
  //     medium: gelenMap['data'][index]['node']['main_picture'] == null
  //         ? "https://ordukilisesi.com/wp-content/uploads/2019/04/no-image-icon-21.png"
  //         : gelenMap['data'][index]['node']['main_picture']['medium'],
  //     large: gelenMap['data'][index]['node']['main_picture']['large'] == null
  //         ? "https://ordukilisesi.com/wp-content/uploads/2019/04/no-image-icon-21.png"
  //         : gelenMap['data'][index]['node']['main_picture']['large'],
  //   );
  // }

  factory Anime.fromJSON(Map<String, dynamic> gelenMap, int index) {
    return Anime(
      id: gelenMap['data'][index]['node']['id'],
      title: gelenMap['data'][index]['node']['title'],
      medium: gelenMap['data'][index]['node']['main_picture'] == null
          ? "https://ordukilisesi.com/wp-content/uploads/2019/04/no-image-icon-21.png"
          : gelenMap['data'][index]['node']['main_picture']['medium'],
      large: gelenMap['data'][index]['node']['main_picture']['large'] == null
          ? "https://ordukilisesi.com/wp-content/uploads/2019/04/no-image-icon-21.png"
          : gelenMap['data'][index]['node']['main_picture']['large'],
      rank: gelenMap['data'][index]['ranking']['rank'],
    );
  }

  factory Anime.fromJSONwithoutRankWithSeason(
      Map<String, dynamic> gelenMap, int index) {
    return Anime.withoutRankWithSeason(
      id: gelenMap['data'][index]['node']['id'],
      title: gelenMap['data'][index]['node']['title'],
      medium: gelenMap['data'][index]['node']['main_picture'] == null
          ? "https://ordukilisesi.com/wp-content/uploads/2019/04/no-image-icon-21.png"
          : gelenMap['data'][index]['node']['main_picture']['medium'],
      large: gelenMap['data'][index]['node']['main_picture'] == null
          ? "https://ordukilisesi.com/wp-content/uploads/2019/04/no-image-icon-21.png"
          : gelenMap['data'][index]['node']['main_picture']['large'],
      year: gelenMap['season']['year'],
      season: gelenMap['season']['season'],
      startDate: gelenMap['data'][index]['node']['start_date'] == null
          ? 2020
          : gelenMap['data'][index]['node']['start_date'],
      numListUsers: gelenMap['data'][index]['node']['num_list_users'] == null
          ? "0"
          : gelenMap['data'][index]['node']['num_list_users'],
      mean: gelenMap['data'][index]['node']['mean'] == null
          ? 0.0
          : (gelenMap['data'][index]['node']['mean']).toDouble(),
      genre: gelenMap['data'][index]['node']['genres'][0]['name'] == null
          ? "Action"
          : gelenMap['data'][index]['node']['genres'][0]['name'],
      genres: gelenMap['data'][index]['node']['genres'],
      mediaType: gelenMap['data'][index]['node']['media_type'],
      myListStatus: gelenMap['data'][index]['node']['my_list_status'] ?? null,
      endDate: gelenMap['data'][index]['node']['end_date'] ?? "???",
      status: gelenMap['data'][index]['node']['status'] == "currently_airing"
          ? "Airing"
          : gelenMap['data'][index]['node']['status'] == "finished_airing"
              ? "Finished"
              : "Not Yet Aired",
      numEpisodes: gelenMap['data'][index]['node']['num_episodes'],
    );
  }

  factory Anime.fromJSONAnimeWithDetails(Map<String, dynamic> gelenMap) {
    return Anime.withDetails(
      id: gelenMap["id"],
      title: gelenMap["title"],
      medium: gelenMap['main_picture'] == null
          ? "https://ordukilisesi.com/wp-content/uploads/2019/04/no-image-icon-21.png"
          : gelenMap['main_picture']['medium'],
      large: gelenMap['main_picture'] == null
          ? "https://ordukilisesi.com/wp-content/uploads/2019/04/no-image-icon-21.png"
          : gelenMap['main_picture']['large'],
      alternativeTitles: gelenMap["alternative_titles"],
      startDate: gelenMap["start_date"] == null ? "?" : gelenMap["start_date"],
      synopsis: gelenMap["synopsis"],
      mean: gelenMap["mean"] == null ? 0.0 : (gelenMap["mean"]).toDouble(),
      rank: gelenMap["rank"],
      popularity: gelenMap["popularity"],
      numListUsers: gelenMap["num_list_users"],
      numScoringUsers: gelenMap["num_scoring_users"],
      mediaType: gelenMap["media_type"],
      createdAt: gelenMap["created_at"],
      status: gelenMap["status"] == "currently_airing"
          ? "Airing"
          : gelenMap["status"] == "not_yet_aired"
              ? "Not Yet Aired"
              : gelenMap["status"] == "finished_airing" ? "Finished" : "???",
      genres: gelenMap["genres"],
      numEpisodes: gelenMap["num_episodes"],
      source: gelenMap["source"],
      rating: gelenMap["rating"] == null ? "None" : gelenMap["rating"],
      pictures: gelenMap["pictures"] ?? [],
      relatedAnime: gelenMap["related_anime"],
      recommendations: gelenMap["recommendations"],
      studios: gelenMap["studios"] == null ? [] : gelenMap["studios"],
      statistics: gelenMap["statistics"],
      startSeason: gelenMap["start_season"],
      averageEpisodeDuration: gelenMap["average_episode_duration"],
      endDate: gelenMap["end_date"] == null ? "?" : gelenMap["end_date"],
      myListStatus: gelenMap['my_list_status'] ?? null,
    );
  }
  //buradan genres kısmını sildik bir bug vs olursa buraya bak
  factory Anime.fromJSONAnimeForMyList(
      Map<String, dynamic> gelenMap, int index) {
    return Anime.AnimeForMyList(
      id: gelenMap["data"][index]["node"]["id"] == null
          ? 0
          : gelenMap["data"][index]["node"]["id"],
      title: gelenMap["data"][index]["node"]["title"],
      medium: gelenMap["data"][index]["node"]["main_picture"]["medium"],
      large: gelenMap["data"][index]["node"]["main_picture"]["large"],
      animeUserStatus: gelenMap["data"][index]["list_status"]["status"] == null
          ? "  "
          : gelenMap["data"][index]["list_status"]["status"],
      score: gelenMap["data"][index]["list_status"]["score"] == null
          ? 0
          : gelenMap["data"][index]["list_status"]["score"],
      numWatchedEpisodes: gelenMap["data"][index]["list_status"]
          ["num_episodes_watched"],
      isRewatching:
          gelenMap["data"][index]["list_status"]["is_rewatching"] == null
              ? false
              : gelenMap["data"][index]["list_status"]["is_rewatching"],
      mediaType: gelenMap["data"][index]["node"]["media_type"],
      status: gelenMap["data"][index]["node"]["status"] == "currently_airing"
          ? "Airing"
          : gelenMap["data"][index]["node"]["status"] == "not_yet_aired"
              ? "Not Yet Aired"
              : gelenMap["data"][index]["node"]["status"] == "finished_airing"
                  ? "Finished"
                  : "???",
      numEpisodes: gelenMap["data"][index]["node"]["num_episodes"],
      startDate: gelenMap["data"][index]["node"]["start_date"] == null
          ? "??"
          : gelenMap["data"][index]["node"]["start_date"],
      endDate: gelenMap["data"][index]["node"]["end_date"] == null
          ? "??"
          : gelenMap["data"][index]["node"]["end_date"],
      myListStatus: gelenMap['data'][index]['node']['my_list_status'] ?? null,
    );
  }
  //list status parametresi burada olmadığından dolayı sorun yaşıyoruz
  //buradan bir şey silemeyiz çünkü buradaki animeleri de anime detail pageye gönderiyoruz
//list_statusu silebiliriz sadece my list statusten de detail page açılabiliyor
  factory Anime.fromJSONAnimeForSearchedAnimes(
      Map<String, dynamic> gelenMap, int index) {
    return Anime.AnimeForSearchPage(
        id: gelenMap["data"][index]["node"]["id"] == null
            ? 0
            : gelenMap["data"][index]["node"]["id"],
        title: gelenMap["data"][index]["node"]["title"],
        mainPicture: gelenMap["data"][index]["node"]["main_picture"] ?? null,
        mediaType: gelenMap["data"][index]["node"]["media_type"],
        status: gelenMap["data"][index]["node"]["status"] == "currently_airing"
            ? "Airing"
            : gelenMap["data"][index]["node"]["status"] == "not_yet_aired"
                ? "Not Yet Aired"
                : gelenMap["data"][index]["node"]["status"] == "finished_airing"
                    ? "Finished"
                    : "???",
        numEpisodes: gelenMap["data"][index]["node"]["num_episodes"],
        startDate: gelenMap["data"][index]["node"]["start_date"] == null
            ? "??"
            : gelenMap["data"][index]["node"]["start_date"],
        endDate: gelenMap["data"][index]["node"]["end_date"] == null
            ? "??"
            : gelenMap["data"][index]["node"]["end_date"],
        myListStatus: gelenMap['data'][index]['node']['my_list_status'] ?? null,
        numListUsers: gelenMap['data'][index]['node']['num_list_users'] ?? 0,
        mean: gelenMap['data'][index]['node']['mean'] == null
            ? 0.0
            : (gelenMap['data'][index]['node']['mean']).toDouble());
  }

// factory Anime.fromJSONAnimeForAddMyListPage(Map<String, dynamic> gelenMap) {
  //   return Anime.AnimeForAddMyListPage(
  //     id: gelenMap["id"],
  //     title: gelenMap["title"],
  //     startDate: gelenMap["start_date"] ?? "???",
  //     endDate: gelenMap["end_date"] ?? "???",
  //     status: gelenMap["status"],
  //     numEpisodes: gelenMap["num_episodes"],
  //     myListStatus: gelenMap["my_list_status"] ?? null,
  //   );
  // }
} /*gelenMap["status"] == "currently_airing"
          ? "Airing"
          : gelenMap["status"] == "not_yet_aired"
              ? "Not Yet Aired"
              : gelenMap["status"] == "finished_airing" ? "Finished" : "???"*/
