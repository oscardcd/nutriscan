import 'package:flutter/material.dart';

import '../../../../data/local/body_metrics.dart';
import '../../../../i18n/strings.g.dart';

/// Diálogo con peso y estatura. Es un widget con estado para que los
/// controladores vivan lo mismo que el diálogo y no se liberen mientras la
/// ruta todavía se está animando.
class BodyMetricsDialog extends StatefulWidget {
  const BodyMetricsDialog({super.key, required this.t, this.initial});

  final Translations t;
  final BodyMetrics? initial;

  @override
  State<BodyMetricsDialog> createState() => BodyMetricsDialogState();
}

class BodyMetricsDialogState extends State<BodyMetricsDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _height = TextEditingController(
    text: widget.initial == null
        ? ''
        : widget.initial!.heightCm.toStringAsFixed(0),
  );
  late final _weight = TextEditingController(
    text: widget.initial == null
        ? ''
        : widget.initial!.weightKg.toStringAsFixed(0),
  );

  @override
  void dispose() {
    _height.dispose();
    _weight.dispose();
    super.dispose();
  }

  String? _validate(String? raw, double min, double max, String message) {
    final value = double.tryParse((raw ?? '').replaceAll(',', '.'));
    if (value == null || value < min || value > max) return message;
    return null;
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    Navigator.of(context).pop((
      metrics: BodyMetrics(
        heightCm: double.parse(_height.text.replaceAll(',', '.')),
        weightKg: double.parse(_weight.text.replaceAll(',', '.')),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    return AlertDialog(
      title: Text(t.capture.bodyDataTitle),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _height,
              autofocus: widget.initial == null,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(labelText: t.capture.bodyHeight),
              validator: (value) =>
                  _validate(value, 80, 250, t.capture.bodyHeightError),
            ),
            TextFormField(
              controller: _weight,
              autofocus: widget.initial != null,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(labelText: t.capture.bodyWeight),
              validator: (value) =>
                  _validate(value, 20, 400, t.capture.bodyWeightError),
            ),
          ],
        ),
      ),
      actions: [
        // Sin peso ni estatura el WHtR de la foto sigue siendo válido.
        TextButton(
          onPressed: () => Navigator.of(context).pop((metrics: null)),
          child: Text(t.capture.bodySkip),
        ),
        FilledButton(onPressed: _submit, child: Text(t.capture.bodyContinue)),
      ],
    );
  }
}
