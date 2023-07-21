// Вставить после title
// <script src="https://cdn.auth0.com/js/auth0/9.18/auth0.min.js"></script>
(function() {
    
    let auth;
    
    class AuthClient {
        #webAuth
        #redirectUri = window.location.origin;
        #clientId;
    
        init = (domain, clientId, audience, scope) => {
    
            this.#clientId = clientId
            
            return new Promise((res, rej) => {
                this.#webAuth = new auth0.WebAuth({
                    domain:       domain,
                    clientID:     clientId,
                    redirectUri: this.#redirectUri,
                    responseType: 'token id_token',
                    scope: scope,
                    audience: audience
                });
                
                this.#webAuth.parseHash({ hash: window.location.hash }, (err, authResult) => {
                    if (err) {
                        rej(err);
                        return;
                    }
                    
                    res(authResult);
                });
            })
        }
    
        passwordlessStart = (email) => {
            return new Promise((resolve, rej) => {
                this.#webAuth.passwordlessStart({
                    connection: 'email',
                    send: 'code',
                    email: email,
                  }, (err, data) => {
                    if(data) resolve(data)
                    else if(err) rej(err)
                  }
                );
            })
        }
    
    
        passwordlessLogin = (email, code) => {
            return new Promise((resolve, rej) => {
                this.#webAuth.passwordlessLogin({
                    connection: 'email',
                    email: email,
                    verificationCode: code
                  }, (err,data) => {
                    if(data) resolve(data)
                    else if(err) rej(err)
                  }
                );
            })
        }
    
        getAccessToken = () => {
            return new Promise((res, rej) => {
                this.#webAuth.checkSession({}, (err, data) => {
                    if (err) {
                        rej(err);
                        return;
                    }
            
                    res(data);
                });
            })
        }
    
        logout = () => {
            return this.#webAuth.logout({
                clientID: this.#clientId,
                returnTo: this.#redirectUri
            });
        }
     }
    
    
    function invokeAuth0Client(method, params, caller) {
            switch(method) {
                case 'client.initAuth':
                    auth = new AuthClient();
                    caller(() => {
                        return auth.init(
                            params.authDomain,
                            params.authClientId,
                            params.authAudience,
                            params.authScope
                        )
                    });
                    break;
    
                case 'client.passwordLessWithEmail':
                    caller(async () => {
                        await auth.passwordlessStart(params.email)
                        return true
                    });
                    break;
    
                case 'client.loginWithEmail':
                    caller(async () => {
                        await auth.passwordlessLogin(params.email, params.code)
                        return true
                    });
                    break;
    
                case 'client.getAccessToken':
                    caller(auth.getAccessToken)
                    break;
    
                case 'client.logout':
                    caller(async () => {
                       await auth.logout()
                       return true;
                    })
            }
    }
    
    invokeCallbacks.push(invokeAuth0Client);
})()
