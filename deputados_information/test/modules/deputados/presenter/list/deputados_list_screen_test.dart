import 'dart:async';
import 'dart:io';
import 'package:deputados_information/modules/deputados/domain/entities/deputado.dart';
import 'package:deputados_information/modules/deputados/presenter/list/deputados_list_bloc.dart';
import 'package:deputados_information/modules/deputados/presenter/list/deputados_list_screen.dart';
import 'package:deputados_information/modules/deputados/presenter/widget/deputado_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

import 'deputados_list_screen_test.mocks.dart';

class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return MockHttpClient();
  }
}

class MockHttpClient extends Mock implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    return MockHttpClientRequest();
  }
}

class MockHttpClientRequest extends Mock implements HttpClientRequest {
  @override
  HttpHeaders get headers => MockHttpHeaders();

  @override
  Future<HttpClientResponse> close() async {
    return MockHttpClientResponse();
  }
}

class MockHttpHeaders extends Mock implements HttpHeaders {
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
}

class MockHttpClientResponse extends Mock implements HttpClientResponse {
  static const _transparentPng = [
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
    0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
    0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
    0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
    0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
    0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82
  ];

  @override
  int get statusCode => 200;

  @override
  int get contentLength => _transparentPng.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.value(_transparentPng).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

@GenerateMocks([DeputadosBloc])
void main() {
  late MockDeputadosBloc bloc;
  late BehaviorSubject<List<Deputado>> deputadosSubject;

  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  setUp(() {
    bloc = MockDeputadosBloc();
    deputadosSubject = BehaviorSubject<List<Deputado>>.seeded([]);

    when(bloc.deputados).thenAnswer((_) => deputadosSubject.stream);
    when(bloc.carregar()).thenAnswer((_) {});
    when(bloc.dispose()).thenAnswer((_) {});
  });

  tearDown(() {
    deputadosSubject.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: DeputadosListScreen(bloc: bloc),
    );
  }

  testWidgets('deve renderizar o CircularProgressIndicator quando o estado estiver vazio', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    verify(bloc.carregar()).called(1);
  });

  testWidgets('deve renderizar a lista de DeputadoCard quando a stream de deputados emitir dados', (tester) async {
    final deputadosList = [
      Deputado(
        id: 1,
        nome: 'Deputado Teste 1',
        siglaPartido: 'PT',
        siglaUf: 'SP',
        uriFoto: 'https://example.com/foto1.jpg',
        email: 'deputado1@camara.leg.br',
      ),
    ];

    await tester.pumpWidget(createWidgetUnderTest());
    deputadosSubject.add(deputadosList);
    await tester.pump();

    expect(find.byType(DeputadoCard), findsOneWidget);
    expect(find.text('Deputado Teste 1'), findsOneWidget);
    expect(find.text('PT - SP'), findsOneWidget);
  });

  testWidgets('deve renderizar o texto de erro quando a stream de deputados emitir erro', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    deputadosSubject.addError('Erro de conexão');
    await tester.pump();

    expect(find.text('Erro: Erro de conexão'), findsOneWidget);
  });
}
