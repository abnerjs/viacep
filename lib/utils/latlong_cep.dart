import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:viacep/model/coordinate.dart';

Future<Coordinate> latlongCEP(String cep) async {
  String url =
      'https://nominatim.openstreetmap.org/search?format=json&postalcode=$cep&country=Brasil';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);

    if (data.isNotEmpty) {
      double lat = double.parse(data[0]['lat']);
      double lon = double.parse(data[0]['lon']);

      return Coordinate(lat, lon);
    }
  }

  return Coordinate(-23.55077425, -46.63386827); // São Paulo, Sé (placeholder)
}
