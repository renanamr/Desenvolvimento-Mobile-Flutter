import 'package:deputados_information/modules/deputados/infra/models/deputado_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DeputadoModel', () {
    final mapSample = {
      'id': 101,
      'nome': 'João Silva',
      'siglaPartido': 'XYZ',
      'siglaUf': 'SP',
      'urlFoto': 'https://example.com/foto.jpg',
      'email': 'joao@camara.leg.br',
    };

    test('deve retornar um DeputadoModel válido a partir do Map com urlFoto', () {
      final model = DeputadoModel.fromMap(mapSample);

      expect(model.id, 101);
      expect(model.nome, 'João Silva');
      expect(model.siglaPartido, 'XYZ');
      expect(model.siglaUf, 'SP');
      expect(model.uriFoto, 'https://example.com/foto.jpg');
      expect(model.email, 'joao@camara.leg.br');
    });

    test('deve retornar um DeputadoModel válido a partir do Map utilizando o fallback uriFoto', () {
      final mapWithUri = {
        'id': 102,
        'nome': 'Maria Souza',
        'siglaPartido': 'ABC',
        'siglaUf': 'RJ',
        'uriFoto': 'https://example.com/foto2.jpg',
        'email': 'maria@camara.leg.br',
      };

      final model = DeputadoModel.fromMap(mapWithUri);

      expect(model.id, 102);
      expect(model.uriFoto, 'https://example.com/foto2.jpg');
    });

    test('deve retornar um Map contendo os dados corretos a partir do DeputadoModel', () {
      final model = DeputadoModel(
        id: 101,
        nome: 'João Silva',
        siglaPartido: 'XYZ',
        siglaUf: 'SP',
        uriFoto: 'https://example.com/foto.jpg',
        email: 'joao@camara.leg.br',
      );

      final result = model.toMap();

      expect(result, {
        'id': 101,
        'nome': 'João Silva',
        'siglaPartido': 'XYZ',
        'siglaUf': 'SP',
        'urlFoto': 'https://example.com/foto.jpg',
        'email': 'joao@camara.leg.br',
      });
    });
  });
}
