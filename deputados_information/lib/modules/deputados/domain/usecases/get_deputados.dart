import 'package:deputados_information/modules/deputados/domain/entities/deputado.dart';

abstract class IGetDeputados{
  Future<List<Deputado>> call();
}

class GetDeputadosImpl implements IGetDeputados {
  @override
  Future<List<Deputado>> call() async {
    await Future.delayed(
      const Duration(milliseconds: 2300),
    );

    return [
      Deputado(
        id: 1,
        nome: 'Marcapasso Palmarense',
        siglaPartido: 'PPL',
        siglaUf: 'PE',
        uriFoto:
        'https://www.camara.leg.br/internet/deputado/bandep/220714.jpg',
        email: 'marcapasso@camara.leg.br',
      ),
      Deputado(
        id: 2,
        nome: 'Adriana da Biblioteca',
        siglaPartido: 'PBIB',
        siglaUf: 'PE',
        uriFoto:
        'https://www.camara.leg.br/internet/deputado/bandep/74848.jpg',
        email: 'adriana@camara.leg.br',
      ),
      Deputado(
        id: 3,
        nome: 'Sr. Lunga',
        siglaPartido: 'PSBD',
        siglaUf: 'PE',
        uriFoto:
        'https://www.camara.leg.br/internet/deputado/bandep/204560.jpg',
        email: 'lunga@camara.leg.br',
      ),
      Deputado(
        id: 4,
        nome: 'Ronaldinho Gaúcho',
        siglaPartido: 'PD',
        siglaUf: 'RS',
        uriFoto:
        'https://www.camara.leg.br/internet/deputado/bandep/160976.jpg',
        email: 'bruxo@camara.leg.br',
      ),
    ];
  }
}