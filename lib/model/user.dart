import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserAcc {
  String email;
  int userID;
  String profilePhotoUrl;
  String userName;
  String gender;
  String birthday;
  String location;
  String uID;
  String joinedAt;
  int numItemsWatching;
  int numItemsCompleted;
  int numItemsOnHold;
  int numItemsDropped;
  int numItemsPlanToWatch;
  int numItems;
  double numDaysWatched;
  double numDaysWatching;
  double numDaysCompleted;
  double numDaysOnHold;
  double numDaysDropped;
  double numDays;
  int numEpisodes;
  int numTimesRewatched;
  int meanScore;

  UserAcc({
    @required this.userID,
    @required this.profilePhotoUrl,
    @required this.userName,
    @required this.gender,
    @required this.birthday,
    @required this.location,
    @required this.joinedAt,
    @required this.numDays,
    @required this.numItems,
    @required this.numItemsCompleted,
    @required this.numItemsWatching,
    @required this.numItemsOnHold,
    @required this.numItemsDropped,
    @required this.numItemsPlanToWatch,
    @required this.meanScore,
  });
  UserAcc.withEmail({@required this.email, @required this.uID});
}
