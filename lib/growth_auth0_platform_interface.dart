import 'package:growth_auth0/data/auth0_initial_data.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'growth_auth0_method_channel.dart';

abstract class GrowthAuth0Platform extends PlatformInterface {
  /// Constructs a GrowthAuth0Platform.
  GrowthAuth0Platform() : super(token: _token);

  static final Object _token = Object();

  static GrowthAuth0Platform _instance = MethodChannelGrowthAuth0();

  /// The default instance of [GrowthAuth0Platform] to use.
  ///
  /// Defaults to [MethodChannelGrowthAuth0].
  static GrowthAuth0Platform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GrowthAuth0Platform] when
  /// they register themselves.
  static set instance(GrowthAuth0Platform instance) {
    PlatformInterface.verifyToken(instance, _token);
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

  @override
  Future<void> clearWebTokensData();

  Future<void> logout();
}
