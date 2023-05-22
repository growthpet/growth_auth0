import 'package:growth_auth0/data/auth0_initial_data.dart';
import 'growth_auth0_platform_interface.dart';

export 'data/export.dart';

class GrowthAuth0 {
  static Future<void> initAuth(Auth0InitialData data) {
    return GrowthAuth0Platform.instance.initAuth(data);
  }

  static Future<bool> passwordLessWithEmail(String email) {
    return GrowthAuth0Platform.instance.passwordLessWithEmail(email);
  }

  static Future<bool> passwordLessWithSMS(String phoneNumber) {
    return GrowthAuth0Platform.instance.passwordLessWithSMS(phoneNumber);
  }

  static Future<bool> loginWithEmail(
    String email,
    String code,
  ) {
    return GrowthAuth0Platform.instance.loginWithEmail(
      email,
      code,
    );
  }

  static Future<bool> loginWithPhoneNumber(
    String phoneNumber,
    String code,
  ) {
    return GrowthAuth0Platform.instance.loginWithPhoneNumber(
      phoneNumber,
      code,
    );
  }

  static Future<bool> checkIsLogged() {
    return GrowthAuth0Platform.instance.checkIsLogged();
  }

  static Future<String> getAccessToken() {
    return GrowthAuth0Platform.instance.getAccessToken();
  }

  static Future<void> clearIOSAuhCredentials() async {
    return GrowthAuth0Platform.instance.clearIOSAuhCredentials();
  }

  @override
  static Future<void> clearWebTokensData() {
    return GrowthAuth0Platform.instance.clearWebTokensData();
  }

  static Future<void> logout() async {
    return GrowthAuth0Platform.instance.logout();
  }
}
