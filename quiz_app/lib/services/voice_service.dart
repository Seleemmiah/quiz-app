import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  static final VoiceService _instance = VoiceService._internal();
  factory VoiceService() => _instance;
  VoiceService._internal();

  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;
  bool _isSpeaking = false;
  double _speechRate = 0.5;
  double _pitch = 1.0;
  double _volume = 1.0;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _tts.setLanguage("en-US");
      await _tts.setSpeechRate(_speechRate);
      await _tts.setVolume(_volume);
      await _tts.setPitch(_pitch);

      _tts.setCompletionHandler(() {
        _isSpeaking = false;
      });

      _tts.setErrorHandler((msg) {
        print('TTS Error: $msg');
        _isSpeaking = false;
      });

      _isInitialized = true;
    } catch (e) {
      print('Error initializing TTS: $e');
    }
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) await initialize();

    try {
      _isSpeaking = true;
      await _tts.speak(text);
    } catch (e) {
      print('Error speaking: $e');
      _isSpeaking = false;
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
      _isSpeaking = false;
    } catch (e) {
      print('Error stopping TTS: $e');
    }
  }

  Future<void> pause() async {
    try {
      await _tts.pause();
    } catch (e) {
      print('Error pausing TTS: $e');
    }
  }

  bool get isSpeaking => _isSpeaking;
  bool get isInitialized => _isInitialized;

  // Settings
  Future<void> setSpeed(double speed) async {
    _speechRate = speed.clamp(0.1, 1.0);
    await _tts.setSpeechRate(_speechRate);
  }

  Future<void> setPitch(double pitch) async {
    _pitch = pitch.clamp(0.5, 2.0);
    await _tts.setPitch(_pitch);
  }

  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await _tts.setVolume(_volume);
  }

  double get speechRate => _speechRate;
  double get pitch => _pitch;
  double get volume => _volume;

  // Get available languages
  Future<List<String>> getLanguages() async {
    try {
      final languages = await _tts.getLanguages;
      return List<String>.from(languages);
    } catch (e) {
      print('Error getting languages: $e');
      return ['en-US'];
    }
  }

  // Set language
  Future<void> setLanguage(String language) async {
    try {
      await _tts.setLanguage(language);
    } catch (e) {
      print('Error setting language: $e');
    }
  }

  // Dispose
  void dispose() {
    _tts.stop();
  }
}
