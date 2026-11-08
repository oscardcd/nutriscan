import 'dart:math' as math;

import 'pose_analysis.dart';

/// Relación cintura–estatura (WHtR) estimada desde la silueta de una foto
/// frontal. Es un índice de forma: depende solo de proporciones, así que no
/// necesita estatura en centímetros ni distancia a la cámara.
///
/// Supuestos (todos aproximados, de ahí el aviso en pantalla):
/// - La cadera sirve de proxy de la cintura (`_waistToHip`).
/// - El torso es una elipse con profundidad ≈ 0,72 × ancho, así que el
///   perímetro ≈ 2,72 × ancho.
/// - La nariz está a ≈ 93 % de la estatura, así que estatura ≈ nariz-a-tobillo
///   / 0,93.
///
/// Devuelve `null` si falta algún landmark con visibilidad suficiente.
///
/// shortcut: constantes antropométricas promedio; calibrar con datos reales
/// cuando exista el modelo de F3.
double? estimateWaistToHeight(DetectedPose pose) {
  final nose = pose.landmark(BodyLandmarkType.nose);
  final leftHip = pose.landmark(BodyLandmarkType.leftHip);
  final rightHip = pose.landmark(BodyLandmarkType.rightHip);
  final leftAnkle = pose.landmark(BodyLandmarkType.leftAnkle);
  final rightAnkle = pose.landmark(BodyLandmarkType.rightAnkle);

  for (final landmark in [nose, leftHip, rightHip, leftAnkle, rightAnkle]) {
    if (landmark.visibility < _minVisibility) return null;
  }

  final hipWidth = math.sqrt(
    math.pow(leftHip.x - rightHip.x, 2) + math.pow(leftHip.y - rightHip.y, 2),
  );
  final ankleX = (leftAnkle.x + rightAnkle.x) / 2;
  final ankleY = (leftAnkle.y + rightAnkle.y) / 2;
  final noseToAnkle = math.sqrt(
    math.pow(nose.x - ankleX, 2) + math.pow(nose.y - ankleY, 2),
  );
  if (hipWidth <= 0 || noseToAnkle <= 0) return null;

  final stature = noseToAnkle / _noseToStature;
  final waist = hipWidth * _waistToHip;
  return _ellipsePerimeterFactor * waist / stature;
}

const _minVisibility = 0.5;

/// Cintura ≈ 90 % del ancho de cadera en adultos.
const _waistToHip = 0.9;

/// Perímetro de una elipse de ancho `w` y profundidad `0,72 w`.
const _ellipsePerimeterFactor = 2.72;

/// La nariz está, en promedio, a esta fracción de la estatura.
const _noseToStature = 0.93;
