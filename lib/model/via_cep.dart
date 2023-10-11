class ViaCepCollection {
  List<ViaCep> results = [];

  ViaCepCollection(this.results);

  ViaCepCollection.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <ViaCep>[];
      json['results'].forEach((v) {
        results!.add(ViaCep.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['results'] = results!.map((v) => v.toJson()).toList();
    return data;
  }
}

class ViaCep {
  String? objectId;
  String? cep;
  String? localidade;
  String? uf;
  int? entregas;
  String? createdAt;
  String? updatedAt;
  String? logradouro;
  String? bairro;
  String? lat;
  String? lon;

  ViaCep(
      {this.objectId,
      this.cep,
      this.localidade,
      this.uf,
      this.entregas,
      this.createdAt,
      this.updatedAt,
      this.logradouro,
      this.bairro,
      this.lat,
      this.lon});

  ViaCep.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    cep = json['cep'];
    localidade = json['localidade'];
    uf = json['uf'];
    entregas = json['entregas'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    logradouro = json['logradouro'];
    bairro = json['bairro'];
    lat = json['lat'];
    lon = json['lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['cep'] = cep;
    data['localidade'] = localidade;
    data['uf'] = uf;
    data['entregas'] = entregas;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['logradouro'] = logradouro;
    data['bairro'] = bairro;
    data['lat'] = lat;
    data['lon'] = lon;
    return data;
  }
}
