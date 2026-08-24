import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PipService {
  static final PipService _instance = PipService._internal();
  factory PipService() => _instance;

  static const MethodChannel _channel = MethodChannel('com.trainerpro/pip');

  final ValueNotifier<bool> isPipModeNotifier = ValueNotifier<bool>(false);

  PipService._internal() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    if (call.method == 'onPipModeChanged') {
      final bool inPip = call.arguments as bool;
      isPipModeNotifier.value = inPip;
    }
  }

  Future<bool> enterPip() async {
    try {
      final bool success = await _channel.invokeMethod('enterPip');
      return success;
    } catch (e) {
      debugPrint('[PipService] Error entering PiP: $e');
      return false;
    }
  }

  Future<bool> isPipSupported() async {
    try {
      final bool supported = await _channel.invokeMethod('isPipSupported');
      return supported;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isPipActive() async {
    try {
      final bool active = await _channel.invokeMethod('isPipActive');
      return active;
    } catch (e) {
      return false;
    }
  }

  Future<void> setTimerActive(bool active) async {
    try {
      await _channel.invokeMethod('setTimerActive', {'active': active});
    } catch (e) {
      debugPrint('[PipService] Error setting timer active state: $e');
    }
  }
}
