import 'package:flutter/material.dart';

import 'at_colors.dart';
import 'at_text.dart';

export 'at_colors.dart';
export 'at_shadows.dart';
export 'at_spacing.dart';
export 'at_text.dart';

class AtTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AtColors.bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AtColors.accent,
          surface: AtColors.surface,
          primary: AtColors.accent,
        ),
        textTheme: TextTheme(bodyMedium: AtText.bodyBase),
      );
}
