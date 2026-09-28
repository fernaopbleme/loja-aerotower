import 'package:flutter/material.dart';

import 'at_footer.dart';
import 'at_header.dart';

/// Chrome comum a todas as telas: header fixo no topo, conteúdo rolável,
/// rodapé no fim. Cada transição de rota volta ao topo.
class AtShell extends StatefulWidget {
  final Widget child;

  const AtShell({super.key, required this.child});

  @override
  State<AtShell> createState() => _AtShellState();
}

class _AtShellState extends State<AtShell> {
  final ScrollController _scroll = ScrollController();

  @override
  void didUpdateWidget(AtShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child.runtimeType != widget.child.runtimeType &&
        _scroll.hasClients) {
      _scroll.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AtHeader(),
          Expanded(
            child: SingleChildScrollView(
              controller: _scroll,
              child: Column(
                children: [
                  widget.child,
                  const AtFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
