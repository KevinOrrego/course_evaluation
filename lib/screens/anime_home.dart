import 'package:flutter/material.dart';
import 'anime_list.dart';

class AnimeHome extends StatefulWidget {
  const AnimeHome({Key? key}) : super(key: key);

  @override
  _AnimeHomeState createState() => _AnimeHomeState();
}

class _AnimeHomeState extends State<AnimeHome> {
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _showTitle(),
          _showLogo(),
          Container(
            padding: const EdgeInsets.all(30),
            child: FloatingActionButton.extended(
              onPressed: () {
                // este elemento hace que me mueva entre pantallas
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return const AnimeList();
                }));
              },
              label: const Text(
                "Ir a la lista",
                style: TextStyle(color: Colors.black, fontSize: 22),
              ),
              backgroundColor: Colors.amber,
            ),
          ),
        ],
      )),
    );
  }

  Widget _showLogo() {
    return const Image(
      image: AssetImage('assets/logo.png'),
      width: 300,
    );
  }

  Widget _showTitle() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Text(
        "Bienvenido a la lista de animes Zenitsu",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}


// endpoints:

// todos los animes:
// https://anime-facts-rest-api.herokuapp.com/api/v1

// un solo anime:
// https://anime-facts-rest-api.herokuapp.com/api/v1/nombredelanime