import 'package:deputados_information/modules/deputados/external/datasources/deputados_remote_datasource.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'deputados_remote_datasource_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late DeputadosRemoteDataSource dataSource;
  late MockDio dio;

  setUp(() {
    dio = MockDio();
    dataSource = DeputadosRemoteDataSource(dio: dio);
  });

  group('listar', () {
    test('deve retornar List<DeputadoModel> quando a resposta do dio for 200', () async {
      final responseData = {
        'dados': [
          {
            'id': 1,
            'nome': 'Deputado 1',
            'siglaPartido': 'PIF',
            'siglaUf': 'RN',
            'urlFoto': 'foto.jpg',
            'email': 'd1@camara.leg.br',
          }
        ]
      };

      when(dio.get('/deputados')).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/deputados'),
        ),
      );

      final result = await dataSource.listar();

      expect(result.length, 1);
      expect(result.first.id, 1);
      expect(result.first.nome, 'Deputado 1');
      verify(dio.get('/deputados')).called(1);
    });
  });

  group('obterPorId', () {
    test('deve retornar DeputadoDetailsModel quando a resposta do dio for 200', () async {
      final responseData = {
        'dados': {
          'nomeCivil': 'Nome Civil 1',
          'dataNascimento': '1980-01-01',
          'ultimoStatus': {
            'siglaUf': 'RN',
            'situacao': 'Exercício',
          }
        }
      };

      when(dio.get('/deputados/1')).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/deputados/1'),
        ),
      );

      final result = await dataSource.obterPorId(1);

      expect(result.nomeCivil, 'Nome Civil 1');
      expect(result.siglaUf, 'RN');
      verify(dio.get('/deputados/1')).called(1);
    });

    test('deve relançar a exceção quando a requisição do dio falhar', () async {
      when(dio.get('/deputados/1')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/deputados/1'),
          error: 'Connection error',
        ),
      );

      expect(() => dataSource.obterPorId(1), throwsA(isA<DioException>()));
    });
  });
}
