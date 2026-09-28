import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/rotas.dart';
import '../../core/theme/at_theme.dart';
import '../../core/widgets/at_button.dart';
import '../../core/widgets/at_tag.dart';

/// Rota já registrada, tela ainda não construída.
/// Some conforme cada rota entra.
class EmBrevePage extends StatelessWidget {
  final String titulo;

  const EmBrevePage({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 64, 24, 96),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AtTag('Em construção', variant: AtTagVariant.neutral),
              const SizedBox(height: 14),
              Text(titulo, style: AtText.h2, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Text(
                'Esta tela ainda não foi construída. A rota já existe e o '
                'endereço funciona.',
                style: AtText.body(15, color: AtColors.neutral700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              AtButton(
                'Voltar ao início',
                variant: AtButtonVariant.secondary,
                onPressed: () => context.go(Rotas.inicio),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
