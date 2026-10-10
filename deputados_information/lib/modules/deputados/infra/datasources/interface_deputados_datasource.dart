import '../models/deputado_details_model.dart';
import '../models/deputado_model.dart';

abstract class IDeputadosDataSource {
  Future<List<DeputadoModel>> listar();
  Future<DeputadoDetailsModel> obterPorId(int id);
}
