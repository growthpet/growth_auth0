import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:growth_auth0/data/auth0_initial_data.dart';
import 'package:growth_auth0/exceptions/auth0_init_exception.dart';
import 'package:growth_auth0/universal/auth0_universal_logged_data.dart';

class Auth0Client {
  late final Auth0 _auth0;

  final Auth0InitialData _data;

  Future<Credentials> get _credentials => _credentialsManager.credentials();

  CredentialsManager get _credentialsManager => _auth0.credentialsManager;

  Auth0Client(
    this._data,
  ) {
    _auth0 = Auth0(_data.domain, _data.clientId);
  }

  Future<Auth0UniversalLoggedData?> login() async {
    try {
      final credentials =
          await _auth0.webAuthentication(scheme: _data.scheme).login(
                audience: _data.audience,
                scopes: {_data.scope},
                useEphemeralSession: true,
                safariViewController: const SafariViewController(
                  presentationStyle:
                      SafariViewControllerPresentationStyle.fullScreen,
                ),
                parameters: {"prompt": "login"},
              );

      _credentialsManager.storeCredentials(credentials);


      return Auth0UniversalLoggedData(
        accessToken: credentials.accessToken,
        email: credentials.user.email,
      );
    } on Object catch (_) {
      return null;
    }
  }

  Future<String> getAccessToken() async {
    try {
      final accessToken = (await _credentials).accessToken;

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

  Future<bool> checkIsLogged() async {
    try {
      return await _credentialsManager.hasValidCredentials();
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

  Future<bool> clearCredentials() async {
    try {
      return await _credentialsManager.clearCredentials();
    } on Object catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw Auth0ClearCredentialsException();
    }
  }

  Future<bool> logout() async {
    try {
      await _auth0.webAuthentication(scheme: _data.scheme).logout();
      return true;
    } on Object catch (_) {
      return false;
    }
  }
}
