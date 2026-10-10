import 'package:dio/dio.dart';
import '../../infra/datasources/interface_deputados_datasource.dart';
import '../../infra/models/deputado_details_model.dart';
import '../../infra/models/deputado_model.dart';

class DeputadosRemoteDataSource implements IDeputadosDataSource {
  final Dio dio;

  DeputadosRemoteDataSource({Dio? dio})
      : dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://dadosabertos.camara.leg.br/api/v2',
              ),
            );

  @override
  Future<List<DeputadoModel>> listar() async {
    final response = await dio.get(
      '/deputados',
    );

    final dados = response.data['dados'] as List;

    return dados
        .map<DeputadoModel>(
          (item) => DeputadoModel.fromMap(item),
        )
        .toList();
  }

  @override
  Future<DeputadoDetailsModel> obterPorId(int id) async {
    try {
      final response = await dio.get(
        '/deputados/$id',
      );

      return DeputadoDetailsModel.fromMap(
        response.data['dados'],
      );
    } catch (e) {
      rethrow;
    }
  }
}
