import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioService {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isInitialized = false;
  String? _tempFilePath;

  AudioService() {
    _init();
  }

  Future<void> _init() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw Exception('Microphone permission not granted');
    }
    await _recorder.openRecorder();
    _isInitialized = true;
  }

  Future<Uint8List> recordAndGetBytes({int? durationMs}) async {
    if (!_isInitialized) {
      await _init();
    }

    final tempDir = await getTemporaryDirectory();
    _tempFilePath = '${tempDir.path}/flutter_sound_example.wav';

    await _recorder.startRecorder(
      toFile: _tempFilePath,
      codec: Codec.pcm16WAV,
    );

    await Future.delayed(Duration(milliseconds: durationMs ?? 3000));

    await _recorder.stopRecorder();

    if (_tempFilePath != null) {
      final file = File(_tempFilePath!);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        await file.delete();
        _tempFilePath = null;
        return bytes;
      }
    }
    return Uint8List(0);
  }

  void dispose() {
    _recorder.closeRecorder();
  }
}