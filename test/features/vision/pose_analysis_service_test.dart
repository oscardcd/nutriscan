import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:nutriscan/features/vision/data/pose_image_preprocessor.dart';
import 'package:nutriscan/features/vision/data/pose_analysis_service.dart';
import 'package:nutriscan/features/vision/domain/pose_alignment.dart';
import 'package:nutriscan/features/vision/domain/pose_analysis.dart';
import 'package:nutriscan/features/vision/domain/pose_detection_engine.dart';

class _FakePoseDetectionEngine implements PoseDetectionEngine {
  List<DetectedPerson> people = [_person()];
  Completer<List<DetectedPerson>>? detectionCompleter;
  int initializeCount = 0;
  int disposeCount = 0;
  int detectCount = 0;
  Uint8List? receivedJpeg;

  @override
  Future<void> initialize() async {
    initializeCount++;
  }

  @override
  Future<List<DetectedPerson>> detect(Uint8List normalizedJpeg) {
    detectCount++;
    receivedJpeg = normalizedJpeg;
    final completer = detectionCompleter;
    if (completer != null && !completer.isCompleted) {
      return completer.future;
    }
    return Future.value(people);
  }

  @override
  Future<void> dispose() async {
    disposeCount++;
  }
}

DetectedPerson _person({
  double score = 0.9,
  double ankleVisibility = 0.9,
  double shoulderX = 0.35,
  double hipShift = 0,
}) => DetectedPerson(
  score: score,
  landmarks: [
    const NormalizedLandmark(
      type: BodyLandmarkType.nose,
      x: 0.5,
      y: 0.1,
      visibility: 0.9,
    ),
    NormalizedLandmark(
      type: BodyLandmarkType.leftShoulder,
      x: shoulderX,
      y: 0.25,
      visibility: 0.9,
    ),
    NormalizedLandmark(
      type: BodyLandmarkType.rightShoulder,
      x: 0.65,
      y: 0.25,
      visibility: 0.9,
    ),
    NormalizedLandmark(
      type: BodyLandmarkType.leftHip,
      x: 0.4 + hipShift,
      y: 0.5,
      visibility: 0.9,
    ),
    NormalizedLandmark(
      type: BodyLandmarkType.rightHip,
      x: 0.6 + hipShift,
      y: 0.5,
      visibility: 0.9,
    ),
    NormalizedLandmark(
      type: BodyLandmarkType.leftAnkle,
      x: 0.42,
      y: 0.9,
      visibility: ankleVisibility,
    ),
    NormalizedLandmark(
      type: BodyLandmarkType.rightAnkle,
      x: 0.58,
      y: 0.9,
      visibility: ankleVisibility,
    ),
  ],
);

final _imageBytes = Uint8List.fromList(
  img.encodePng(img.Image(width: 8, height: 12)),
);

void main() {
  group('PoseAnalysisService', () {
    test('evalúa la foto con los mismos checks que la guía en vivo', () async {
      final engine = _FakePoseDetectionEngine();
      final service = PoseAnalysisService(engine: engine);
      await service.initialize();

      expect((await service.analyze(_imageBytes)).alignment, AlignmentHint.ok);

      engine.people = [_person(hipShift: 0.2)];
      final offCenter = await service.analyze(_imageBytes);
      expect(offCenter.quality, PoseQuality.usableForTechnicalChecks);
      expect(offCenter.alignment, AlignmentHint.notCentered);

      engine.people = [];
      final empty = await service.analyze(_imageBytes);
      expect(empty.quality, PoseQuality.noPersonDetected);
      expect(empty.alignment, isNull);

      await service.dispose();
    });

    test('normaliza PNG a JPEG fuera del hilo UI y devuelve pose', () async {
      final engine = _FakePoseDetectionEngine();
      final service = PoseAnalysisService(engine: engine);
      await service.initialize();

      final result = await service.analyze(_imageBytes);

      expect(result.quality, PoseQuality.usableForTechnicalChecks);
      expect(result.pose?.landmarks, hasLength(7));
      expect(result.imageWidth, 8);
      expect(result.imageHeight, 12);
      expect(result.processingTime, greaterThanOrEqualTo(Duration.zero));
      expect(engine.receivedJpeg, isNotNull);
      expect(img.decodeImage(engine.receivedJpeg!), isNotNull);
      expect(
        img.findDecoderForData(engine.receivedJpeg!),
        isA<img.JpegDecoder>(),
      );
      await service.dispose();
      expect(engine.initializeCount, 1);
      expect(engine.disposeCount, 1);
    });

    test('requiere inicialización', () async {
      final service = PoseAnalysisService(engine: _FakePoseDetectionEngine());

      await expectLater(
        service.analyze(_imageBytes),
        throwsA(
          isA<VisionException>().having(
            (error) => error.failure,
            'failure',
            VisionFailure.detectorNotInitialized,
          ),
        ),
      );
    });

    test('rechaza imágenes inválidas y mayores al límite', () async {
      final service = PoseAnalysisService(engine: _FakePoseDetectionEngine());
      await service.initialize();

      await expectLater(
        service.analyze(Uint8List.fromList([1, 2, 3])),
        throwsA(
          isA<VisionException>().having(
            (error) => error.failure,
            'failure',
            VisionFailure.invalidImage,
          ),
        ),
      );
      await expectLater(
        service.analyze(
          Uint8List.fromList([137, 80, 78, 71, 13, 10, 26, 10, 0]),
        ),
        throwsA(
          isA<VisionException>().having(
            (error) => error.failure,
            'failure',
            VisionFailure.invalidImage,
          ),
        ),
      );
      await expectLater(
        service.analyze(Uint8List(maxPoseImageBytes + 1)),
        throwsA(
          isA<VisionException>().having(
            (error) => error.failure,
            'failure',
            VisionFailure.imageTooLarge,
          ),
        ),
      );
      final hugePng = img.encodePng(img.Image(width: 4000, height: 3200));
      await expectLater(
        service.analyze(Uint8List.fromList(hugePng)),
        throwsA(
          isA<VisionException>().having(
            (error) => error.failure,
            'failure',
            VisionFailure.imageTooLarge,
          ),
        ),
      );
      await service.dispose();
    });

    test('informa los estados de calidad sin inventar una pose', () async {
      final engine = _FakePoseDetectionEngine();
      final service = PoseAnalysisService(engine: engine);
      await service.initialize();

      engine.people = [];
      expect(
        (await service.analyze(_imageBytes)).quality,
        PoseQuality.noPersonDetected,
      );

      engine.people = [_person(), _person()];
      final multiple = await service.analyze(_imageBytes);
      expect(multiple.quality, PoseQuality.multiplePeopleDetected);
      expect(multiple.pose, isNull);

      engine.people = [_person(score: 0.2)];
      expect(
        (await service.analyze(_imageBytes)).quality,
        PoseQuality.lowPoseConfidence,
      );

      engine.people = [_person(ankleVisibility: 0.2)];
      expect(
        (await service.analyze(_imageBytes)).quality,
        PoseQuality.incompleteBody,
      );

      engine.people = [_person(shoulderX: 1.02)];
      final borderline = await service.analyze(_imageBytes);
      expect(borderline.quality, PoseQuality.incompleteBody);
      expect(borderline.pose, isNotNull);
      await service.dispose();
    });

    test('rechaza landmarks fuera de rango', () async {
      final engine = _FakePoseDetectionEngine()
        ..people = [_person(shoulderX: 1.2)];
      final service = PoseAnalysisService(engine: engine);
      await service.initialize();

      await expectLater(
        service.analyze(_imageBytes),
        throwsA(
          isA<VisionException>().having(
            (error) => error.failure,
            'failure',
            VisionFailure.invalidDetectorOutput,
          ),
        ),
      );
      await service.dispose();
    });

    test('aplica timeout y no inicia una inferencia concurrente', () async {
      final engine = _FakePoseDetectionEngine()
        ..detectionCompleter = Completer<List<DetectedPerson>>();
      final service = PoseAnalysisService(
        engine: engine,
        timeout: const Duration(milliseconds: 500),
      );
      await service.initialize();

      await expectLater(
        service.analyze(_imageBytes),
        throwsA(
          isA<VisionException>().having(
            (error) => error.failure,
            'failure',
            VisionFailure.timedOut,
          ),
        ),
      );
      await expectLater(
        service.analyze(_imageBytes),
        throwsA(
          isA<VisionException>().having(
            (error) => error.failure,
            'failure',
            VisionFailure.analysisInProgress,
          ),
        ),
      );

      engine.detectionCompleter?.complete([_person()]);
      await Future<void>.delayed(Duration.zero);
      expect(
        (await service.analyze(_imageBytes)).quality,
        PoseQuality.usableForTechnicalChecks,
      );
      await service.dispose();
    });
  });
}
