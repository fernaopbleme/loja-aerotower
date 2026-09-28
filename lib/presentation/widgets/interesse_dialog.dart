import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../content/produtos.dart';
import '../../core/theme/at_theme.dart';
import '../../core/widgets/at_button.dart';
import '../../core/widgets/at_icon.dart';
import '../../core/widgets/at_radio.dart';
import '../../data/services/analytics_service.dart';

/// Formulário curto de validação: e-mail + qual produto interessou.
///
/// Um e-mail é um sinal de demanda bem mais forte que um clique, e saber
/// qual produto atraiu cada pessoa é o que responde "o produto é querido?".
class InteresseDialog extends StatefulWidget {
  /// Produto pré-selecionado, quando o botão sai de uma página de produto.
  final String? produtoInicial;

  const InteresseDialog({super.key, this.produtoInicial});

  static Future<void> abrir(BuildContext context, {String? produtoInicial}) {
    return showDialog<void>(
      context: context,
      builder: (_) => InteresseDialog(produtoInicial: produtoInicial),
    );
  }

  @override
  State<InteresseDialog> createState() => _InteresseDialogState();
}

class _InteresseDialogState extends State<InteresseDialog> {
  final _email = TextEditingController();
  late String _produto = widget.produtoInicial ?? produtos.first.nome;

  bool _enviando = false;
  bool _enviado = false;
  String? _erro;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    setState(() {
      _enviando = true;
      _erro = null;
    });

    try {
      await context.read<AnalyticsService>().registrarInteresse(
            email: _email.text.trim(),
            produto: _produto,
          );
      if (mounted) setState(() => _enviado = true);
    } on InteresseInvalido catch (e) {
      if (mounted) setState(() => _erro = e.mensagem);
    } catch (_) {
      if (mounted) {
        setState(() => _erro = 'Sem conexão com o servidor. Tente de novo.');
      }
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AtColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AtRadius.card),
      ),
      // Rolável porque o conteúdo cresce: a caixa de erro aparece, e em
      // tela baixa o formulário não cabe inteiro.
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(26),
            child: _enviado ? _sucesso() : _formulario(),
          ),
        ),
      ),
    );
  }

  Widget _formulario() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Me interesso pelo produto', style: AtText.heading(25)),
        const SizedBox(height: 8),
        Text(
          'Deixe seu e-mail e diga qual torre te interessou. Avisamos assim '
          'que o lançamento sair — sem spam.',
          style: AtText.body(14, color: AtColors.neutral800),
        ),
        const SizedBox(height: 18),

        Text('SEU E-MAIL', style: AtText.h6(color: AtColors.neutral700)),
        const SizedBox(height: 6),
        TextField(
          controller: _email,
          enabled: !_enviando,
          keyboardType: TextInputType.emailAddress,
          autofocus: true,
          style: AtText.body(14),
          onSubmitted: (_) => _enviando ? null : _enviar(),
          decoration: InputDecoration(
            hintText: 'seu@email.com',
            hintStyle: AtText.body(14, color: AtColors.mix(AtColors.text, 0.45)),
            filled: true,
            fillColor: AtColors.bg,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AtRadius.pill),
              borderSide: const BorderSide(color: AtColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AtRadius.pill),
              borderSide: const BorderSide(color: AtColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AtRadius.pill),
              borderSide: const BorderSide(color: AtColors.accent),
            ),
          ),
        ),

        const SizedBox(height: 18),
        Text('QUAL PRODUTO?', style: AtText.h6(color: AtColors.neutral700)),
        const SizedBox(height: 8),
        for (final produto in produtos)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: AtRadio(
              label: produto.nome,
              selecionado: _produto == produto.nome,
              onTap: _enviando
                  ? () {}
                  : () => setState(() => _produto = produto.nome),
            ),
          ),

        if (_erro != null) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AtColors.accent100,
              borderRadius: BorderRadius.circular(AtRadius.md),
            ),
            child: Text(
              _erro!,
              style: AtText.body(13, color: AtColors.accent800),
            ),
          ),
        ],

        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: AtButton(
                _enviando ? 'Enviando...' : 'Quero ser avisado',
                block: true,
                height: 44,
                onPressed: _enviando ? null : _enviar,
              ),
            ),
            const SizedBox(width: 10),
            AtButton(
              'Agora não',
              variant: AtButtonVariant.secondary,
              onPressed:
                  _enviando ? null : () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _sucesso() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: AtColors.accent2_200,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: AtIcon(AtIcons.check, size: 30, color: AtColors.accent2_800),
          ),
        ),
        const SizedBox(height: 16),
        Text('Anotado!', style: AtText.h3, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(
          'Obrigado. Assim que o $_produto sair do papel, você é avisado.',
          style: AtText.body(14, color: AtColors.neutral800),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        AtButton(
          'Fechar',
          block: true,
          height: 44,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
