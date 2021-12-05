import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:course_evaluation/components/loader_component.dart';
import 'package:course_evaluation/helpers/constants.dart';
import 'package:course_evaluation/models/anime.dart';
import 'package:http/http.dart' as http;
import 'package:course_evaluation/screens/single_anime.dart';
import 'package:connectivity/connectivity.dart';

class AnimeList extends StatefulWidget {
  const AnimeList({Key? key}) : super(key: key);

  @override
  _AnimeListState createState() => _AnimeListState();
}

class _AnimeListState extends State<AnimeList> {
  List<Anime> _animes = [];
  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = "";

  @override
  void initState() {
    super.initState();
    _getAnimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: const Text('Lista de animes disponibles'),
        actions: <Widget>[
          _isFiltered
              ? IconButton(
                  onPressed: _removeFilter, icon: Icon(Icons.filter_none))
              : IconButton(onPressed: _showFilter, icon: Icon(Icons.filter_alt))
        ],
      ),
      body: _showLoader
          ? LoaderComponent(text: 'Por favor espere...')
          : _getContent(),
    );
  }

  void _getAnimes() async {
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

    var url = Uri.parse(Constants.apiUrl);

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
      for (var item in decodedJson['data']) {
        _animes.add(Anime.fromJson(item));
      }
    }
  }

  Widget _getContent() {
    return _animes.isEmpty ? _noContent() : _getListView();
  }

  Widget _noContent() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(30),
        child: Text(
            _isFiltered
                ? 'No hay animes con ese criterio de busqueda'
                : 'Actualmente no hay animes disponibles',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _getListView() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 30),
      children: _animes.map((e) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SingleAnime(animeName: e.animeName)));
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.lightBlue),
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            margin:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              children: [
                Image.network(
                  e.animeImg,
                  width: 120,
                  height: 120,
                ),
                Flexible(
                  child: Text(
                    e.animeName.replaceAll("_", " "),
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _removeFilter() {
    setState(() {
      _isFiltered = false;
    });
    _animes = [];
    _getAnimes();
  }

  void _showFilter() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text('Filtrar Animes'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Escriba las primeras letras del anime'),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                      hintText: 'Escribe tu busqueda',
                      labelText: 'Buscar',
                      suffixIcon: Icon(Icons.search)),
                  onChanged: (value) {
                    setState(() {
                      _search = value;
                    });
                  },
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar')),
              TextButton(
                  onPressed: () => _filter(), child: const Text('Buscar')),
            ],
          );
        });
  }

  void _filter() {
    if (_search.isEmpty) {
      return;
    }

    List<Anime> filteredList = [];
    for (var anime in _animes) {
      if (anime.animeName
          .replaceAll("_", " ")
          .toLowerCase()
          .contains(_search.toLowerCase())) {
        filteredList.add(anime);
      }
    }

    setState(() {
      _animes = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }
}
