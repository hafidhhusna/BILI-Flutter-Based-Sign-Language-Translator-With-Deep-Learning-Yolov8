import 'dart:async';
import 'dart:io' as io;

import 'package:biliandroid/Theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:ultralytics_yolo/yolo_model.dart';


class ScanController extends StatefulWidget {
  const ScanController({super.key});

  @override
  State<ScanController> createState() => _ScanControllerState();
}

class _ScanControllerState extends State<ScanController> {
  final controller = UltralyticsYoloCameraController();
  final FlutterTts _flutterTts = FlutterTts();
  StreamSubscription? _detectionSubscription;
  Set<String> _announcedLabels = {};

  @override
  void dispose() {
    _detectionSubscription?.cancel();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<bool>(
          future: _checkPermissions(),
          builder: (context, snapshot) {
            final allPermissionsGranted = snapshot.data ?? false;

            return !allPermissionsGranted
                ? Container()
                : FutureBuilder<ObjectDetector>(
                    future: _initObjectDetectorWithLocalModel(),
                    builder: (context, snapshot) {
                      final predictor = snapshot.data;

                      return predictor == null
                          ? Container()
                          : Stack(
                              children: [
                                UltralyticsYoloCameraPreview(
                                  controller: controller,
                                  predictor: predictor,
                                  onCameraCreated: () {
                                    predictor.loadModel(useGpu: true);
                                  },
                                ),
                                StreamBuilder(
                                  stream: predictor.detectionResultStream,
                                  builder: (context, snapshot) {
                                    final detectionResult = snapshot.data;

                                    if (detectionResult != null) {
                                      _handleDetection(detectionResult);
                                    }

                                    return detectionResult == null
                                        ? Container()
                                        : Stack(
                                            children: detectionResult.map((detectedObject) {
                                              final boundingBox = detectedObject!.boundingBox;

                                              return Positioned(
                                                left: boundingBox.left,
                                                top: boundingBox.top,
                                                width: boundingBox.width,
                                                height: boundingBox.height,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    border: Border.all(color: primaryColor, width: 2),
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          detectedObject.label,
                                                          style: TextStyle(color: Colors.white, fontSize: 16),
                                                        ),
                                                        Text(
                                                          (detectedObject.confidence * 100)
                                                              .toInt()
                                                              .toString(),
                                                          style: TextStyle(color: Colors.white, fontSize: 16),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          );
                                  },
                                ),
                                StreamBuilder<double?>(
                                  stream: predictor.inferenceTime,
                                  builder: (context, snapshot) {
                                    final inferenceTime = snapshot.data;

                                    return StreamBuilder<double?>(
                                      stream: predictor.fpsRate,
                                      builder: (context, snapshot) {
                                        final fpsRate = snapshot.data;

                                        return Times(
                                          inferenceTime: inferenceTime,
                                          fpsRate: fpsRate,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            );
                    },
                  );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.flip_camera_android_rounded),
          onPressed: () {
            controller.toggleLensDirection();
          },
        ),
      ),
    );
  }

  Future<void> _handleDetection(List<DetectedObject?> detectionResult) async {
    final detectedLabels = detectionResult.map((e) => e!.label).toSet();

    // Only announce new detections
    final newLabels = detectedLabels.difference(_announcedLabels);
    if (newLabels.isNotEmpty) {
      await _speakLabels(newLabels.toList());
      _announcedLabels.addAll(newLabels);
    }

    // Clear the labels after some time if needed (optional)
    await Future.delayed(Duration(seconds: 10));
    _announcedLabels.clear();
  }

  Future<void> _speakLabels(List<String> labels) async {
    await _flutterTts.setLanguage("id-ID");// Set TTS language to Bahasa Indonesia // Optionally, adjust the speech rate

    for (final label in labels) {
      await _flutterTts.speak(label);
      await Future.delayed(Duration(milliseconds: 500));
    }
  }

  Future<ObjectDetector> _initObjectDetectorWithLocalModel() async {
    final modelPath = await _copy('assets/model/BILI320_float32.tflite');
    final metadataPath = await _copy('assets/metadata/metadata.yaml');
    final model = LocalYoloModel(
      id: '',
      task: Task.detect,
      format: Format.tflite,
      modelPath: modelPath,
      metadataPath: metadataPath,
    );

    return ObjectDetector(model: model);
  }

  Future<String> _copy(String assetPath) async {
    final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';
    await io.Directory(dirname(path)).create(recursive: true);
    final file = io.File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }

  Future<bool> _checkPermissions() async {
    final cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      await Permission.camera.request();
    }
    return cameraStatus.isGranted;
  }
}

class Times extends StatelessWidget {
  const Times({
    super.key,
    required this.inferenceTime,
    required this.fpsRate,
  });

  final double? inferenceTime;
  final double? fpsRate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.black54,
            ),
            child: Text(
              '${(inferenceTime ?? 0).toStringAsFixed(1)} ms  -  ${(fpsRate ?? 0).toStringAsFixed(1)} FPS',
              style: const TextStyle(color: Colors.white70),
            )),
      ),
    );
  }
}
