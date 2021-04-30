import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_anichat/app/user_add_anime_to_mylist.dart';
import 'package:flutter_anichat/model/anime.dart';

class AddAnimeToMyList extends StatelessWidget {
  final Anime anime;
  final double width;
  final double height;
  final Icon icon;
  final Color color;
  final EdgeInsetsGeometry margin;
  final Decoration decoration;
  final VoidCallback ontap;
  const AddAnimeToMyList({
    Key key,
    @required this.margin,
    @required this.width,
    @required this.height,
    @required this.anime,
    this.icon,
    this.color,
    this.decoration,
    this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap ??
          () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => UserAddAnimeToMyList(
                          anime: anime,
                        )));
          },
      child: Container(
        margin: margin ??
            EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.091,
                bottom: MediaQuery.of(context).size.height * 0.013),
        width: width ?? MediaQuery.of(context).size.width / 10.97,
        height: height ?? MediaQuery.of(context).size.height / 16.91,
        decoration: decoration ?? null,
        child: icon ??
            Icon(
              Icons.list,
              color: Colors.black54,
            ),
      ),
    );
  }
}
