import 'package:deputados_information/modules/deputados/domain/entities/deputado_details.dart';
import 'package:deputados_information/modules/deputados/external/datasources/deputados_remote_datasource.dart';

abstract class IGetDeputadoBy{
  Future<DeputadoDetails> call(int id);
}

class GetDeputadoByIdImpl implements IGetDeputadoBy{

  final dataSource = DeputadosRemoteDataSource();

  @override
  Future<DeputadoDetails> call(int id) async {
    return await dataSource.obterPorId(id);
  }
}