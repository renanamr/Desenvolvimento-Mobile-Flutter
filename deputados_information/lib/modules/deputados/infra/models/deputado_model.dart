import '../../domain/entities/deputado.dart';

class DeputadoModel extends Deputado {
  DeputadoModel({
    required super.id,
    required super.nome,
    required super.siglaPartido,
    required super.siglaUf,
    required super.uriFoto,
    required super.email,
    super.deputadoDetails,
  });

  factory DeputadoModel.fromMap(Map<String, dynamic> map) {
    return DeputadoModel(
      id: map['id'] as int,
      nome: map['nome'] as String,
      siglaPartido: map['siglaPartido'] as String,
      siglaUf: map['siglaUf'] as String,
      uriFoto: map['urlFoto'] as String,
      email: map['email'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'siglaPartido': siglaPartido,
      'siglaUf': siglaUf,
      'urlFoto': uriFoto,
      'email': email,
    };
  }
}
