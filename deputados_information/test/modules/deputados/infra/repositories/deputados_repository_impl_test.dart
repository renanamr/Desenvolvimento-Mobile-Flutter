import 'package:deputados_information/modules/deputados/infra/datasources/interface_deputados_datasource.dart';
import 'package:deputados_information/modules/deputados/infra/datasources/interface_deputados_local_datasource.dart';
import 'package:deputados_information/modules/deputados/infra/models/deputado_details_model.dart';
import 'package:deputados_information/modules/deputados/infra/models/deputado_model.dart';
import 'package:deputados_information/modules/deputados/infra/repositories/deputados_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'deputados_repository_impl_test.mocks.dart';

@GenerateMocks([IDeputadosDataSource, IDeputadosLocalDataSource])
void main() {
  late DeputadosRepositoryImpl repository;
  late MockIDeputadosDataSource remoteDataSource;
  late MockIDeputadosLocalDataSource localDataSource;

  setUp(() {
    remoteDataSource = MockIDeputadosDataSource();
    localDataSource = MockIDeputadosLocalDataSource();
    repository = DeputadosRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
  });

  final tDeputadosModelList = [
    DeputadoModel(
      id: 1,
      nome: 'Deputado Test',
      siglaPartido: 'XYZ',
      siglaUf: 'SP',
      uriFoto: 'foto.jpg',
      email: 'test@camara.leg.br',
    ),
  ];

  group('getDeputados', () {
    test('deve retornar os deputados remotos e salvá-los no banco local quando a busca remota for bem-sucedida', () async {
      when(remoteDataSource.listar()).thenAnswer((_) async => tDeputadosModelList);
      when(localDataSource.saveDeputados(tDeputadosModelList)).thenAnswer((_) async {});

      final result = await repository.getDeputados();

      expect(result, tDeputadosModelList);
      verify(remoteDataSource.listar()).called(1);
      verify(localDataSource.saveDeputados(tDeputadosModelList)).called(1);
    });

    test('deve retornar os deputados locais quando a busca remota falhar e existirem dados locais', () async {
      when(remoteDataSource.listar()).thenThrow(Exception('No connection'));
      when(localDataSource.getDeputados()).thenAnswer((_) async => tDeputadosModelList);

      final result = await repository.getDeputados();

      expect(result, tDeputadosModelList);
      verify(remoteDataSource.listar()).called(1);
      verify(localDataSource.getDeputados()).called(1);
    });

    test('deve relançar a exceção quando a busca remota falhar e o banco local estiver vazio', () async {
      final exception = Exception('Server error');
      when(remoteDataSource.listar()).thenThrow(exception);
      when(localDataSource.getDeputados()).thenAnswer((_) async => []);

      expect(() => repository.getDeputados(), throwsA(exception));
      verify(remoteDataSource.listar()).called(1);
      verify(localDataSource.getDeputados()).called(1);
    });
  });

  group('getDeputadoById', () {
    const tId = 123;
    const tDetails = DeputadoDetailsModel(
      nomeCivil: 'Nome Civil',
      dataNascimento: '1985-01-01',
      siglaUf: 'SP',
      situacao: 'Exercício',
    );

    test('deve retornar os detalhes do deputado a partir do datasource remoto', () async {
      when(remoteDataSource.obterPorId(tId)).thenAnswer((_) async => tDetails);

      final result = await repository.getDeputadoById(tId);

      expect(result, tDetails);
      verify(remoteDataSource.obterPorId(tId)).called(1);
    });
  });
}
