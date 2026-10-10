import '../models/deputado_model.dart';

abstract class IDeputadosLocalDataSource {
  Future<List<DeputadoModel>> getDeputados();
  Future<void> saveDeputados(List<DeputadoModel> deputados);
}
