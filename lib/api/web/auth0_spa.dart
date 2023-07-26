import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:growth_auth0/data/auth0_initial_data.dart';
import 'package:growth_auth0/data/user_info.dart';
import 'package:growth_auth0/exceptions/auth0_init_exception.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';

class Auth0Spa {
  Auth0InitialData? _data;

  Auth0Web? _auth;

  Future<Credentials?> get _credentials =>
      _auth?.credentials(
        audience: _data?.audience,
        scopes: _data?.scopes,
      ) ??
      Future.value(null);

  Future<void> initAuth(Auth0InitialData data) async {
    _data = data;
    try {
      _auth = Auth0Web(data.domain, data.clientId);
      await _auth!.onLoad(
        audience: data.audience,
        scopes: data.scopes,
        useRefreshTokens: true,
        cacheLocation: CacheLocation.localStorage,
      );
    } on Object catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw Auth0InitException();
    }
  }

  Future<bool> login() async {
    try {
      await _auth?.loginWithRedirect(
        audience: _data?.audience,
        scopes: _data?.scopes,
        redirectUrl: _data?.redirectUri,
      );
      return true;
    } on Object catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw Auth0LoginException();
    }
  }

  Future<bool> checkIsLogged() async {
    return (await _auth?.hasValidCredentials()) ?? false;
  }

  Future<String> getAccessToken() async {
    try {
      return (await _credentials)?.accessToken ?? '';
    } on Object catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw Auth0GetAccessTokenException();
    }
  }

  Future<UserInfo> getUserInfo(String accessToken) async {
    try {
      final user = (await _credentials)?.user;

      return user == null
          ? UserInfo()
          : UserInfo(
              email: user.email,
              isEmailVerified: user.isEmailVerified,
            );
    } on Object catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
    }

    return UserInfo();
  }

  Future<void> logout() async {
    try {
      await _auth?.logout(
        returnToUrl: _data?.redirectUri,
      );
    } on Object catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw Auth0LogoutException();
    }
  }
}
