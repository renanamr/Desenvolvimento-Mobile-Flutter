import 'package:deputados_information/modules/deputados/domain/entities/deputado.dart';
import 'package:deputados_information/modules/deputados/external/datasources/deputados_remote_datasource.dart';

abstract class IGetDeputados{
  Future<List<Deputado>> call();
}

class GetDeputadosImpl implements IGetDeputados {

  final dataSource = DeputadosRemoteDataSource();

  @override
  Future<List<Deputado>> call() async {
    return await dataSource.listar();
  }
}