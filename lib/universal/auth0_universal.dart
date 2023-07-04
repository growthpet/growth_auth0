import 'package:flutter/foundation.dart';
import 'package:growth_auth0/data/auth0_initial_data.dart';
import 'package:growth_auth0/exceptions/auth0_init_exception.dart';
import 'package:growth_auth0/universal/auth0_universal_logged_data.dart';

import 'client/client.dart';

class Auth0Universal {
  Auth0Client? _auth0;

  Future<void> initAuth(Auth0InitialData data) async {
    try {
      _auth0 = Auth0Client(data);
    } on Object catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw Auth0InitException();
    }
  }

  Future<Auth0UniversalLoggedData?> login() async {
    try {
      return await _auth0?.login();
    } on Object catch (_) {
      return null;
    }
  }

  Future<bool> checkIsLogged() async {
    return (await _auth0?.checkIsLogged()) ?? false;
  }

  Future<bool> logout() async {
    return (await _auth0?.logout()) ?? false;
  }

  Future<String?> getAccessToken() async {
    return _auth0?.getAccessToken();
  }

  Future<bool> clearCredentials() async {
    return (await _auth0?.clearCredentials()) ?? true;
  }
}
