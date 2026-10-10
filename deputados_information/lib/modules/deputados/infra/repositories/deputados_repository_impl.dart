import '../../domain/entities/deputado.dart';
import '../../domain/entities/deputado_details.dart';
import '../../domain/repositories/interface_deputados_repository.dart';
import '../datasources/interface_deputados_datasource.dart';
import '../datasources/interface_deputados_local_datasource.dart';

class DeputadosRepositoryImpl implements IDeputadosRepository {
  final IDeputadosDataSource remoteDataSource;
  final IDeputadosLocalDataSource localDataSource;

  DeputadosRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Deputado>> getDeputados() async {
    try {
      final deputados = await remoteDataSource.listar();
      await localDataSource.saveDeputados(deputados);
      return deputados;
    } catch (e) {
      final localDeputados = await localDataSource.getDeputados();
      if (localDeputados.isNotEmpty) {
        return localDeputados;
      }
      rethrow;
    }
  }

  @override
  Future<DeputadoDetails> getDeputadoById(int id) async {
    return await remoteDataSource.obterPorId(id);
  }
}
