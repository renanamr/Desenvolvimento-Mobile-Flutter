// ignore_for_file: void_checks

import 'package:deputados_information/modules/deputados/external/datasources/deputados_local_datasource.dart';
import 'package:deputados_information/modules/deputados/infra/models/deputado_model.dart';
import 'package:deputados_information/services/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

import 'deputados_local_datasource_test.mocks.dart';

@GenerateMocks([DatabaseService, Database, Batch])
void main() {
  late DeputadosLocalDataSource dataSource;
  late MockDatabaseService databaseService;
  late MockDatabase database;
  late MockBatch batch;

  setUp(() {
    databaseService = MockDatabaseService();
    database = MockDatabase();
    batch = MockBatch();

    when(databaseService.database).thenAnswer((_) async => database);
    dataSource = DeputadosLocalDataSource(databaseService: databaseService);
  });

  group('getDeputados', () {
    test('deve retornar List<DeputadoModel> a partir da consulta ao banco de dados', () async {
      final dbQueryResult = [
        {
          'id': 1,
          'nome': 'Local Deputado',
          'siglaPartido': 'XYZ',
          'siglaUf': 'SP',
          'urlFoto': 'foto.jpg',
          'email': 'local@camara.leg.br',
        }
      ];

      when(database.query('deputados')).thenAnswer((_) async => dbQueryResult);

      final result = await dataSource.getDeputados();

      expect(result.length, 1);
      expect(result.first.nome, 'Local Deputado');
      verify(database.query('deputados')).called(1);
    });
  });

  group('saveDeputados', () {
    test('deve realizar a inserção em lote (batch) no banco de dados', () async {
      final tDeputados = [
        DeputadoModel(
          id: 1,
          nome: 'Deputado 1',
          siglaPartido: 'PT',
          siglaUf: 'SP',
          uriFoto: 'foto.jpg',
          email: 'd1@camara.leg.br',
        )
      ];

      when(database.batch()).thenReturn(batch);
      when(batch.delete('deputados')).thenReturn(0);
      when(batch.insert(
        'deputados',
        any,
        conflictAlgorithm: ConflictAlgorithm.replace,
      )).thenReturn(1);
      when(batch.commit(noResult: true)).thenAnswer((_) async => []);

      await dataSource.saveDeputados(tDeputados);

      verify(database.batch()).called(1);
      verify(batch.delete('deputados')).called(1);
      verify(batch.insert(
        'deputados',
        tDeputados.first.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      )).called(1);
      verify(batch.commit(noResult: true)).called(1);
    });
  });
}
