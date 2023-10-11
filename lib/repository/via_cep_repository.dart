import 'dart:convert';
import 'package:viacep/model/via_cep.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ViaCepRepository {
  Future<ViaCep> getCEP(String cep) async {
    var viaCep = ViaCep();
    var response =
        await http.get(Uri.parse("https://viacep.com.br/ws/$cep/json/"));
    if (response.statusCode == 200) {
      viaCep = ViaCep.fromJson(jsonDecode(response.body));
    }

    return viaCep;
  }

  Future<ViaCepCollection> getAllCEP() async {
    await dotenv.load();
    Map<String, String> headers = {
      "X-Parse-Application-Id": dotenv.env['X-Parse-Application-Id'].toString(),
      "X-Parse-REST-API-Key": dotenv.env['X-Parse-REST-API-Key'].toString(),
      "Content-Type": "application/json",
    };
    var response = await http.get(
        Uri.parse("https://parseapi.back4app.com/classes/ViaCEP"),
        headers: headers);
    return ViaCepCollection.fromJson(jsonDecode(response.body));
  }
}
