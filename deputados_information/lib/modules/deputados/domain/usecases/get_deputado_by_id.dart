import 'package:deputados_information/modules/deputados/domain/entities/deputado_details.dart';

abstract class IGetDeputadoBy{
  Future<DeputadoDetails> call(int id);
}

class GetDeputadoByIdImpl implements IGetDeputadoBy{

  @override
  Future<DeputadoDetails> call(int id) async {
    return DeputadoDetails(
        nomeCivil: "Renatinho da Silva",
        dataNascimento: "12/10/1980",
        siglaUf: "PE",
        situacao: "ATIVO"
    );
  }
}