import Flutter
import UIKit

public class GrowthAuth0Plugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "growth_auth0", binaryMessenger: registrar.messenger())
        let instance = GrowthAuth0Plugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch(call.method) {
            case "initAuth":
                handleInit(call: call, result: result)
                
        case  "login":
                handleLogin(call: call, result: result)
                break;
            
        case  "passwordLessWithEmail":
                handlePasswordLessWithEmail(call: call, result: result)
                break;
            
            case "passwordLessWithSMS":
                handlePasswordLessWithSMS(call: call, result: result)
                
            case "loginWithEmail":
                handleLoginWithEmail(call: call, result: result)
                break;
            
                break;
            case "loginWithPhoneNumber":
                handleLoginWithPhoneNumber(call: call, result: result)
                break;
                
            case "checkIsLogged":
                result(Auth.shared.checkIsLogged())
                break;
                
            case "getAccessToken":
                handleGetAccessToken(result: result)
                break;
            
            case "clearCredentials":
                result(Auth.shared.clearCredentials())
                break;
            
            case "logout":
                result(Auth.shared.logout())
                break;
            default:
                result(getBaseError())
        }
    
        
    }
    
    private func handleInit(call: FlutterMethodCall, result: @escaping FlutterResult) {
    
        if let myArgs = call.arguments as? [String: Any],
           let authClientId =  myArgs["authClientId"] as? String,
           let authDomain =  myArgs["authDomain"] as? String {
           
            Auth.shared.initAuth(clientId: authClientId, domain: authDomain)
            debugPrint("Auth0Plugin initAuth complete")
            
            result(true)
            
        } else {
            debugPrint("Auth0Plugin error")
            result(getBaseError())
        }
    }
    
    private func handlePasswordLessWithEmail(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let myArgs = call.arguments as? [String: Any],
           let email =  myArgs["email"] as? String {
            
            //Result<Void, AuthenticationError>
            Auth.shared.passwordLessWithEmail(
                email: email,
                onSuccess: {
                    (isSuccess: Bool) in result(isSuccess)
                },
                onError: {
                    (error: FlutterError) in result(error)
                }
            )
            
        } else {
            result(getBaseError())
        }
    }
    
    private func handlePasswordLessWithSMS(call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        if let myArgs = call.arguments as? [String: Any],
           let phoneNumber =  myArgs["phoneNumber"] as? String {
            
            //Result<Void, AuthenticationError>
            Auth.shared.passwordLessWithSMS(
                phoneNumber: phoneNumber,
                onSuccess: {
                    (isSuccess: Bool) in result(isSuccess)
                },
                onError: {
                    (error: FlutterError) in result(error)
                }
            )
            
        } else {
            result(getBaseError())
        }
    }
    
    private func handleLogin(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let myArgs = call.arguments as? [String: Any],
           let email =  myArgs["email"] as? String,
           let password =  myArgs["password"] as? String,
           let realmOrConnection =  myArgs["realmOrConnection"] as? String {
            
            var audience: String? = nil
            var scope: String? = nil
            
            if(myArgs["audience"] is String?) {
                audience = myArgs["audience"] as! String?
            }
            
            if(myArgs["scope"] is String?) {
                scope = myArgs["scope"] as! String?
            }
            
            Auth.shared.login(
                email: email,
                password: password,
                audience: audience,
                scope: scope,
                realmOrConnection: realmOrConnection,
                onSuccess: {
                    (isSuccess: Bool) in result(isSuccess)
                },
                onError: {
                    (error: FlutterError) in result(error)
                }
            )
        } else {
            result(getBaseError())
        }
    }
    
    private func handleLoginWithEmail(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let myArgs = call.arguments as? [String: Any],
           let email =  myArgs["email"] as? String,
           let code =  myArgs["code"] as? String {
            
            var audience: String? = nil
            var scope: String? = nil
            
            if(myArgs["audience"] is String?) {
                audience = myArgs["audience"] as! String?
            }
            
            if(myArgs["scope"] is String?) {
                scope = myArgs["scope"] as! String?
            }
            
            Auth.shared.loginWithEmail(
                email: email,
                code: code,
                audience: audience,
                scope: scope,
                onSuccess: {
                    (isSuccess: Bool) in result(isSuccess)
                },
                onError: {
                    (error: FlutterError) in result(error)
                }
            )
            
        } else {
            result(getBaseError())
        }
    }
    
    private func handleLoginWithPhoneNumber(call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        if let myArgs = call.arguments as? [String: Any],
           let phoneNumber =  myArgs["phoneNumber"] as? String,
           let code =  myArgs["code"] as? String {
            
            var audience: String?
            var scope: String?
            
            if(myArgs["audience"] is String?) {
                audience = myArgs["audience"] as! String?
            }
            
            if(myArgs["scope"] is String?) {
                scope = myArgs["scope"] as! String?
            }
            
            Auth.shared.loginWithPhoneNumber(
                phoneNumber: phoneNumber,
                code: code,
                audience: audience,
                scope: scope,
                onSuccess: {
                    (isSuccess: Bool) in result(isSuccess)
                },
                onError: {
                    (error: FlutterError) in result(error)
                }
            )
            
        } else {
            result(getBaseError())
        }
    }
    
    private func handleGetAccessToken(result: @escaping FlutterResult) {
        Auth.shared.getAccessToken(
            onSuccess: {
                (accessToken: String) in result(accessToken)
            },
            onError: {
                (error: FlutterError) in result(error)
            }
        )
    }
    
    private func getBaseError() -> FlutterError {
       return FlutterError(code: "Auth0Plugin error", message: "", details: "")
    }
    
    
}
