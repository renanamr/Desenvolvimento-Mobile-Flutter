import '../entities/deputado.dart';
import '../entities/deputado_details.dart';

abstract class IDeputadosRepository {
  Future<List<Deputado>> getDeputados();
  Future<DeputadoDetails> getDeputadoById(int id);
}
