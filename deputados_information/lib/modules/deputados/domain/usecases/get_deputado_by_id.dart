import '../entities/deputado_details.dart';
import '../repositories/interface_deputados_repository.dart';

abstract class IGetDeputadoById {
  Future<DeputadoDetails> call(int id);
}

class GetDeputadoByIdImpl implements IGetDeputadoById {
  final IDeputadosRepository repository;

  GetDeputadoByIdImpl({required this.repository});

  @override
  Future<DeputadoDetails> call(int id) async {
    return await repository.getDeputadoById(id);
  }
}
