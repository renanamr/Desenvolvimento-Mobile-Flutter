import 'package:deputados_information/modules/deputados/domain/entities/deputado.dart';
import 'package:deputados_information/modules/deputados/domain/usecases/get_deputado_by_id.dart';
import 'package:deputados_information/utils/deputado_details_state.dart';
import 'package:rxdart/rxdart.dart';

class DeputadoDetailsBloc {
  final GetDeputadoByIdImpl obterDeputadoPorId = GetDeputadoByIdImpl();

  final _stateSubject = BehaviorSubject.seeded(
    DeputadoDetailsState.initial(),
  );

  Stream<DeputadoDetailsState> get state => _stateSubject.stream;

  void carregar(Deputado deputado) {
    _stateSubject.add(
      _stateSubject.value.copyWith(
        status: DeputadoDetailsStatus.loading,
      ),
    );

    obterDeputadoPorId(deputado.id).then((deputadoDetails) {
      deputado.deputadoDetails = deputadoDetails;
        _stateSubject.add(
          DeputadoDetailsState(
            status: DeputadoDetailsStatus.success,
            deputado: deputado,
          ),
        );
      },
    ).catchError((error) {
        _stateSubject.add(
          DeputadoDetailsState(
            status: DeputadoDetailsStatus.error,
            error: error,
          ),
        );
      },
    );
  }

  void dispose() {
    _stateSubject.close();
  }
}