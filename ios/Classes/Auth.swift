import Flutter
import UIKit
import Auth0

class Auth {
    static var shared: Auth = {
            return Auth()
        }()
    
    private init() {}
    
    private var authentication: Authentication!
    private var manager: CredentialsManager!
    
    func initAuth(clientId: String, domain: String) {
        authentication = Auth0.authentication(clientId: clientId, domain: domain)
        manager = CredentialsManager(authentication: authentication)
    }
    
    func passwordLessWithEmail(
        email: String,
        onSuccess: @escaping ((_ isSuccess: Bool) -> Void),
        onError: @escaping ((_ error: FlutterError) -> Void)
    ) {
        return authentication
               .startPasswordless(email: email)
               .start {
                   result in
                       switch result {
                       case .success:
                           debugPrint("Auth0Plugin passwordLessWithEmail success")
                           onSuccess(true);
                       case .failure(let error):
//                           AuthenticationError
                           debugPrint("Auth0Plugin passwordLessWithEmail error \(error.debugDescription)")
                           onError(
                                FlutterError(
                                    code: "auth0PasswordlessError",
                                    message: error.debugDescription,
                                    details: ""
                                )
                           )
                       }
               }
    }
    
    func passwordLessWithSMS(
        phoneNumber: String,
        onSuccess: @escaping ((_ isSuccess: Bool) -> Void),
        onError: @escaping ((_ error: FlutterError) -> Void)
    ) {
        return authentication
               .startPasswordless(phoneNumber: phoneNumber)
               .start {
                   result in
                       switch result {
                       case .success:
                           debugPrint("Auth0Plugin passwordLessWithSMS success")
                           onSuccess(true);
                       case .failure(let error):
//                           AuthenticationError
                           debugPrint("Auth0Plugin passwordLessWithSMS error \(error.debugDescription)")
                           onError(
                                FlutterError(
                                    code: "auth0PasswordlessError",
                                    message: error.debugDescription,
                                    details: ""
                                )
                           )
                       }
               }
    }
    
    func loginWithEmail(
        email: String,
        code: String,
        audience: String?,
        scope: String?,
        onSuccess: @escaping ((_ isSuccess: Bool) -> Void),
        onError: @escaping ((_ error: FlutterError) -> Void)
    ) {
        authentication
           .login(
                email: email,
                code: code,
                audience: audience,
                scope: scope ?? Auth0.defaultScope
            )
           .start { result in
               switch result {
               case .success(let credentials):
                   self.manager.store(credentials: credentials)
                   debugPrint("Auth0Plugin loginWithEmail success email = \(email); audience = \(audience); scope = \(scope);")
                   onSuccess(true)
               case .failure(let error):
                   debugPrint("Auth0Plugin loginWithEmail error \(error.debugDescription)")
                   onError(
                    FlutterError(
                        code: "auth0loginWithEmail",
                        message: error.debugDescription,
                        details: ""
                    )
                   )
               }
           }
    }
    
    func loginWithPhoneNumber(
        phoneNumber: String,
        code: String,
        audience: String?,
        scope: String?,
        onSuccess: @escaping ((_ isSuccess: Bool) -> Void),
        onError: @escaping ((_ error: FlutterError) -> Void)
    ) {
        authentication
           .login(
                phoneNumber: phoneNumber,
                code: code,
                audience: audience,
                scope: scope ?? Auth0.defaultScope
            )
           .start { result in
               switch result {
               case .success(let credentials):
                   debugPrint("Auth0Plugin loginWithPhoneNumber success phoneNumber = \(phoneNumber); audience = \(audience); scope = \(scope);")
                   self.manager.store(credentials: credentials)
                   onSuccess(true)
               case .failure(let error):
                   debugPrint("Auth0Plugin loginWithPhoneNumber error \(error.debugDescription)")
                   onError(
                    FlutterError(
                        code: "auth0LoginWithPhoneNumber",
                        message: error.debugDescription,
                        details: ""
                    )
                   )
               }
           }
    }
    
    func checkIsLogged() -> Bool {
        guard manager.canRenew() else {
            debugPrint("Auth0Plugin checkIsLogged false")
            return false
        }
        
        debugPrint("Auth0Plugin checkIsLogged true")
        return true
    }
    
    func getAccessToken(
        onSuccess: @escaping ((_ accessToken: String) -> Void),
        onError: @escaping ((_ error: FlutterError) -> Void)
    ) {
        manager.credentials { (result: CredentialsManagerResult<Credentials>) in
            switch(result) {
                case .success(let credentials):
                    debugPrint("Auth0Plugin getAccessToken success")
                    onSuccess(credentials.accessToken)
                    break;
                
                case .failure(let error):
                    debugPrint("Auth0Plugin getAccessToken error \(error.debugDescription)")
                    onError(FlutterError(
                        code: "auth0GetAccessToken",
                        message: error.debugDescription,
                        details: ""
                    ))
                    break;
                }
        }
    }
    
    func clearCredentials() -> Bool {
        manager.revoke()
        manager.clear()
        
        return true;
    }
    
    func logout() -> Bool {
        return clearCredentials();
    }
}
