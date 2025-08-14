import 'dart:typed_data';

class TranslationService {
  Future<String> sendAudioForTranscription(Uint8List pcm) async {
    // Placeholder for sending audio to a backend ASR
    return "cloud transcription";
  }

  Future<String> translateText(String text, String targetLanguage) async {
    // Placeholder for cloud translation
    return "cloud translation";
  }

  Future<String> onDeviceTranscribe(Uint8List pcm) async {
    // Placeholder for on-device ASR
    return "on-device transcription";
  }
}
