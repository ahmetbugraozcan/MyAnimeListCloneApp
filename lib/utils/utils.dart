import 'package:flutter/material.dart';
import 'package:flutter_anichat/model/anime.dart';

class Utils {
  // Verilen parametrenin baş harfini büyük yazar.
  String basHarfiBuyukYaz(String source) {
    if (source == "tv") {
      return "TV";
    }
    if (source.contains("_")) {
      source = source.replaceAll("_", " ");
      source = source.substring(0, 1).toUpperCase() +
          source.substring(1).toLowerCase();
      return source;
    } else {
      source = source.substring(0, 1).toUpperCase() +
          source.substring(1).toLowerCase();
      return source;
    }
  }

  //Verilen tarihi Jan 4, 2020 formatında bir stringe dönüştrürür
  dateYaz(String date) {
    String month = "";
    String day = "";
    String year;
    String dondurulecekString = "";
    if (date == "?") {
      return date;
    } else {
      if (date.contains("-")) {
        if (date.split("-").length > 2) {
          day = date.split("-")[2];
          if (day.startsWith("0")) {
            day = day.replaceAll("0", "");
          }
        }

        if (date.split("-")[1] != null) {
          if (date.split("-")[1] == "01") {
            month = "Jan";
          } else if (date.split("-")[1] == "02") {
            month = "Feb";
          } else if (date.split("-")[1] == "03") {
            month = "Mar";
          } else if (date.split("-")[1] == "04") {
            month = "Apr";
          } else if (date.split("-")[1] == "05") {
            month = "May";
          } else if (date.split("-")[1] == "06") {
            month = "Jun";
          } else if (date.split("-")[1] == "07") {
            month = "July";
          } else if (date.split("-")[1] == "08") {
            month = "Aug";
          } else if (date.split("-")[1] == "09") {
            month = "Sep";
          } else if (date.split("-")[1] == "10") {
            month = "Oct";
          } else if (date.split("-")[1] == "11") {
            month = "Nov";
          } else if (date.split("-")[1] == "12") {
            month = "Dec";
          }
        }
        year = date.split("-")[0];
      } else {
        return date;
      }

      day == ""
          ? dondurulecekString = month + day + ", " + year + " "
          : dondurulecekString = month + " " + day + ", " + year + " ";
      return dondurulecekString;
    }
  }

  //Verilen stringi verilen sınır parametresine kadar yazar sonra ... koyar.
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

  genreKontrol(Anime anime) {
    String genres = "";
    if (anime.genres.length > 3) {
      for (int i = 0; i < 3; i++) {
        var animeGenre = Map<String, dynamic>.from(anime.genres[i]);
        if (i == 0) {
          genres += animeGenre["name"] + ", ";
        } else if (i == 2) {
          genres += animeGenre["name"];
        } else {
          genres += animeGenre["name"] + ", ";
        }
      }
    } else {
      for (int i = 0; i < anime.genres.length; i++) {
        var animeGenre = Map<String, dynamic>.from(anime.genres[i]);
        if (i == 0 && anime.genres.length == 1) {
          genres += animeGenre["name"] + "";
        } else if (i == 0 && anime.genres.length > 1) {
          genres += animeGenre["name"] + ", ";
        } else if (i == anime.genres.length - 1) {
          genres += animeGenre["name"];
        } else {
          genres += animeGenre["name"] + ", ";
        }
      }
    }

    var dondurulecekGenres = doControlStringLength(genres, 27);
    return Text(
      dondurulecekGenres,
      style: TextStyle(
        fontSize: 13,
        color: Colors.black54,
      ),
    );
  }

  // 2020 Winter, 2019 Summer gibi stringler döner
  String dateAndSeason(String date) {
    String season = "";
    String day = "";
    String year;
    if (!date.contains("-")) {
      return date;
    }
    // print("Asıl date : " + date + "\n");
    // print("Split : " + date.split("-")[1]);
    if (date == "???") {
      return date;
    } else {
      if (date.split("-")[1] != null) {
        if (date.split("-")[1] == "01" ||
            date.split("-")[1] == "02" ||
            date.split("-")[1] == "12") {
          season = "Winter";
        } else if (date.split("-")[1] == "03" ||
            date.split("-")[1] == "04" ||
            date.split("-")[1] == "05") {
          season = "Spring";
        } else if (date.split("-")[1] == "06" ||
            date.split("-")[1] == "07" ||
            date.split("-")[1] == "08") {
          season = "Summer";
        } else if (date.split("-")[1] == "06" ||
            date.split("-")[1] == "07" ||
            date.split("-")[1] == "08") {
          season = "Summer";
        } else if (date.split("-")[1] == "09" ||
            date.split("-")[1] == "10" ||
            date.split("-")[1] == "11") {
          season = "Fall";
        }
      }
      date = season + " " + date.split("-")[0];
      return date;
    }
  }
}
