import 'package:deputados_information/modules/deputados/domain/entities/deputado.dart';
import 'package:deputados_information/modules/deputados/domain/repositories/interface_deputados_repository.dart';
import 'package:deputados_information/modules/deputados/domain/usecases/get_deputados.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_deputados_test.mocks.dart';

@GenerateMocks([IDeputadosRepository])
void main() {
  late GetDeputadosImpl usecase;
  late MockIDeputadosRepository repository;

  setUp(() {
    repository = MockIDeputadosRepository();
    usecase = GetDeputadosImpl(repository: repository);
  });

  final tDeputados = [
    Deputado(
      id: 1,
      nome: 'Deputado 1',
      siglaPartido: 'PT',
      siglaUf: 'SP',
      uriFoto: 'foto.jpg',
      email: 'd1@camara.leg.br',
    ),
  ];

  test('deve obter a lista de deputados a partir do repositório', () async {
    when(repository.getDeputados()).thenAnswer((_) async => tDeputados);

    final result = await usecase();

    expect(result, tDeputados);
    verify(repository.getDeputados()).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('deve retornar erro quando houver uma Exception no repositório', () async {
    when(repository.getDeputados()).thenThrow(Exception());

    expect(() => usecase(), throwsA(isA<Exception>()));
  });
}
