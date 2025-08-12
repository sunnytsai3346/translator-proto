import 'package:flutter/material.dart';
import 'src/audio_service.dart';
import 'src/network.dart';
import 'src/translation_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Translator Prototype',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AudioService audio = AudioService();
  final NetworkService net = NetworkService();
  final TranslationService translator = TranslationService();

  String transcript = '';
  String translation = '';

  @override
  void initState() {
    super.initState();
    net.startMonitoring();
  }

  @override
  void dispose() {
    audio.dispose();
    net.dispose();
    super.dispose();
  }

  void onRecordPressed() async {
    // record a short snippet
    final pcm = await audio.recordAndGetBytes(durationMs: 3000);
    // If online: send to backend for cloud ASR or translation
    final isOnline = await net.isOnline();
    if (isOnline) {
      // Send to backend ASR or translate
      final text = await translator.sendAudioForTranscription(pcm);
      setState(() => transcript = text);
      final translated = await translator.translateText(text, 'zh-TW');
      setState(() => translation = translated);
    } else {
      // Offline: use platform channel to on-device ASR
      final text = await translator.onDeviceTranscribe(pcm);
      setState(() => transcript = text);
      // offline translation limited — optional
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Translator Prototype')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(onPressed: onRecordPressed, child: Text('Record 3s')),
            SizedBox(height: 12),
            Text('Transcript:'),
            Text(transcript),
            SizedBox(height: 12),
            Text('Translation (zh-TW):'),
            Text(translation),
          ],
        ),
      ),
    );
  }
}