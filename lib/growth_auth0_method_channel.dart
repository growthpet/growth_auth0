import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:growth_auth0/data/auth0_initial_data.dart';
import 'package:growth_auth0/exceptions/auth0_init_exception.dart';
import 'growth_auth0_platform_interface.dart';

/// An implementation of [GrowthAuth0Platform] that uses method channels.
class MethodChannelGrowthAuth0 extends GrowthAuth0Platform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('growth_auth0');

  late final Auth0InitialData _data;

  @override
  Future<void> initAuth(Auth0InitialData data) async {
    _data = data;

    try {
      await methodChannel.invokeMethod<bool?>(
        'initAuth',
        {
          "authClientId": _data.clientId,
          "authDomain": _data.domain,
        },
      );
    } on Object catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw Auth0InitException();
    }
  }

  @override
  Future<bool> passwordLessWithEmail(String email) async {
    try {
      final result = await methodChannel.invokeMethod<bool?>(
        'passwordLessWithEmail',
        {
          "email": email,
        },
      );

      return result ?? false;
    } on Object catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw Auth0PasswordLessEmailException();
    }
  }

  @override
  Future<bool> passwordLessWithSMS(String phoneNumber) async {
    try {
      final result = await methodChannel.invokeMethod<bool?>(
        'passwordLessWithSMS',
        {
          "phoneNumber": phoneNumber,
        },
      );

      return result ?? false;
    } on Object catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw Auth0PasswordLessEmailException();
    }
  }

  @override
  Future<bool> loginWithEmail(
    String email,
    String code,
  ) async {
    try {
      final isSuccess = await methodChannel.invokeMethod<bool?>(
        'loginWithEmail',
        {
          "email": email,
          "code": code,
          "audience": _data.audience,
          "scope": _data.scope,
        },
      );

      return isSuccess ?? false;
    } on PlatformException catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw Auth0LoginWithEmailException(e.message);
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
      final isSuccess = await methodChannel.invokeMethod<bool?>(
        'loginWithPhoneNumber',
        {
          "phoneNumber": phoneNumber,
          "code": code,
          "audience": _data.audience,
          "scope": _data.scope,
        },
      );

      return isSuccess ?? false;
    } on PlatformException catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw Auth0LoginWithPhoneNumberException(e.message);
    } on Object catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw Auth0LoginWithPhoneNumberException();
    }
  }

  @override
  Future<bool> checkIsLogged() async {
    try {
      final isExistToken =
          await methodChannel.invokeMethod<bool?>('checkIsLogged');
      return isExistToken ?? false;
    } on PlatformException catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw Auth0CheckIsLoggedException(e.message);
    } on Object catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw Auth0CheckIsLoggedException();
    }
  }

  @override
  Future<String> getAccessToken() async {
    try {
      final accessToken =
          await methodChannel.invokeMethod<String?>('getAccessToken');
      if (accessToken == null) {
        throw '';
      }

      return accessToken;
    } on PlatformException catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw Auth0GetAccessTokenException(e.message);
    } on Object catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw Auth0GetAccessTokenException();
    }
  }

  @override
  Future<void> clearIOSAuhCredentials() async {
    if (!Platform.isIOS) {
      return;
    }

    return methodChannel.invokeMethod<void>('clearCredentials');
  }

  @override
  Future<void> clearWebTokensData() async {
    return;
  }

  @override
  Future<void> logout() {
    return methodChannel.invokeMethod<void>('logout');
  }
}
