import 'package:flutter/material.dart';

import '../../core/theme/at_theme.dart';

class AtFooter extends StatelessWidget {
  const AtFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AtColors.divider)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 26, 24, 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AtSpacing.maxWidth),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 18,
            runSpacing: 18,
            children: [
              Text(
                'AeroTower · Hidroponia modular · valores e imagens provisórios',
                style: AtText.body(13, color: AtColors.neutral700),
              ),
              Wrap(
                spacing: 18,
                children: const [
                  _LinkRodape('Suporte'),
                  _LinkRodape('Trocas'),
                  _LinkRodape('Privacidade'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinkRodape extends StatefulWidget {
  final String label;
  const _LinkRodape(this.label);

  @override
  State<_LinkRodape> createState() => _LinkRodapeState();
}

class _LinkRodapeState extends State<_LinkRodape> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Text(
        widget.label,
        style: AtText.body(
          13,
          color: _hover ? AtColors.accent : AtColors.accent700,
        ),
      ),
    );
  }
}
