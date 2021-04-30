import 'package:flutter/material.dart';
import 'package:flutter_anichat/locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_anichat/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

import 'app/landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyAnimeList',
        home: LandingPage(),
      ),
    );
  }
}
