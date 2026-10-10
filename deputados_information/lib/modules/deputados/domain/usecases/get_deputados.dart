import '../entities/deputado.dart';
import '../repositories/interface_deputados_repository.dart';

abstract class IGetDeputados {
  Future<List<Deputado>> call();
}

class GetDeputadosImpl implements IGetDeputados {
  final IDeputadosRepository repository;

  GetDeputadosImpl({required this.repository});

  @override
  Future<List<Deputado>> call() async {
    return await repository.getDeputados();
  }
}
