import 'package:course_evaluation/models/survey.dart';
import 'package:flutter/material.dart';
import 'package:course_evaluation/models/token.dart';

class LobbyScreen extends StatefulWidget {
  final Token token;
  final Survey survey;

  LobbyScreen({required this.token, required this.survey});

  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Encuesta de programación distribuida')),
      body: Center(
        child: Text('Proximamente se cargará información'),
      ),
    );
  }
}
