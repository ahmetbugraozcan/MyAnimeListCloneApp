import 'package:flutter/material.dart';

class MesajPageDeneme extends StatefulWidget {
  @override
  _MesajPageDenemeState createState() => _MesajPageDenemeState();
}

class _MesajPageDenemeState extends State<MesajPageDeneme> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mesaj Page"),
      ),
      backgroundColor: Colors.pinkAccent,
      body: Container(
        child: Text("Mesaj Page"),
      ),
    );
  }
}
