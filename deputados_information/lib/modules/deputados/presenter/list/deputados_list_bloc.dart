import 'package:deputados_information/modules/deputados/domain/entities/deputado.dart';
import 'package:deputados_information/modules/deputados/domain/usecases/get_deputados.dart';
import 'package:rxdart/rxdart.dart';

class DeputadosBloc {
  final IGetDeputados listarDeputados;

  DeputadosBloc({
    required this.listarDeputados,
  }) {
    _carregarSubject
        .switchMap(
          (_) => Stream.fromFuture(
        listarDeputados(),
      ),
    )
        .listen(
      _deputadosSubject.add,
      onError: _deputadosSubject.addError,
    );
  }

  // ----------------------------------------------------------
  // EVENTO
  // ----------------------------------------------------------

  final PublishSubject<void> _carregarSubject =
  PublishSubject<void>();

  // ----------------------------------------------------------
  // ESTADO
  // ----------------------------------------------------------

  final BehaviorSubject<List<Deputado>> _deputadosSubject =
  BehaviorSubject.seeded([]);

  // ----------------------------------------------------------
  // EVENTO DE BUSCA
  // ----------------------------------------------------------

  final PublishSubject<String> _buscaSubject =
  PublishSubject<String>();

  // ----------------------------------------------------------
  // STREAMS PÚBLICAS
  // ----------------------------------------------------------

  Stream<List<Deputado>> get deputados =>
      _deputadosSubject.stream;

  Stream<String> get busca =>
      _buscaSubject.stream;

  // ----------------------------------------------------------
  // MÉTODOS PÚBLICOS
  // ----------------------------------------------------------

  void carregar() {
    _carregarSubject.add(null);
  }

  void buscar(String texto) {
    _buscaSubject.add(texto);
  }

  void dispose() {
    _carregarSubject.close();
    _deputadosSubject.close();
    _buscaSubject.close();
  }
}