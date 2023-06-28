import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:growth_auth0/data/auth0_initial_data.dart';
import 'package:growth_auth0/exceptions/auth0_init_exception.dart';

class Auth0Universal {
  Auth0? _auth0;
  Auth0InitialData? _data;

  @override
  Future<void> initAuth(Auth0InitialData data) async {
    _data = data;
    try {
      _auth0 = Auth0(data.domain, data.clientId);
    } on Object catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw Auth0InitException();
    }
  }

  Future<void> login() async {
    if (_data == null) {
      return;
    }

    final credentials = await _auth0?.webAuthentication(scheme: 'https').login(
      audience: _data!.audience,
      scopes: {_data!.scope},
      // redirectUrl: 'http://auth.mvp.growth.pet/android/pet.growth/callback'
      // redirectUrl: 'https://dev.growth.pet/android/pet.growth/callback'
    );
// Access token -> credentials.accessToken
// User profile -> credentials.user
  }
}
