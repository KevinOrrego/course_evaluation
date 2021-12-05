import 'package:course_evaluation/screens/lobby_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:course_evaluation/components/loader_component.dart';
import 'package:course_evaluation/helpers/constants.dart';
import 'package:course_evaluation/models/token.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _rememberme = true;
  bool _showLoader = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _showTitle(),
          _showGoogleLoginButton(),
          // Container(
          //   padding: const EdgeInsets.all(30),
          //   child: FloatingActionButton.extended(
          //     onPressed: () {
          //       // este elemento hace que me mueva entre pantallas
          //       Navigator.of(context)
          //           .push(MaterialPageRoute(builder: (BuildContext context) {
          //         return const LobbyScreen();
          //       }));
          //     },
          //     label: const Text(
          //       "Ir a la lista",
          //       style: TextStyle(color: Colors.black, fontSize: 22),
          //     ),
          //     backgroundColor: Colors.amber,
          //   ),
          // ),
        ],
      )),
    );
  }

  Widget _showTitle() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Text(
        "Bienvenido a la sistema de calificación de programación distribuida",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _storeUser(String body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRemembered', true);
    await prefs.setString('userBody', body);
  }

  Widget _showGoogleLoginButton() {
    return Row(
      children: <Widget>[
        Expanded(
            child: ElevatedButton.icon(
                onPressed: () => _loginGoogle(),
                icon: const FaIcon(
                  FontAwesomeIcons.google,
                  color: Colors.red,
                ),
                label: const Text('Iniciar sesión con Google'),
                style: ElevatedButton.styleFrom(
                    primary: Colors.white, onPrimary: Colors.black)))
      ],
    );
  }

  void _loginGoogle() async {
    setState(() {
      _showLoader = true;
    });

    var googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    var user = await googleSignIn.signIn();

    if (user == null) {
      setState(() {
        _showLoader = false;
      });

      await showAlertDialog(
          context: context,
          title: 'Error',
          message:
              'Hubo un problema al obtener el usuario de Google, por favor intenta más tarde.',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Map<String, dynamic> request = {
      'email': user.email,
      'id': user.id,
      'loginType': 1,
      'fullName': user.displayName,
      'photoURL': user.photoUrl,
    };

    await _socialLogin(request);
  }

  Future _socialLogin(Map<String, dynamic> request) async {
    var url = Uri.parse('${Constants.apiUrl}/api/Account/SocialLogin');
    var bodyRequest = jsonEncode(request);
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: bodyRequest,
    );

    setState(() {
      _showLoader = false;
    });

    if (response.statusCode >= 400) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message:
              'El usuario ya inció sesión previamente por email o por otra red social.',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    var body = response.body;

    if (_rememberme) {
      _storeUser(body);
    }

    var decodedJson = jsonDecode(body);
    var token = Token.fromJson(decodedJson);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LobbyScreen(
                  token: token,
                )));
  }
}
