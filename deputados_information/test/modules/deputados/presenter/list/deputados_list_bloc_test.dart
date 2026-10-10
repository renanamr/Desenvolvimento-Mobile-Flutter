import 'package:deputados_information/modules/deputados/domain/entities/deputado.dart';
import 'package:deputados_information/modules/deputados/domain/usecases/get_deputados.dart';
import 'package:deputados_information/modules/deputados/presenter/list/deputados_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'deputados_list_bloc_test.mocks.dart';

@GenerateMocks([IGetDeputados])
void main() {
  late DeputadosBloc bloc;
  late MockIGetDeputados mockGetDeputados;

  setUp(() {
    mockGetDeputados = MockIGetDeputados();
    bloc = DeputadosBloc(listarDeputados: mockGetDeputados);
  });

  tearDown(() {
    bloc.dispose();
  });

  final tDeputados = [
    Deputado(
      id: 1,
      nome: 'Deputado Teste',
      siglaPartido: 'ABC',
      siglaUf: 'SP',
      uriFoto: 'foto.jpg',
      email: 'teste@camara.leg.br',
    )
  ];

  test('deve emitir a lista de deputados quando carregar for chamado', () async {
    when(mockGetDeputados()).thenAnswer((_) async => tDeputados);

    expectLater(
      bloc.deputados,
      emitsInOrder([
        [], // initial seeded value
        tDeputados,
      ]),
    );

    bloc.carregar();
  });

  test('deve emitir erro quando listarDeputados falhar', () async {
    final exception = Exception('Error fetching list');
    when(mockGetDeputados()).thenAnswer((_) async => throw exception);

    expectLater(
      bloc.deputados,
      emitsInOrder([
        [],
        emitsError(isA<Exception>()),
      ]),
    );

    bloc.carregar();
  });
}
