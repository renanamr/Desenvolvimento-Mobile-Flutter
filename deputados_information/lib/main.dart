import 'package:deputados_information/modules/deputados/domain/usecases/get_deputados.dart';
import 'package:deputados_information/modules/deputados/external/datasources/deputados_remote_datasource.dart';
import 'package:deputados_information/modules/deputados/infra/repositories/deputados_repository_impl.dart';
import 'package:deputados_information/modules/deputados/presenter/list/deputados_list_bloc.dart';
import 'package:deputados_information/modules/deputados/presenter/list/deputados_list_screen.dart';
import 'package:flutter/material.dart';

void main() {
  final dataSource = DeputadosRemoteDataSource();
  final repository = DeputadosRepositoryImpl(dataSource: dataSource);
  final usecase = GetDeputadosImpl(repository: repository);

  final bloc = DeputadosBloc(
    listarDeputados: usecase,
  );

  runApp(
    MyApp(bloc: bloc),
  );
}

class MyApp extends StatelessWidget {
  final DeputadosBloc bloc;

  const MyApp({
    super.key,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Deputados',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: DeputadosListScreen(
        bloc: bloc,
      ),
    );
  }
}
