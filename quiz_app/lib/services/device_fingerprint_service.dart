import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

/// Service for generating unique device fingerprints
/// Used to prevent students from taking exams on multiple devices simultaneously
class DeviceFingerprintService {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Generate a unique, hashed fingerprint for the current device
  static Future<String> getDeviceFingerprint() async {
    String identifier = '';

    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        identifier =
            '${androidInfo.id}_${androidInfo.model}_${androidInfo.device}_${androidInfo.brand}';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        identifier =
            '${iosInfo.identifierForVendor}_${iosInfo.model}_${iosInfo.systemVersion}';
      } else {
        // Web or other platforms
        identifier = 'web_${DateTime.now().millisecondsSinceEpoch}';
      }

      // Hash the identifier for privacy and security
      final bytes = utf8.encode(identifier);
      final digest = sha256.convert(bytes);

      return digest.toString();
    } catch (e) {
      // Fallback to timestamp-based identifier
      return sha256
          .convert(
              utf8.encode('fallback_${DateTime.now().millisecondsSinceEpoch}'))
          .toString();
    }
  }

  /// Get device information for logging/debugging
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return {
          'platform': 'Android',
          'model': androidInfo.model,
          'brand': androidInfo.brand,
          'version': androidInfo.version.release,
        };
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return {
          'platform': 'iOS',
          'model': iosInfo.model,
          'name': iosInfo.name,
          'version': iosInfo.systemVersion,
        };
      }
    } catch (e) {
      return {'platform': 'Unknown', 'error': e.toString()};
    }

    return {'platform': 'Web'};
  }
}
