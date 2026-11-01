import 'package:flutter/material.dart';

import '../app_colors.dart';

/// Barra segmentada de 4 bandas con marcador en el IMC estimado (DESIGN.md §Components).
class BmiRangeGauge extends StatelessWidget {
  const BmiRangeGauge({super.key, required this.bmi});

  final double bmi;

  // Escala fija 15–40 de IMC; los tramos respetan los cortes OMS.
  static const _min = 15.0;
  static const _max = 40.0;

  @override
  Widget build(BuildContext context) {
    final clamped = bmi.clamp(_min, _max);
    final position = (clamped - _min) / (_max - _min);

    return LayoutBuilder(
      builder: (context, constraints) {
        const markerSize = 16.0;
        final travel = constraints.maxWidth - markerSize;
        return SizedBox(
          height: markerSize + 8,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  height: 8,
                  child: Row(
                    children: const [
                      Expanded(
                        flex: 35,
                        child: ColoredBox(color: AppColors.bandUnderweight),
                      ),
                      Expanded(
                        flex: 65,
                        child: ColoredBox(color: AppColors.bandNormal),
                      ),
                      Expanded(
                        flex: 50,
                        child: ColoredBox(color: AppColors.bandOverweight),
                      ),
                      Expanded(
                        flex: 100,
                        child: ColoredBox(color: AppColors.bandObese),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: travel * position,
                child: Container(
                  width: markerSize,
                  height: markerSize,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
