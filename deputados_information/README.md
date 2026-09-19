# App Deputados

Nesse projeto serão trabalhados três conceitos principais no desenvolvimento de aplicações Flutter:

* **RxDart:** programação reativa e gerenciamento de fluxos;
* **Dio:** comunicação HTTP e consumo de dados JSON;
* **Clean Dart:** organização do projeto em camadas e separação de responsabilidades.

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

No projeto, esse conceito pode ser aplicado ao carregamento do detalhamento de um deputado, especialmente quando novas solicitações podem ocorrer antes da conclusão da anterior.

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

## Dependências principais

* **RxDart:** programação reativa e gerenciamento de fluxos;
