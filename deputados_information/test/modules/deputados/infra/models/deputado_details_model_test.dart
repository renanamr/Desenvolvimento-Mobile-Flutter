import 'package:deputados_information/modules/deputados/infra/models/deputado_details_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DeputadoDetailsModel', () {
    test('deve retornar um DeputadoDetailsModel válido a partir do Map', () {
      final mapSample = {
        'nomeCivil': 'João da Silva Santos',
        'dataNascimento': '1980-05-15',
        'ultimoStatus': {
          'siglaUf': 'SP',
          'situacao': 'Exercício',
        },
      };

      final model = DeputadoDetailsModel.fromMap(mapSample);

      expect(model.nomeCivil, 'João da Silva Santos');
      expect(model.dataNascimento, '1980-05-15');
      expect(model.siglaUf, 'SP');
      expect(model.situacao, 'Exercício');
    });
  });
}
