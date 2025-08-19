import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioService {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isInitialized = false;
  String? _tempFilePath;

  Future<void> _init() async {
    if (!kIsWeb) {
      final status = await Permission.microphone.request();
      print(status);
      if (status != PermissionStatus.granted) {
        throw Exception('Microphone permission not granted');
      }
    }
    await _recorder.openRecorder();
    _isInitialized = true;
  }

  Future<Uint8List> recordAndGetBytes({int? durationMs}) async {
    if (!_isInitialized) {
      await _init();
    }

    if (kIsWeb) {
      await _recorder.startRecorder(
        codec: Codec.opusWebM,
      );

      await Future.delayed(Duration(milliseconds: durationMs ?? 3000));

      final url = await _recorder.stopRecorder();

      if (url != null) {
        final response = await http.get(Uri.parse(url));
        return response.bodyBytes;
      }
      return Uint8List(0);
    } else {
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
  }

  void dispose() {
    _recorder.closeRecorder();
  }
}
