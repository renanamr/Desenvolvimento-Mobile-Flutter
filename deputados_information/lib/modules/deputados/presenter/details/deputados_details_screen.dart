import 'package:deputados_information/modules/deputados/presenter/details/deputados_details_bloc.dart';
import 'package:deputados_information/utils/deputado_details_state.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/deputado.dart';


class DeputadoDetailsScreen extends StatefulWidget {
  final Deputado deputado;

  const DeputadoDetailsScreen({
    super.key,
    required this.deputado,
  });

  @override
  State<DeputadoDetailsScreen> createState() =>
      _DeputadoDetailsScreenState();
}

class _DeputadoDetailsScreenState  extends State<DeputadoDetailsScreen> {

  final DeputadoDetailsBloc bloc = DeputadoDetailsBloc();

  @override
  void initState() {
    super.initState();

    bloc.carregar(widget.deputado);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do deputado'),
      ),
      body: StreamBuilder<DeputadoDetailsState>(
        stream: bloc.state,
        builder: (context, snapshot) {
          final state = snapshot.data;

          if (state == null ||
              state.status == DeputadoDetailsStatus.initial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.status ==
              DeputadoDetailsStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.status ==
              DeputadoDetailsStatus.error) {
            return Center(
              child: Text(
                'Não foi possível carregar os dados.',
              ),
            );
          }

          final deputado = state.deputado!;

          return _DetalhesContent(
            deputado: deputado,
          );
        },
      ),
    );
  }
}

class _DetalhesContent extends StatelessWidget {
  final Deputado deputado;

  const _DetalhesContent({
    required this.deputado,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.stretch,
        children: [
          _CabecalhoDeputado(
            deputado: deputado,
          ),

          const SizedBox(height: 24),

          _InformacaoCard(
            titulo: 'Informações parlamentares',
            children: [
              _InfoItem(
                titulo: 'Partido',
                valor: deputado.siglaPartido,
              ),
              _InfoItem(
                titulo: 'UF',
                valor: deputado.siglaUf,
              ),
              _InfoItem(
                titulo: 'ID',
                valor: deputado.id.toString(),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _InformacaoCard(
            titulo: 'Contato',
            children: [
              _InfoItem(
                titulo: 'E-mail',
                valor: deputado.email,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CabecalhoDeputado extends StatelessWidget {
  final Deputado deputado;

  const _CabecalhoDeputado({
    required this.deputado,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 70,
          backgroundImage: NetworkImage(
            deputado.uriFoto,
          ),
        ),

        const SizedBox(height: 16),

        Text(
          deputado.nome,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          '${deputado.siglaPartido} • '
              '${deputado.siglaUf}',
          style: Theme.of(context)
              .textTheme
              .titleMedium,
        ),
      ],
    );
  }
}

class _InformacaoCard extends StatelessWidget {
  final String titulo;
  final List<Widget> children;

  const _InformacaoCard({
    required this.titulo,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String titulo;
  final String valor;

  const _InfoItem({
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: Theme.of(context)
                .textTheme
                .labelLarge,
          ),

          const SizedBox(height: 4),

          Text(
            valor,
            style: Theme.of(context)
                .textTheme
                .bodyLarge,
          ),
        ],
      ),
    );
  }
}