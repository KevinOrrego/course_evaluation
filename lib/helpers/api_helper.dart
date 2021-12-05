import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:course_evaluation/helpers/constants.dart';
import 'package:course_evaluation/models/survey.dart';
import 'package:course_evaluation/models/token.dart';
import 'package:course_evaluation/models/user.dart';
import 'package:course_evaluation/models/response.dart';

class ApiHelper {
  static Future<Response> getSurvey(Token token) async {
    if (!_validToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }

    var url = Uri.parse('${Constants.apiUrl}/api/Finals');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': 'bearer ${token.token}',
      },
    );

    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    // List<Survey> list = [];
    var decodedJson = jsonDecode(body);
    // if (decodedJson != null) {
    //   for (var item in decodedJson) {
    //     list.add(Survey.fromJson(item));
    //   }
    // }

    return Response(isSuccess: true, result: decodedJson);
  }

  static bool _validToken(Token token) {
    if (DateTime.parse(token.expiration).isAfter(DateTime.now())) {
      return true;
    }

    return false;
  }
}
