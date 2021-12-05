import 'dart:convert';
// import 'dart:developer';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:course_evaluation/components/loader_component.dart';
import 'package:course_evaluation/helpers/constants.dart';
import 'package:course_evaluation/models/facts.dart';
import 'package:course_evaluation/models/single_anime_item.dart';
import 'package:http/http.dart' as http;

class SingleAnime extends StatefulWidget {
  final String animeName;

  const SingleAnime({Key? key, required this.animeName}) : super(key: key);

  @override
  _SingleAnimeState createState() => _SingleAnimeState();
}

class _SingleAnimeState extends State<SingleAnime> {
  late SingleAnimeItem _singleAnimeItem;
  final List _facts = [];
  bool _showLoader = false;

  @override
  void initState() {
    super.initState();
    _getSingleAnime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Text(_getName()),
      ),
      body: _showLoader
          ? LoaderComponent(text: 'Por favor espere...')
          : _getContent(),
    );
  }

  String _getName() {
    return widget.animeName.replaceAll("_", " ");
  }

  void _getSingleAnime() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Problemas de conexion'),
              content: Text('Verifica que estas conectado a internet'),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Aceptar')),
              ],
            );
          });

      return;
    }

    var url = Uri.parse('${Constants.apiUrl}/${widget.animeName}');

    var response = await http.get(url, headers: {
      'content-type': 'application/json',
      'accept': 'application/json',
    });

    setState(() {
      _showLoader = false;
    });

    var body = response.body;
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      _singleAnimeItem = SingleAnimeItem.fromJson(decodedJson);
      for (var item in decodedJson['data']) {
        _facts.add(Fact.fromJson(item));
      }
    }

    // print(_facts[0].fact);
  }

  _getContent() {
    return _singleAnimeItem.success ? _getListView() : _noContent();
  }

  Widget _getListView() {
    return Center(
        child: SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            _singleAnimeItem.img,
            // width: 120,
            // height: 120,
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Flexible(
                child: Text(
              'Número de hechos disponibles: ${_singleAnimeItem.totalFacts.toString()}',
              overflow: TextOverflow.fade,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 28,
              ),
            )),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '- ${_facts[0].fact}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text('- ${_facts[1].fact}',
                      style: const TextStyle(fontSize: 20)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text('- ${_facts[2].fact}',
                      style: const TextStyle(fontSize: 20)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text('- ${_facts[3].fact}',
                      style: const TextStyle(fontSize: 20)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text('- ${_facts[4].fact}',
                      style: const TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _noContent() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(30),
        child: const Text('Actualmente no hay animes disponibles',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // _getFacts() {
  //   return ListView.builder(
  //       itemCount: _facts.length,
  //       itemBuilder: (context, index) {
  //         return Text(_facts[index].fact);
  //       });
  // }
  // Widget _getFacts() {
  //   return ListView.builder(
  //       itemCount: _facts.length,
  //       itemBuilder: (context, index) {
  //         return ListTile(
  //           title: Text('- ${_facts[index].fact}'),
  //         );
  //       });
  // }
}
