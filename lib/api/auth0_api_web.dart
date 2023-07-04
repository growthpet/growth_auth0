import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:growth_auth0/api/auth0_api_platform_interface.dart';
import 'package:growth_auth0/data/auth0_initial_data.dart';
import 'package:growth_auth0/exceptions/auth0_init_exception.dart';
import 'package:growth_web/growth_web.dart';

/// A web implementation of the GrowthAuth0Platform of the GrowthAuth0 plugin.
class Auth0Api extends Auth0ApiPlatformInterface {
  static const _tokensDataKey = 'tokens_data';

  final _methodChannel = WebMethodChannel();

  late final _secure = const FlutterSecureStorage();

  Auth0InitialData? _data;

  _TokensCache? _tokensCache;

  static void registerWith(_) {
    Auth0ApiPlatformInterface.instance = Auth0Api();
  }

  @override
  Future<void> initAuth(Auth0InitialData data) async {
    _data = data;
    try {
      final json = await _methodChannel.invokeMethod(
        'initAuth',
        {
          "authClientId": data.clientId,
          "authDomain": data.domain,
          "authAudience": data.audience,
          "authScope": data.scope,
        },
      );

      if (json != null) {
        final tokensDada = _jsonDecodeOrNull(json);

        await _secure.write(
          key: _tokensDataKey,
          value: json,
        );
        _tokensCache = _TokensCache(
          accessToken: tokensDada['accessToken'],
          expiresInS: tokensDada['idTokenPayload']?['exp'] ?? 0,
        );
      } else {
        final savedData = _jsonDecodeOrNull(
          await _secure.read(key: _tokensDataKey),
        );
        if (savedData != null) {
          _tokensCache = _TokensCache(
            accessToken: savedData['accessToken'],
            expiresInS: savedData['idTokenPayload']?['exp'] ?? 0,
          );
        }
      }
    } on Object catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw Auth0InitException();
    }
  }

  @override
  Future<bool> passwordLessWithEmail(String email) async {
    try {
      final result = await _methodChannel.invokeMethod(
        'passwordLessWithEmail',
        {
          "email": email,
        },
      );

      return result != null;
    } on Object catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw Auth0PasswordLessEmailException();
    }
  }

  @override
  Future<bool> passwordLessWithSMS(String phoneNumber) async {
    throw UnimplementedError('passwordLessWithSMS() has not been implemented.');
  }

  @override
  Future<bool> loginWithEmail(
    String email,
    String code,
  ) async {
    try {
      final isSuccess = await _methodChannel.invokeMethod<bool?>(
        'loginWithEmail',
        {
          "email": email,
          "code": code,
          "audience": _data?.audience,
          "scope": _data?.scope,
        },
      );

      return isSuccess ?? false;
    } on Object catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw Auth0LoginWithEmailException();
    }
  }

  @override
  Future<bool> loginWithPhoneNumber(
    String phoneNumber,
    String code,
  ) async {
    try {
      final isSuccess = await _methodChannel.invokeMethod<bool?>(
        'loginWithPhoneNumber',
        {
          "phoneNumber": phoneNumber,
          "code": code,
          "audience": _data?.audience,
          "scope": _data?.scope,
        },
      );

      return isSuccess ?? false;
    } on Object catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw Auth0LoginWithPhoneNumberException();
    }
  }

  @override
  Future<bool> checkIsLogged() async {
    try {
      return _tokensCache != null && _checkIsValidToken();
    } on Object catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw Auth0CheckIsLoggedException();
    }
  }

  @override
  Future<String> getAccessToken() async {
    try {
      if (_checkIsValidToken()) {
        return _tokensCache?.accessToken ?? '';
      }

      final json = await _methodChannel.invokeMethod('getAccessToken');

      final tokensDada = _jsonDecodeOrNull(json);

      if (json != null) {
        await _secure.write(
          key: _tokensDataKey,
          value: json,
        );
      }

      if (tokensDada != null) {
        _tokensCache = _TokensCache(
          accessToken: tokensDada['accessToken'],
          expiresInS: tokensDada['idTokenPayload']?['exp'] ?? 0,
        );
      }

      if (_tokensCache?.accessToken == null) {
        throw '';
      }

      return _tokensCache!.accessToken;
    } on Object catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw Auth0GetAccessTokenException();
    }
  }

  @override
  Future<void> clearIOSAuhCredentials() async {
    return;
  }

  @override
  Future<void> clearWebTokensData() {
    return _secure.delete(key: _tokensDataKey);
  }

  @override
  Future<void> logout() async {
    try {
      _tokensCache = null;
      await clearWebTokensData();
      await _methodChannel.invokeMethod<void>('logout');
    } on Object catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw Auth0LogoutException();
    }
  }

  bool _checkIsValidToken() {
    return DateTime.now().millisecondsSinceEpoch <
        (_tokensCache?.expiresInMs ?? 0);
  }
}

class _TokensCache {
  final String accessToken;

  final int expiresInMs;

  _TokensCache({
    required this.accessToken,
    required int expiresInS,
  }) : expiresInMs = expiresInS * 1000;
}

dynamic _jsonDecodeOrNull(
  String? source, {
  Object? reviver(Object? key, Object? value)?,
}) {
  if (source == null) {
    return null;
  }

  try {
    return jsonDecode(source, reviver: reviver);
  } on Object catch (_) {
    return null;
  }
}
