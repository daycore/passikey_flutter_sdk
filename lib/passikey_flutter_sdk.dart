import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:passikey_flutter_sdk/model/login_result.dart';

export './model/login_result.dart';

class PassikeyFlutterSdk {
  static const MethodChannel _channel =
      const MethodChannel('passikey_flutter_sdk');

  static PassikeyFlutterSdk _instance;

  static PassikeyFlutterSdk get instance {
    if (_instance == null) _instance = new PassikeyFlutterSdk();
    return _instance;
  }

  static Future<bool> init() async {
    return _channel.invokeMethod('Passikey#init');
  }

  Future<LoginResult> login({@required String stateToken}) async {
    final result = await _channel
        .invokeMethod('Passikey#login', {'stateToken': stateToken});

    return LoginResult(
      stateToken: result['statToken'],
      partnerToken: result['ptnToken'],
    );
  }

  Future<void> startStore() async {
    _channel.invokeMethod('Passikey#startStore');
  }

  Future<bool> get isInstalledPassikey =>
      _channel.invokeMethod('Passikey#isInstalledPassikey');

  Future<String> get clientId => _channel.invokeMethod('Passikey#getClientId');

  Future<String> get clientSecret =>
      _channel.invokeMethod('Passikey#getSecretKey');
}
