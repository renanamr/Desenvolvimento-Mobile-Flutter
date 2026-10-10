import 'package:sqflite/sqflite.dart';
import '../../../../services/database_service.dart';
import '../../infra/datasources/interface_deputados_local_datasource.dart';
import '../../infra/models/deputado_model.dart';

class DeputadosLocalDataSource implements IDeputadosLocalDataSource {
  final DatabaseService databaseService;

  DeputadosLocalDataSource({DatabaseService? databaseService})
      : databaseService = databaseService ?? DatabaseService();

  @override
  Future<List<DeputadoModel>> getDeputados() async {
    final db = await databaseService.database;
    final maps = await db.query('deputados');

    return maps.map((map) => DeputadoModel.fromMap(map)).toList();
  }

  @override
  Future<void> saveDeputados(List<DeputadoModel> deputados) async {
    final db = await databaseService.database;
    final batch = db.batch();

    batch.delete('deputados');

    for (final deputado in deputados) {
      batch.insert(
        'deputados',
        deputado.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }
}
