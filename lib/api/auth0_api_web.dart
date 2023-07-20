import 'package:growth_auth0/api/auth0_api_platform_interface.dart';
import 'package:growth_auth0/api/web/auth0_client.dart';
import 'package:growth_auth0/api/web/auth0_spa.dart';
import 'package:growth_auth0/data/auth0_initial_data.dart';
import 'package:growth_auth0/data/user_info.dart';
import 'package:growth_web/growth_web.dart';

/// A web implementation of the GrowthAuth0Platform of the GrowthAuth0 plugin.
class Auth0Api extends Auth0ApiPlatformInterface {
  static final instance = Auth0Api._();

  final _methodChannel = WebMethodChannel();

  late final _client = Auth0Client(_methodChannel);
  late final _spa = Auth0Spa(_methodChannel);

  AuthWebType? _type;

  Auth0Api._();

  factory Auth0Api() {
    return instance;
  }

  static void registerWith(_) {
    Auth0ApiPlatformInterface.instance = Auth0Api();
  }

  @override
  Future<void> initAuth(
    Auth0InitialData data, {
    AuthWebType type = AuthWebType.spa,
  }) async {
    switch (type) {
      case AuthWebType.client:
        _client.initAuth(data);
        break;
      case AuthWebType.spa:
        _spa.initAuth(data);
      default:
    }

    _type = type;
  }

  @override
  Future<bool> loginWithUniversal() async {
    return switch (_type) {
      AuthWebType.spa => _spa.loginWithUniversal(),
      _ => Future.value(false),
    };
  }

  @override
  Future<bool> passwordLessWithEmail(String email) async {
    return switch (_type) {
      AuthWebType.client => _client.passwordLessWithEmail(email),
      _ => Future.value(false),
    };
  }

  @override
  Future<bool> loginWithEmail(
    String email,
    String code,
  ) async {
    return switch (_type) {
      AuthWebType.client => _client.loginWithEmail(email, code),
      _ => Future.value(false),
    };
  }

  @override
  Future<bool> loginWithPhoneNumber(
    String phoneNumber,
    String code,
  ) async {
    return switch (_type) {
      AuthWebType.client => _client.loginWithPhoneNumber(phoneNumber, code),
      _ => Future.value(false),
    };
  }

  @override
  Future<bool> checkIsLogged() {
    return switch (_type) {
      AuthWebType.client => _client.checkIsLogged(),
      AuthWebType.spa => _spa.checkIsLogged(),
      _ => Future.value(false),
    };
  }

  @override
  Future<String> getAccessToken() {
    return switch (_type) {
      AuthWebType.client => _client.getAccessToken(),
      AuthWebType.spa => _spa.getAccessToken(),
      _ => Future.value(''),
    };
  }

  @override
  Future<UserInfo> getUserInfo(String accessToken) {
    return switch (_type) {
      AuthWebType.spa => _spa.getUserInfo(accessToken),
      _ => Future.value(UserInfo()),
    };
  }

  @override
  Future<void> clearWebTokensData() {
    return switch (_type) {
      AuthWebType.client => _client.clearWebTokensData(),
      _ => Future.value(null),
    };
  }

  @override
  Future<void> logout() async {
    return switch (_type) {
      AuthWebType.client => _client.logout(),
      AuthWebType.spa => _spa.logout(),
      _ => Future.value(null),
    };
  }

  @override
  Future<void> logoutWithUniversal() async {
    return switch (_type) {
      AuthWebType.spa => _spa.logoutWithUniversal(),
      _ => Future.value(null),
    };
  }
}
