import 'package:flutter_modular/flutter_modular.dart';

import 'domain/repositories/interface_deputados_repository.dart';
import 'domain/usecases/get_deputado_by_id.dart';
import 'domain/usecases/get_deputados.dart';
import 'external/datasources/deputados_remote_datasource.dart';
import 'infra/datasources/interface_deputados_datasource.dart';
import 'infra/repositories/deputados_repository_impl.dart';
import 'presenter/details/deputados_details_bloc.dart';
import 'presenter/details/deputados_details_screen.dart';
import 'presenter/list/deputados_list_bloc.dart';
import 'presenter/list/deputados_list_screen.dart';

class DeputadosModule extends Module {
  @override
  void binds(Injector i) {
    // Datasources
    i.addLazySingleton<IDeputadosDataSource>(DeputadosRemoteDataSource.new);

    // Repositories
    i.addLazySingleton<IDeputadosRepository>(DeputadosRepositoryImpl.new);

    // Usecases
    i.add<IGetDeputados>(GetDeputadosImpl.new);
    i.add<IGetDeputadoById>(GetDeputadoByIdImpl.new);

    // BLoCs
    i.add<DeputadosBloc>(DeputadosBloc.new);
    i.add<DeputadoDetailsBloc>(DeputadoDetailsBloc.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      '/',
      child: (context) => DeputadosListScreen(
        bloc: Modular.get<DeputadosBloc>(),
      ),
    );
    r.child(
      '/details',
      child: (context) => DeputadoDetailsScreen(
        deputado: r.args.data,
        bloc: Modular.get<DeputadoDetailsBloc>(),
      ),
    );
  }
}
