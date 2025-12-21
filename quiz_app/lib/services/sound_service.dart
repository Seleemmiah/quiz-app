import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  bool _isMuted = false;

  // Initialize sounds (preload if needed)
  Future<void> init() async {
    // Optional: Preload sounds
  }

  void toggleMute() {
    _isMuted = !_isMuted;
  }

  bool get isMuted => _isMuted;

  void setMuted(bool muted) {
    _isMuted = muted;
  }

  Future<void> playCorrectSound() async {
    if (_isMuted) return;
    try {
      // Create a new player instance for each sound
      final player = AudioPlayer();
      await player
          .setReleaseMode(ReleaseMode.release); // Auto-dispose after playing
      await player.play(AssetSource('sounds/correct.mp3'));
    } catch (e) {
      // debugPrint('Error playing correct sound: $e');
    }
  }

  Future<void> playWrongSound() async {
    if (_isMuted) return;
    try {
      // Create a new player instance for each sound
      final player = AudioPlayer();
      await player
          .setReleaseMode(ReleaseMode.release); // Auto-dispose after playing
      await player.play(AssetSource('sounds/wrong.mp3'));
    } catch (e) {
      // debugPrint('Error playing wrong sound: $e');
    }
  }

  Future<void> playFinishSound() async {
    if (_isMuted) return;
    // This method now calls playHighScoreSound to avoid code duplication.
    await playHighScoreSound();
  }

  Future<void> playHighScoreSound() async {
    if (_isMuted) return;
    try {
      final player = AudioPlayer();
      await player.setReleaseMode(ReleaseMode.release);
      await player.play(AssetSource('sounds/high_score.mp3'));
    } catch (e) {
      // debugPrint('Error playing high score sound: $e');
    }
  }

  Future<void> playLowScoreSound() async {
    if (_isMuted) return;
    try {
      final player = AudioPlayer();
      await player.setReleaseMode(ReleaseMode.release);
      // Re-enabled for Production/Real Devices.
      // WARNING: This specific file ('sounds/low_score.wav') is known to crash the Android Emulator (SIGABRT).
      // If the app crashes on the emulator, comment this line out again.
      await player.play(AssetSource('sounds/low_score.wav'));
    } catch (e) {
      // debugPrint('Error playing low score sound: $e');
    }
  }

  Future<void> playAverageScoreSound() async {
    if (_isMuted) return;
    try {
      final player = AudioPlayer();
      await player.setReleaseMode(ReleaseMode.release);
      await player.play(AssetSource('sounds/average_score.mp3'));
    } catch (e) {
      // debugPrint('Error playing average score sound: $e');
    }
  }

  // No need for dispose since we're using ReleaseMode.release
  void dispose() {
    // Players auto-dispose after playing
  }
}
