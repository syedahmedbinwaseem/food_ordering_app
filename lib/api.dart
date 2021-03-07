import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class APIService {
  // API key
  static const _api_key = "e63160b266mshc9a1836caafc115p161dcejsne0ea239b5147";
  // Base API url
  static const String _baseUrl = "calorieninjas.p.rapidapi.com";
  // Base headers for Response url
  static const Map<String, String> _headers = {
    "content-type": "application/json",
    "x-rapidapi-host": "calorieninjas.p.rapidapi.com",
    "x-rapidapi-key": _api_key,
  };

  // Base API request to get response
  Future<dynamic> get({
    @required String endpoint,
    @required Map<String, String> query,
  }) async {
    Uri uri = Uri.https(_baseUrl, endpoint, query);
    final response = await http.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      print(json.decode(response.body)['items'][0]['sugar_g']);

      return json.decode(response.body);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load json data');
    }
  }
}
