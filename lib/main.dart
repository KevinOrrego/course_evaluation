import 'package:flutter/material.dart';
import 'package:course_evaluation/screens/anime_home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Anime list on pocket',
        home: AnimeHome());
  }
}
