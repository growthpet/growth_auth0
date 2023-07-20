import 'package:flutter/foundation.dart';
import 'package:growth_auth0/data/auth0_initial_data.dart';
import 'package:growth_auth0/data/user_info.dart';
import 'package:growth_auth0/exceptions/auth0_init_exception.dart';
import 'package:growth_web/growth_web.dart';

class Auth0Spa {
  final WebMethodChannel _methodChannel;

  Auth0Spa(this._methodChannel);

  Future<void> initAuth(Auth0InitialData data) async {
    try {} on Object catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw Auth0InitException();
    }
  }

  Future<bool> loginWithUniversal() {
    /// TODO реализовать
    return Future.value(false);
  }

  Future<bool> checkIsLogged() {
    /// TODO реализовать
    return Future.value(true);
  }

  Future<String> getAccessToken() {
    /// TODO реализовать
    return Future.value('');
  }

  Future<UserInfo> getUserInfo(String accessToken) {
    /// TODO реализовать
    return Future.value(UserInfo());
  }

  Future<void> logout() {
    /// TODO реализовать
    return Future.value(null);
  }

  Future<void> logoutWithUniversal() {
    /// TODO реализовать
    return Future.value(null);
  }
}
