import 'package:deputados_information/modules/deputados/external/models/deputado_details_model.dart';
import 'package:deputados_information/modules/deputados/external/models/deputado_model.dart';
import 'package:dio/dio.dart';

class DeputadosRemoteDataSource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://dadosabertos.camara.leg.br/api/v2',
    ),
  );

  Future<List<DeputadoModel>> listar() async {
    final response = await dio.get(
      '/deputados',
    );

    final dados = response.data['dados'];

    return dados
        .map<DeputadoModel>((item) => DeputadoModel.fromMap(item),)
        .toList();
  }

  Future<DeputadoDetailsModel> obterPorId(int id) async {
    try{
      final response = await dio.get(
        '/deputados/$id',
      );

      return DeputadoDetailsModel.fromMap(
        response.data['dados'],
      );
    }catch(e){
      print(e);
      rethrow;
    }
  }
}