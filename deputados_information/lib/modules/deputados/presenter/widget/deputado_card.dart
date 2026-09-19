import 'package:flutter/material.dart';

import '../../domain/entities/deputado.dart';

class DeputadoCard extends StatelessWidget {
  final Deputado deputado;
  final VoidCallback? onTap;

  const DeputadoCard({
    super.key,
    required this.deputado,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundImage: NetworkImage(
                  deputado.uriFoto,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      deputado.nome,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      '${deputado.siglaPartido} - '
                          '${deputado.siglaUf}',
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right,
              ),
            ],
          ),
        ),
      ),
    );
  }
}