// import 'package:flutter/foundation.dart';
// import 'package:growth_auth0/data/auth0_initial_data.dart';
// import 'package:growth_auth0/data/user_info.dart';
// import 'package:growth_auth0/exceptions/auth0_init_exception.dart';
// import 'package:growth_web/growth_web.dart';
// /// TODO доделать
// class Auth0Spa {
//   Auth0InitialData? _data;
//
//   final WebMethodChannel _methodChannel;
//
//   Auth0Spa(this._methodChannel);
//
//   Future<void> initAuth(Auth0InitialData data) async {
//     _data = data;
//     try {
//       await _methodChannel.invokeMethod<void>(
//         'spa.initAuth',
//         {
//           "authClientId": data.clientId,
//           "authDomain": data.domain,
//           "authAudience": data.audience,
//           "authScope": data.scope,
//         },
//       );
//     } on Object catch (e, s) {
//       debugPrint(e.toString());
//       debugPrintStack(stackTrace: s);
//       throw Auth0InitException();
//     }
//   }
//
//   Future<bool> login() async {
//     try {
//       await _methodChannel.invokeMethod<void>('spa.login');
//       return true;
//     } on Object catch (e, s) {
//       debugPrint(e.toString());
//       debugPrintStack(stackTrace: s);
//       throw Auth0LoginException();
//     }
//   }
//
//   Future<bool> checkIsLogged() async {
//     try {
//       final isExistToken = await _methodChannel.invokeMethod<bool?>(
//         'spa.checkIsLogged',
//       );
//       return isExistToken ?? false;
//     } on Object catch (e, s) {
//       debugPrint(e.toString());
//       debugPrintStack(stackTrace: s);
//       throw Auth0CheckIsLoggedException();
//     }
//   }
//
//   Future<String> getAccessToken() async {
//     try {
//       final accessToken =
//           await _methodChannel.invokeMethod<String?>('spa.getAccessToken');
//       if (accessToken == null) {
//         throw '';
//       }
//
//       return accessToken;
//     } on Object catch (e, s) {
//       debugPrint(e.toString());
//       debugPrintStack(stackTrace: s);
//       throw Auth0GetAccessTokenException();
//     }
//   }
//
//   Future<UserInfo> getUserInfo(String accessToken) async {
//     try {
//       final user = await _methodChannel
//           .invokeMethod<Map<String, dynamic>?>('spa.getUser');
//       return UserInfo(
//         email: user?['email'],
//         isEmailVerified: user?['email_verified'],
//       );
//     } on Object catch (e, s) {
//       debugPrint(e.toString());
//       debugPrintStack(stackTrace: s);
//     }
//
//     return UserInfo();
//   }
//
//   Future<void> logout() async {
//     try {
//       return await _methodChannel.invokeMethod<void>('spa.logout');
//     } on Object catch (e, s) {
//       debugPrint(e.toString());
//       debugPrintStack(stackTrace: s);
//       throw Auth0LogoutException();
//     }
//   }
// }
