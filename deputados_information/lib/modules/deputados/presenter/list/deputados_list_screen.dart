import 'package:deputados_information/modules/deputados/domain/entities/deputado.dart';
import 'package:deputados_information/modules/deputados/presenter/details/deputados_details_screen.dart';
import 'package:deputados_information/modules/deputados/presenter/list/deputados_list_bloc.dart';
import 'package:deputados_information/modules/deputados/presenter/widget/deputado_card.dart';
import 'package:flutter/material.dart';

class DeputadosListScreen extends StatefulWidget {
  final DeputadosBloc bloc;

  const DeputadosListScreen({
    super.key,
    required this.bloc,
  });

  @override
  State<DeputadosListScreen> createState() => _DeputadosListScreenState();
}

class _DeputadosListScreenState extends State<DeputadosListScreen> {
  @override
  void initState() {
    super.initState();

    widget.bloc.carregar();
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deputados'),
      ),
      body: StreamBuilder<List<Deputado>>(
        stream: widget.bloc.deputados,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro: ${snapshot.error}',),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final deputados = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: deputados.length,
            itemBuilder: (context, index) {
              return DeputadoCard(
                deputado: deputados[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DeputadoDetailsScreen(
                        deputado: deputados[index],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}