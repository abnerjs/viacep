import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:viacep/model/via_cep.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viacep/repository/back4app.dart';

class ViaCepRepository {
  final _dio = Back4App().dio;

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
    var response = await _dio.get("ViaCEP");

    return ViaCepCollection.fromJson(response.data);
  }

  Future<void> createCEP(ViaCep viaCep) async {
    try {
      await _dio.post("ViaCEP", data: viaCep.toJsonEndpoint());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCEP(ViaCep viaCep) async {
    try {
      await _dio.put("ViaCEP/${viaCep.objectId}", data: viaCep.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCEP(String objectId) async {
    try {
      await _dio.delete("ViaCEP/$objectId");
    } catch (e) {
      rethrow;
    }
  }
}
