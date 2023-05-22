class Auth {
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

let auth = new Auth();

function invokeAuth0(method, params, caller) {
        switch(method) {
            case 'initAuth':
                caller(() => {
                    return auth.init(
                        params.authDomain,
                        params.authClientId,
                        params.authAudience,
                        params.authScope
                    )
                });
                break;

            case 'passwordLessWithEmail':
                caller(async () => {
                    await auth.passwordlessStart(params.email)
                    return true
                });
                break;

            case 'loginWithEmail':
                caller(async () => {
                    await auth.passwordlessLogin(params.email, params.code)
                    return true
                });
                break;

            case 'getAccessToken':
                caller(auth.getAccessToken)
                break;

            case 'logout':
                caller(async () => {
                   await auth.logout()
                   return true;
                })
        }
}

invokeCallbacks.push(invokeAuth0);