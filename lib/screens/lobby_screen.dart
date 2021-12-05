import 'package:flutter/material.dart';
import 'package:course_evaluation/models/token.dart';

class LobbyScreen extends StatefulWidget {
  final Token token;

  LobbyScreen({required this.token});

  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Text(
        "Por favor escoja una forma de visualización",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
