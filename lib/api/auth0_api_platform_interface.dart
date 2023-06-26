import 'package:growth_auth0/data/auth0_initial_data.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class Auth0ApiPlatformInterface extends PlatformInterface {
  /// Constructs a GrowthAuth0Platform.
  Auth0ApiPlatformInterface() : super(token: _token);

  static final Object _token = Object();

  static Auth0ApiPlatformInterface? _instance;

  /// The default instance of [GrowthAuth0Platform] to use.
  ///
  /// Defaults to [MethodChannelGrowthAuth0].
  static Auth0ApiPlatformInterface? get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GrowthAuth0Platform] when
  /// they register themselves.
  static set instance(Auth0ApiPlatformInterface? instance) {
    if (instance != null) {
      PlatformInterface.verifyToken(instance, _token);
    }
    _instance = instance;
  }

  Future<void> initAuth(Auth0InitialData data);

  Future<bool> passwordLessWithEmail(String email);

  Future<bool> passwordLessWithSMS(String phoneNumber);

  Future<bool> loginWithEmail(
    String email,
    String code,
  );

  Future<bool> loginWithPhoneNumber(
    String phoneNumber,
    String code,
  );

  Future<bool> checkIsLogged();

  Future<String> getAccessToken();

  Future<void> clearIOSAuhCredentials();

  Future<void> clearWebTokensData();

  Future<void> logout();
}
