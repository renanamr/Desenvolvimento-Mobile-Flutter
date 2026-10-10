# App Deputados

Nesse projeto serão trabalhados três conceitos principais no desenvolvimento de aplicações Flutter:

* **RxDart:** programação reativa e gerenciamento de fluxos;
* **Dio:** comunicação HTTP e consumo de dados JSON;
* **Clean Dart:** organização do projeto em camadas e separação de responsabilidades.
* **Flutter Modular:** injeção de dependências e gerenciamento de rotas.
* **SqFlite:** persistência de dados local e suporte offline.

O aplicativo apresenta uma lista de deputados e permite consultar os detalhes de um deputado específico a partir do seu identificador.

---

## Parte 1 - Programação reativa com RxDart

Nesta etapa, o objetivo é utilizar o RxDart para organizar os eventos e os estados da aplicação. A tela de listagem utiliza um BLoC para solicitar os dados e disponibilizá-los à interface por meio de um `Stream`.

### Itens trabalhados nessa parte do projeto:

* `Stream` e `StreamBuilder`;
* `PublishSubject` para emissão de eventos;
* `BehaviorSubject` para manutenção do estado atual;
* `ReplaySubject` para reprodução de eventos anteriores;
* Operador `switchMap` para trabalhar com operações assíncronas;
* Operador `combineLatest` para combinar fluxos;
* Operador `debounceTime` para controlar eventos de pesquisa;
* Encerramento dos Subjects no ciclo de vida do BLoC.

### Exemplo utilizado no projeto

O `BehaviorSubject` pode armazenar o estado atual da listagem. Como ele mantém o último valor emitido, a interface consegue receber o estado atual assim que começa a observar o fluxo.

```dart
final BehaviorSubject<List<Deputado>> _deputadosSubject =
    BehaviorSubject.seeded([]);

Stream<List<Deputado>> get deputados =>
    _deputadosSubject.stream;

void atualizarDeputados(List<Deputado> lista) {
  _deputadosSubject.add(lista);
}
```

A tela pode observar esse fluxo utilizando o `StreamBuilder`:

```dart
StreamBuilder<List<Deputado>>(
  stream: bloc.deputados,
  builder: (context, snapshot) {
    final deputados = snapshot.data ?? [];

    return ListView.builder(
      itemCount: deputados.length,
      itemBuilder: (context, index) {
        return DeputadoCard(
          deputado: deputados[index],
        );
      },
    );
  },
)
```

### `PublishSubject`

O `PublishSubject` é utilizado para representar eventos. Diferentemente do `BehaviorSubject`, ele não disponibiliza automaticamente o último evento para novos observadores.

Um exemplo de uso é emitir uma solicitação para carregar os deputados:

```dart
final PublishSubject<void> _carregarSubject =
    PublishSubject<void>();

Stream<void> get carregar => _carregarSubject.stream;

void solicitarCarregamento() {
  _carregarSubject.add(null);
}
```

Esse tipo de Subject é adequado para eventos pontuais, como pressionar um botão, solicitar uma atualização ou executar uma ação.

### `ReplaySubject`

O `ReplaySubject` permite reproduzir eventos anteriores para novos observadores. A quantidade de eventos armazenados pode ser limitada.

```dart
final ReplaySubject<String> _historicoPesquisas =
    ReplaySubject<String>(maxSize: 3);

void registrarPesquisa(String texto) {
  _historicoPesquisas.add(texto);
}

Stream<String> get historicoPesquisas =>
    _historicoPesquisas.stream;
```

Nesse exemplo, as três pesquisas mais recentes podem ser reproduzidas para um novo observador.

### `switchMap`

O `switchMap` troca o fluxo em processamento quando um novo evento é recebido. Ele é útil quando uma nova solicitação deve substituir a anterior.

```dart
final PublishSubject<int> _idSubject =
    PublishSubject<int>();

late final Stream<Deputado> deputadoSelecionado =
    _idSubject.switchMap(
      (id) => Stream.fromFuture(
        obterDeputadoPorId(id),
      ),
    );

void buscarDeputado(int id) {
  _idSubject.add(id);
}
```

No projeto, esse conceito pode ser applied ao carregamento do detalhamento de um deputado, especialmente quando novas solicitações podem ocorrer antes da conclusão da anterior.

### `combineLatest`

O `combineLatest` combina os valores mais recentes de dois ou mais fluxos. Um exemplo é combinar a lista de deputados com o texto de pesquisa:

```dart
final resultadoPesquisa = Rx.combineLatest2<
    List<Deputado>,
    String,
    List<Deputado>>(
  deputadosStream,
  pesquisaStream,
  (deputados, pesquisa) {
    return deputados.where((deputado) {
      return deputado.nome
          .toLowerCase()
          .contains(pesquisa.toLowerCase());
    }).toList();
  },
);
```

### `debounceTime`

O `debounceTime` aguarda um intervalo antes de emitir o último evento. Ele pode ser utilizado para evitar o processamento de cada caractere digitado:

```dart
final pesquisaControlada = pesquisaSubject
    .debounceTime(const Duration(milliseconds: 400));
```

Esse recurso é útil em campos de pesquisa, principalmente quando a operação envolve uma chamada de rede.

---

#### Verificando andamento...
Para verificar se seu projeto está igual a este, você pode usar o comando **git** abaixo:
```bash
git checkout fb60b8c
```

## Parte 2 - Comunicação HTTP com Dio

Nesta etapa, a aplicação deixa de utilizar somente dados locais e passa a consultar a API de Dados Abertos da Câmara dos Deputados utilizando o pacote `Dio`.

Serão trabalhadas requisições `GET` para obter uma lista de deputados e os dados individuais de um deputado. Também serão apresentados exemplos básicos de `POST` e `DELETE`.

### Itens trabalhados nessa parte do projeto:

* Configuração de uma instância do `Dio`;
* Definição da URL base;
* Requisições HTTP `GET`;
* Consulta de uma lista de deputados;
* Consulta de um deputado por ID;
* Leitura de dados JSON;
* Conversão de JSON para modelos Dart;
* Exemplos básicos de `POST` e `DELETE`;
* Tratamento inicial de respostas e erros.

### Configuração do Dio

A instância do `Dio` pode ser configurada com uma URL base:

```dart
final dio = Dio(
  BaseOptions(
    baseUrl: 'https://dadosabertos.camara.leg.br/api/v2',
  ),
);
```

### GET para listar deputados

A consulta da lista de deputados utiliza o endpoint `/deputados`:

```dart
Future<List<DeputadoModel>> listarDeputados() async {
  final response = await dio.get('/deputados');

  final dados = response.data['dados'] as List;

  return dados
      .map((item) => DeputadoModel.fromMap(item))
      .toList();
}
```

A resposta possui uma coleção de objetos JSON. Cada item é convertido em um `DeputadoModel`.

Uma resposta simplificada pode ser representada da seguinte forma:

```json
{
  "dados": [
    {
      "id": 123,
      "nome": "Nome do Deputado",
      "siglaPartido": "AME",
      "siglaUf": "PE"
    }
  ]
}
```

### GET para obter o detalhe de um deputado

Para consultar um deputado individual, o ID é inserido na URL:

```dart
Future<DeputadoModel> obterDeputadoPorId(int id) async {
  final response = await dio.get('/deputados/$id');

  final dados = response.data['dados'];

  return DeputadoModel.fromMap(dados);
}
```

Nesse caso, a resposta representa um único objeto JSON, e não uma lista.

Uma resposta simplificada pode ser representada assim:

```json
{
  "dados": {
    "id": 123,
    "nome": "Nome do Deputado",
    "siglaPartido": "AME",
    "siglaUf": "PE",
    "email": "deputado@camara.leg.br"
  }
}
```

A tela de detalhamento utiliza o ID recebido durante a navegação para executar essa consulta.

### Exemplo superficial de POST

O método `POST` é utilizado para enviar dados ao servidor, normalmente para criar um recurso ou executar uma operação que recebe informações no corpo da requisição.

```dart
Future<void> criarRegistro(Map<String, dynamic> dados) async {
  await dio.post(
    '/registros',
    data: dados,
  );
}
```

O exemplo é apenas ilustrativo. A API utilizada no projeto não será modificada para criar registros de deputados.

### Exemplo superficial de DELETE

O método `DELETE` é utilizado para solicitar a exclusão de um recurso identificado na URL:

```dart
Future<void> excluirRegistro(int id) async {
  await dio.delete('/registros/$id');
}
```

Assim como no exemplo de `POST`, o código tem finalidade didática para demonstrar a estrutura básica da chamada HTTP.

### Tratamento básico de erros

As chamadas podem ser protegidas com `try/catch`:

```dart
try {
  final response = await dio.get('/deputados');
  print(response.data);
} on DioException catch (erro) {
  print('Erro na requisição: ${erro.message}');
}
```

O tratamento pode ser aprimorado posteriormente para diferenciar erros de conexão, timeout, respostas inválidas e códigos HTTP.

---

## Parte 3 - Arquitetura Clean Dart

Nesta etapa, o projeto foi refatorado utilizando a proposta arquitetural do **Clean Dart**, promovendo o desacoplamento, a testabilidade e o isolamento das regras de negócio em relação às dependências externas (como bibliotecas HTTP ou frameworks de UI).

### Estrutura de Camadas

```text
lib/modules/deputados/
├── domain/
│   ├── entities/            # Objetos de domínio puro (ex: Deputado, DeputadoDetails)
│   ├── repositories/        # Contratos/interfaces dos Repositórios (ex: IDeputadosRepository)
│   └── usecases/            # Regras de negócio e suas interfaces (ex: IGetDeputados, IGetDeputadoById)
├── infra/
│   ├── datasources/         # Contratos/interfaces dos DataSources (ex: IDeputadosDataSource, IDeputadosLocalDataSource)
│   ├── models/              # Modelos que herdam das entidades e realizam parse (ex: DeputadoModel)
│   └── repositories/        # Implementação concreta dos Repositórios (ex: DeputadosRepositoryImpl)
├── external/
│   └── datasources/         # Implementação concreta dos DataSources (ex: DeputadosRemoteDataSource, DeputadosLocalDataSource)
└── presenter/
    ├── details/             # BLoC e Tela de detalhes do deputado
    ├── list/                # BLoC e Tela de listagem de deputados
    └── widget/              # Componentes visuais (ex: DeputadoCard)
```

---

### Fluxo de Dependências e Contratos

A comunicação entre cada etapa do sistema é intermediada por interfaces (contratos), seguindo o fluxo:

Presenter (BLoC) -> Usecase (Interface) -> Usecase (Real) -> Repository (Interface) -> Repository (Real) -> Datasource (Interface) -> External Datasource (Real);

#### 1. Usecase -> Repository (Domain)

O caso de uso depende da interface abstrata do repositório contida no domínio:

```dart
// domain/repositories/interface_deputados_repository.dart
abstract class IDeputadosRepository {
  Future<List<Deputado>> getDeputados();
  Future<DeputadoDetails> getDeputadoById(int id);
}

// domain/usecases/get_deputados.dart
abstract class IGetDeputados {
  Future<List<Deputado>> call();
}

class GetDeputadosImpl implements IGetDeputados {
  final IDeputadosRepository repository;

  GetDeputadosImpl({required this.repository});

  @override
  Future<List<Deputado>> call() async {
    return await repository.getDeputados();
  }
}
```

#### 2. Repository -> Datasource (Infra)

A implementação do repositório fica na camada `infra` e depende das interfaces dos `DataSources`:

```dart
// infra/datasources/interface_deputados_datasource.dart
abstract class IDeputadosDataSource {
  Future<List<DeputadoModel>> listar();
  Future<DeputadoDetailsModel> obterPorId(int id);
}

// infra/datasources/interface_deputados_local_datasource.dart
abstract class IDeputadosLocalDataSource {
  Future<List<DeputadoModel>> getDeputados();
  Future<void> saveDeputados(List<DeputadoModel> deputados);
}

// infra/repositories/deputados_repository_impl.dart
class DeputadosRepositoryImpl implements IDeputadosRepository {
  final IDeputadosDataSource remoteDataSource;
  final IDeputadosLocalDataSource localDataSource;

  DeputadosRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Deputado>> getDeputados() async {
    try {
      final deputados = await remoteDataSource.listar();
      await localDataSource.saveDeputados(deputados);
      return deputados;
    } catch (e) {
      final localDeputados = await localDataSource.getDeputados();
      if (localDeputados.isNotEmpty) {
        return localDeputados;
      }
      rethrow;
    }
  }

  @override
  Future<DeputadoDetails> getDeputadoById(int id) async {
    return await remoteDataSource.obterPorId(id);
  }
}
```

#### 3. Datasource Concreto (External)

A implementação real dos DataSources consome a API REST com `Dio` (remoto) e o banco SQLite local com `SqFlite` (local):

```dart
// external/datasources/deputados_remote_datasource.dart
class DeputadosRemoteDataSource implements IDeputadosDataSource {
  final Dio dio;

  DeputadosRemoteDataSource({Dio? dio})
      : dio = dio ?? Dio(BaseOptions(baseUrl: 'https://dadosabertos.camara.leg.br/api/v2'));

  @override
  Future<List<DeputadoModel>> listar() async {
    final response = await dio.get('/deputados');
    final dados = response.data['dados'] as List;

    return dados.map<DeputadoModel>((item) => DeputadoModel.fromMap(item)).toList();
  }

  @override
  Future<DeputadoDetailsModel> obterPorId(int id) async {
    final response = await dio.get('/deputados/$id');
    return DeputadoDetailsModel.fromMap(response.data['dados']);
  }
}
```

#### Verificando andamento...
Para verificar se seu projeto está igual a este, você pode usar o comando **git** abaixo:
```bash
git checkout 1fe97b3
```

---

## Parte 4 - Injeção de Dependência e Rotas com Flutter Modular

Nesta etapa, o pacote **Flutter Modular** foi integrado para gerenciar a injeção de dependências do projeto e o sistema de roteamento por rotas nomeadas.

### Principais Ganhos

1. **Injeção de Dependências Automática (DI):** Elimina a necessidade de instanciar dependências manualmente na interface ou na função `main`. Todas as classes da cadeia (`DataSource`, `Repository`, `UseCase`, `BLoC`) são resolvidas e injetadas automaticamente pelo contêiner de DI.
2. **Ciclo de Vida e Gerenciamento de Memória:** O uso de `i.addLazySingleton` garante que as instâncias dos serviços sejam criadas apenas quando necessárias e reutilizadas de forma eficiente.
3. **Desacoplamento de Rotas:** Substitui navegações imperativas (`Navigator.push`) por navegação nomeada declarativa (`Modular.to.pushNamed`), isolando a construção das telas e o repasse de parâmetros.
4. **Arquitetura Modularizada:** A estrutura do projeto é dividida em módulos autônomos (`AppModule` e `DeputadosModule`), permitindo escalabilidade e facilidade de manutenção.

---

### Modo de Uso no Projeto

#### 1. Módulo Principal e Configuração Global (`main.dart` e `app_module.dart`)

No `main.dart`, a aplicação é envolvida pelo `ModularApp` configurado com o `AppModule`, e o `MaterialApp.router` passa a utilizar as configurações de rotas do Modular:

```dart
// main.dart
void main() {
  runApp(
    ModularApp(
      module: AppModule(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Deputados',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: Modular.routerConfig,
    );
  }
}
```

#### 2. Registro de Injeções de Dependência e Rotas (`deputados_module.dart`)

No `DeputadosModule`, todos os contratos e suas respectivas implementações são registrados nos `binds`, do `DatabaseService` até o `BLoC`. As rotas nomeadas são definidas no método `routes`:

```dart
// modules/deputados/deputados_module.dart
class DeputadosModule extends Module {
  @override
  void binds(Injector i) {
    // Database Service
    i.addLazySingleton<DatabaseService>(DatabaseService.new);

    // DataSources
    i.addLazySingleton<IDeputadosDataSource>(DeputadosRemoteDataSource.new);
    i.addLazySingleton<IDeputadosLocalDataSource>(DeputadosLocalDataSource.new);

    // Repositories
    i.addLazySingleton<IDeputadosRepository>(
      () => DeputadosRepositoryImpl(
        remoteDataSource: i.get<IDeputadosDataSource>(),
        localDataSource: i.get<IDeputadosLocalDataSource>(),
      ),
    );

    // UseCases
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
```

#### Verificando andamento...
Para verificar se seu projeto está igual a este, você pode usar o comando **git** abaixo:
```bash
git checkout 3a47755
```

---

## Parte 5 - Armazenamento Local e Cache Offline com SqFlite

Nesta etapa, o pacote **SqFlite** foi integrado para fornecer armazenamento local SQLite e suporte a **fallback offline**.

### Objetivos e Ganhos

1. **Cache Local de Dados:** A lista de deputados retornada da API remota é persistida no banco SQLite local (`deputados_app.db`).
2. **Resiliência a Falhas (Fallback Offline):** Se houver falha de conexão com a internet, timeout ou indisponibilidade do serviço da API, o aplicativo recupera e exibe a lista salva localmente de forma transparente.
3. **Persistência Transacional:** Operações de limpeza e gravação em lote (`batch`) garantem integridade dos registros armazenados sem travar a interface do usuário.

---

### Estrutura de Implementação

#### 1. Serviço de Banco de Dados (`lib/services/database_service.dart`)

Gerencia a abertura da conexão SQLite e cria a tabela `deputados`:

```dart
class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'deputados_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE deputados (
            id INTEGER PRIMARY KEY,
            nome TEXT NOT NULL,
            siglaPartido TEXT NOT NULL,
            siglaUf TEXT NOT NULL,
            urlFoto TEXT NOT NULL,
            email TEXT NOT NULL
          )
        ''');
      },
    );
  }
}
```

#### 2. DataSource Local (`DeputadosLocalDataSource`)

Consome a instância do `DatabaseService` para salvar e consultar a lista de deputados no SQLite:

```dart
// external/datasources/deputados_local_datasource.dart
class DeputadosLocalDataSource implements IDeputadosLocalDataSource {
  final DatabaseService databaseService;

  DeputadosLocalDataSource({DatabaseService? databaseService})
      : databaseService = databaseService ?? DatabaseService();

  @override
  Future<List<DeputadoModel>> getDeputados() async {
    final db = await databaseService.database;
    final maps = await db.query('deputados');
    return maps.map((map) => DeputadoModel.fromMap(map)).toList();
  }

  @override
  Future<void> saveDeputados(List<DeputadoModel> deputados) async {
    final db = await databaseService.database;
    final batch = db.batch();

    batch.delete('deputados');

    for (final deputado in deputados) {
      batch.insert(
        'deputados',
        deputado.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }
}
```

#### 3. Estratégia de Cache no Repositório (`DeputadosRepositoryImpl`)

Orquestra a consulta e persistência dos dados:

```dart
@override
Future<List<Deputado>> getDeputados() async {
  try {
    // 1. Busca dados da API remota
    final deputados = await remoteDataSource.listar();
    // 2. Salva localmente no banco SQLite
    await localDataSource.saveDeputados(deputados);
    return deputados;
  } catch (e) {
    // 3. Em caso de erro na API/internet, recupera os deputados salvos localmente
    final localDeputados = await localDataSource.getDeputados();
    if (localDeputados.isNotEmpty) {
      return localDeputados;
    }
    rethrow;
  }
}
```

---

## Fonte dos dados

Os dados remotos são obtidos pela API de Dados Abertos da Câmara dos Deputados.

Documentação oficial:

* [API de Dados Abertos da Câmara dos Deputados](https://dadosabertos.camara.leg.br/swagger/api.html)

## Dependências principais

* **RxDart:** programação reativa e gerenciamento de fluxos;
* **Dio:** comunicação HTTP e consumo da API REST;
* **Flutter Modular:** injeção de dependências e gerenciamento de rotas;
* **SqFlite:** banco de dados SQLite local e suporte offline.
