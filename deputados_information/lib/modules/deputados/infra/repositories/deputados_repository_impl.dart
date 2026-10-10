import '../../domain/entities/deputado.dart';
import '../../domain/entities/deputado_details.dart';
import '../../domain/repositories/interface_deputados_repository.dart';
import '../datasources/interface_deputados_datasource.dart';

class DeputadosRepositoryImpl implements IDeputadosRepository {
  final IDeputadosDataSource dataSource;

  DeputadosRepositoryImpl({required this.dataSource});

  @override
  Future<List<Deputado>> getDeputados() async {
    return await dataSource.listar();
  }

  @override
  Future<DeputadoDetails> getDeputadoById(int id) async {
    return await dataSource.obterPorId(id);
  }
}
