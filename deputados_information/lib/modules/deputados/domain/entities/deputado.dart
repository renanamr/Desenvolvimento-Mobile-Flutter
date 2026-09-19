import 'package:deputados_information/modules/deputados/domain/entities/deputado_details.dart';

class Deputado {
  final int id;
  final String nome;
  final String siglaPartido;
  final String siglaUf;
  final String uriFoto;
  final String email;

  DeputadoDetails? deputadoDetails;

   Deputado({
    required this.id,
    required this.nome,
    required this.siglaPartido,
    required this.siglaUf,
    required this.uriFoto,
    required this.email,
    this.deputadoDetails
  });
}