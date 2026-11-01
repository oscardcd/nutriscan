import 'package:flutter/material.dart';

import '../../../features/classify/domain/bmi_band.dart';
import '../../../i18n/strings.g.dart';
import '../app_colors.dart';

/// Colores por banda de diagnóstico (DESIGN.md §Diagnostic & Metric Classification).
extension BmiBandColor on BmiBand {
  Color get color => switch (this) {
    BmiBand.underweight => AppColors.bandUnderweight,
    BmiBand.normal => AppColors.bandNormal,
    BmiBand.overweight => AppColors.bandOverweight,
    BmiBand.obese => AppColors.bandObese,
  };

  Color get textColor => switch (this) {
    BmiBand.underweight => AppColors.bandUnderweightText,
    BmiBand.normal => AppColors.bandNormalText,
    BmiBand.overweight => AppColors.bandOverweightText,
    BmiBand.obese => AppColors.bandObeseText,
  };
}

String bandLabel(BmiBand band, Translations t) => switch (band) {
  BmiBand.underweight => t.band.underweight,
  BmiBand.normal => t.band.normal,
  BmiBand.overweight => t.band.overweight,
  BmiBand.obese => t.band.obese,
};

/// Chip pill de banda: fondo del color al 12–14% de opacidad.
class BmiBandChip extends StatelessWidget {
  const BmiBandChip({super.key, required this.band});

  final BmiBand band;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: band.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        bandLabel(band, Translations.of(context)),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: dark ? Color.lerp(band.color, Colors.white, 0.45) : band.textColor,
        ),
      ),
    );
  }
}
