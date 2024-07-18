import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/secret_keys.dart';

class PersonalDetails with ChangeNotifier {
  final String accessToken = Constants.accessToken;

  String age = '';
  String biography = '';
  List knownFor = [];

  Future<void> calculateAge(String birthDateString) async {
    DateTime birthDate = DateTime.parse(birthDateString);
    DateTime currentDate = DateTime.now();
    int currentAge = currentDate.year - birthDate.year;

    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      currentAge--;
    }

    age = currentAge.toString();
    notifyListeners();
  }

  Future<void> getPersonDetailById(String id) async {
    log('Person Id: $id', name: 'Person Id');
    try {
      final res = await http.get(
        Uri.parse('https://api.themoviedb.org/3/person/$id'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'accept': 'application/json',
        },
      );

      Map resBody = jsonDecode(res.body);

      biography = resBody['biography'];
      notifyListeners();

      // calculate age
      calculateAge(resBody['birthday']);
    } catch (e) {
      log(e.toString(), name: 'Person Detail By Id');
    }
  }

  Future<void> getPersonDetailByName(String name) async {
    try {
      final res = await http.get(
        Uri.parse('https://api.themoviedb.org/3/search/person?query=$name'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'accept': 'application/json',
        },
      );

      Map resBody = jsonDecode(res.body);

      knownFor = resBody['results'][0]['known_for'];
      notifyListeners();
    } catch (e) {
      log(e.toString(), name: 'Person Detail By Name');
    }
  }
}
