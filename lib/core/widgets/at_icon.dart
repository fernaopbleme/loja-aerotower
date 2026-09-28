import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Glifos Lucide (stroke-width 2.75) copiados do protótipo.
/// Um pacote de ícones-fonte fixaria o traço em 2.0, então os paths
/// vêm inline para bater com o design.
class AtIcons {
  static const droplet =
      'M12 22a7 7 0 0 0 7-7c0-2-1-3.9-3-5.5s-3.5-4-4-6.5c-.5 2.5-2 4.9-4 6.5C6 11.1 5 13 5 15a7 7 0 0 0 7 7z';

  static const search = 'M11 11m-8 0a8 8 0 1 0 16 0a8 8 0 1 0 -16 0 M21 21l-4.3-4.3';

  static const cart =
      'M8 21m-1 0a1 1 0 1 0 2 0a1 1 0 1 0 -2 0 M19 21m-1 0a1 1 0 1 0 2 0a1 1 0 1 0 -2 0 '
      'M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12';

  static const truck =
      'M10 17h4V5H2v12h3 M20 17h2v-3.34a4 4 0 0 0-1.17-2.83L19 9h-5v8h1 '
      'M7.5 17.5m-2.5 0a2.5 2.5 0 1 0 5 0a2.5 2.5 0 1 0 -5 0 '
      'M17.5 17.5m-2.5 0a2.5 2.5 0 1 0 5 0a2.5 2.5 0 1 0 -5 0';

  static const play =
      'M6 4.6v14.8a1 1 0 0 0 1.5.87l12-7.4a1 1 0 0 0 0-1.74l-12-7.4A1 1 0 0 0 6 4.6z';

  static const check = 'M20 6 9 17l-5-5';

  static const login =
      'M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4 M10 17l5-5-5-5 M15 12H3';

  static const image =
      'M3 3m0 2a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z '
      'M8.5 8.5m-1.5 0a1.5 1.5 0 1 0 3 0a1.5 1.5 0 1 0 -3 0 M21 15l-5-5L5 21';
}

class AtIcon extends StatelessWidget {
  final String path;
  final double size;
  final Color color;

  const AtIcon(this.path, {super.key, this.size = 20, required this.color});

  @override
  Widget build(BuildContext context) {
    final hex =
        '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
    return SvgPicture.string(
      '<svg xmlns="http://www.w3.org/2000/svg" width="$size" height="$size" '
      'viewBox="0 0 24 24" fill="none" stroke="$hex" stroke-width="2.75" '
      'stroke-linecap="round" stroke-linejoin="round">'
      '<path d="$path"/></svg>',
      width: size,
      height: size,
    );
  }
}
