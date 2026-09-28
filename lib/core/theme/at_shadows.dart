import 'package:flutter/material.dart';

import 'at_colors.dart';

/// `--shadow-sm/md/lg` — nada além destas três.
class AtShadows {
  static final sm = [
    BoxShadow(
      color: AtColors.mix(AtColors.neutral900, 0.14),
      offset: const Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  static final md = [
    BoxShadow(
      color: AtColors.mix(AtColors.neutral900, 0.16),
      offset: const Offset(0, 3),
      blurRadius: 10,
    ),
  ];

  static final lg = [
    BoxShadow(
      color: AtColors.mix(AtColors.neutral900, 0.22),
      offset: const Offset(0, 12),
      blurRadius: 32,
    ),
  ];
}
