import 'dart:convert';
import 'package:viacep/model/via_cep.dart';
import 'package:http/http.dart' as http;

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
}
