import 'package:deputados_information/modules/deputados/domain/entities/deputado_details.dart';
import 'package:deputados_information/modules/deputados/domain/repositories/interface_deputados_repository.dart';
import 'package:deputados_information/modules/deputados/domain/usecases/get_deputado_by_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_deputado_by_id_test.mocks.dart';

@GenerateMocks([IDeputadosRepository])
void main() {
  late GetDeputadoByIdImpl usecase;
  late MockIDeputadosRepository repository;

  setUp(() {
    repository = MockIDeputadosRepository();
    usecase = GetDeputadoByIdImpl(repository: repository);
  });

  const tId = 123;
  const tDeputadoDetails = DeputadoDetails(
    nomeCivil: 'Nome Civil Deputado',
    dataNascimento: '1975-10-20',
    siglaUf: 'MG',
    situacao: 'Exercício',
  );

  test('deve obter os detalhes do deputado por ID a partir do repositório', () async {
    when(repository.getDeputadoById(tId)).thenAnswer((_) async => tDeputadoDetails);

    final result = await usecase(tId);

    expect(result, tDeputadoDetails);
    verify(repository.getDeputadoById(tId)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
