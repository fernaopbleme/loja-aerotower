import 'package:flutter/material.dart';

import '../theme/at_theme.dart';

enum AtButtonVariant { primary, secondary, ghost }

/// `.btn` + `.btn-primary/.btn-secondary/.btn-ghost`.
/// Fonte de título 14px, gap 6, padding 8.8 x 15.84, pílula.
class AtButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final AtButtonVariant variant;
  final Widget? leading;
  final Widget? trailing;
  final bool block;
  final double? height;

  const AtButton(
    this.label, {
    super.key,
    this.onPressed,
    this.variant = AtButtonVariant.primary,
    this.leading,
    this.trailing,
    this.block = false,
    this.height,
  });

  @override
  State<AtButton> createState() => _AtButtonState();
}

class _AtButtonState extends State<AtButton> {
  bool _hover = false;
  bool _active = false;

  Color get _fundo {
    switch (widget.variant) {
      case AtButtonVariant.primary:
        if (_active) return AtColors.accent700;
        if (_hover) return AtColors.accent600;
        return AtColors.accent;
      case AtButtonVariant.secondary:
        if (_active) return AtColors.mix(AtColors.text, 0.14);
        if (_hover) return AtColors.mix(AtColors.text, 0.07);
        return Colors.transparent;
      case AtButtonVariant.ghost:
        if (_active) return AtColors.mix(AtColors.accent, 0.18);
        if (_hover) return AtColors.mix(AtColors.accent, 0.10);
        return Colors.transparent;
    }
  }

  Color get _corTexto => switch (widget.variant) {
        AtButtonVariant.primary => AtColors.bg,
        AtButtonVariant.secondary => AtColors.text,
        AtButtonVariant.ghost => AtColors.accent700,
      };

  @override
  Widget build(BuildContext context) {
    final conteudo = Row(
      mainAxisSize: widget.block ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.leading != null) ...[widget.leading!, const SizedBox(width: 6)],
        Flexible(
          child: Text(
            widget.label,
            style: AtText.heading(14, color: _corTexto, height: 1.2),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (widget.trailing != null) ...[const SizedBox(width: 6), widget.trailing!],
      ],
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _active = true),
        onTapUp: (_) => setState(() => _active = false),
        onTapCancel: () => setState(() => _active = false),
        onTap: widget.onPressed,
        child: Container(
          height: widget.height,
          width: widget.block ? double.infinity : null,
          // `alignment` faria o Container esticar até o limite do pai;
          // só o botão block deve ocupar a largura toda.
          alignment: widget.block ? Alignment.center : null,
          padding: EdgeInsets.symmetric(
            vertical: widget.height == null ? AtSpacing.s2 : 0,
            horizontal: widget.variant == AtButtonVariant.ghost
                ? AtSpacing.s1
                : AtSpacing.s3 * 1.2,
          ),
          decoration: BoxDecoration(
            color: _fundo,
            borderRadius: BorderRadius.circular(AtRadius.pill),
            border: Border.all(
              color: widget.variant == AtButtonVariant.secondary
                  ? AtColors.divider
                  : Colors.transparent,
            ),
          ),
          child: conteudo,
        ),
      ),
    );
  }
}
