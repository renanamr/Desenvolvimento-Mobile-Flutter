import 'package:deputados_information/modules/deputados/domain/entities/deputado_details.dart';

class DeputadoDetailsModel extends DeputadoDetails{
  const DeputadoDetailsModel({
    required super.nomeCivil,
    required super.dataNascimento,
    required super.siglaUf,
    required super.situacao,
  });

  factory DeputadoDetailsModel.fromMap(Map<String, dynamic> map) {
    return DeputadoDetailsModel(
      siglaUf: map['ultimoStatus']['siglaUf'] as String,
      nomeCivil: map['nomeCivil'] as String,
      dataNascimento: map['dataNascimento'] as String,
      situacao: map['ultimoStatus']['situacao'] as String,
    );
  }
}