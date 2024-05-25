import 'dart:convert';

import 'package:http/http.dart' as http;
class NetworkHandler{
    Future get(String url) async {
    final uri = Uri.parse(url);
    var response = await http.get(
      uri,
      // headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(json.decode(response.body));
      return json.decode(response.body);
    }
    // log.i(response.body);
    // log.i(response.statusCode);
  }
}