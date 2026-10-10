import 'package:deputados_information/modules/deputados/domain/entities/deputado.dart';
import 'package:deputados_information/modules/deputados/domain/entities/deputado_details.dart';
import 'package:deputados_information/modules/deputados/domain/usecases/get_deputado_by_id.dart';
import 'package:deputados_information/modules/deputados/presenter/details/deputados_details_bloc.dart';
import 'package:deputados_information/utils/deputado_details_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'deputados_details_bloc_test.mocks.dart';

@GenerateMocks([IGetDeputadoById])
void main() {
  late DeputadoDetailsBloc bloc;
  late MockIGetDeputadoById mockGetDeputadoById;

  setUp(() {
    mockGetDeputadoById = MockIGetDeputadoById();
    bloc = DeputadoDetailsBloc(obterDeputadoPorId: mockGetDeputadoById);
  });

  tearDown(() {
    bloc.dispose();
  });

  final tDeputado = Deputado(
    id: 1,
    nome: 'Deputado Teste',
    siglaPartido: 'ABC',
    siglaUf: 'SP',
    uriFoto: 'foto.jpg',
    email: 'teste@camara.leg.br',
  );

  const tDetails = DeputadoDetails(
    nomeCivil: 'Nome Civil',
    dataNascimento: '1980-01-01',
    siglaUf: 'SP',
    situacao: 'Exercício',
  );

  test('deve emitir os estados de carregando e sucesso quando os detalhes forem carregados com sucesso', () async {
    when(mockGetDeputadoById(tDeputado.id)).thenAnswer((_) async => tDetails);

    expectLater(
      bloc.state,
      emitsInOrder([
        predicate<DeputadoDetailsState>((s) => s.status == DeputadoDetailsStatus.initial),
        predicate<DeputadoDetailsState>((s) => s.status == DeputadoDetailsStatus.loading),
        predicate<DeputadoDetailsState>(
          (s) => s.status == DeputadoDetailsStatus.success && s.deputado?.deputadoDetails == tDetails,
        ),
      ]),
    );

    bloc.carregar(tDeputado);
  });

  test('deve emitir os estados de carregando e erro quando a busca dos detalhes falhar', () async {
    final exception = Exception('Error loading details');
    when(mockGetDeputadoById(tDeputado.id)).thenAnswer((_) async => throw exception);

    expectLater(
      bloc.state,
      emitsInOrder([
        predicate<DeputadoDetailsState>((s) => s.status == DeputadoDetailsStatus.initial),
        predicate<DeputadoDetailsState>((s) => s.status == DeputadoDetailsStatus.loading),
        predicate<DeputadoDetailsState>(
          (s) => s.status == DeputadoDetailsStatus.error && s.error == exception,
        ),
      ]),
    );

    bloc.carregar(tDeputado);
  });
}
