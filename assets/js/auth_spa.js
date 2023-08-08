// Вставить после title
// <script src="https://cdn.auth0.com/js/auth0-spa-js/2.1/auth0-spa-js.production.js"></script>
// TODO доделать
(function() {

    let auth;
    
    class AuthSpaClient {
        #webAuth
        #audience
        #scope
        #redirectUri = window.location.origin
    
        init = (domain, clientId, audience, scope) => {
            
            this.#audience = audience
            this.#scope = scope
            
            return new Promise((res, rej) => {
                try {
                    this.#webAuth = new auth0.Auth0Client({
                        domain: domain,
                        clientId: clientId,
                        // TODO передавать
                        useRefreshTokens: true,
                        cacheLocation: 'localstorage',
                        authorizationParams: {
                            audience: this.#audience,
                            scope: this.#scope,
                            // TODO передавать
                            redirect_uri: this.#redirectUri,
                            // TODO передавать
                            prompt: 'select_account',
                        }
                      });
                      res()
                } catch(e) {
                    rej(e)
                }
            })
        }


    
        getAccessToken = () => {
            return this.#webAuth.getTokenSilently()
        }

        checkIsLogged = () => {
          return this.#webAuth.isAuthenticated();
        }
    
        login = () => {
            return this.#webAuth.loginWithRedirect(); 
        }

        logout = () => {
            return this.#webAuth.logout();
        }

        getUser = () => {
            return this.#webAuth.getUser();
        }
     }
    
    
    function invokeAuth0SpaClient(method, params, caller) {
            switch(method) {
                case 'spa.initAuth':
                    auth = new AuthSpaClient();
                    caller(() => {
                        return auth.init(
                            params.authDomain,
                            params.authClientId,
                            params.authAudience,
                            params.authScope
                        )
                    });
                    break;
                
                case 'spa.getAccessToken':
                    caller(() => {
                        return auth.getAccessToken()
                    });
                    break;

                case 'spa.checkIsLogged':
                    caller(() => {
                        return auth.checkIsLogged()
                    });
                    break;
                    
                case 'spa.login':
                    caller(() => {
                        return auth.login()
                    });
                    break;

                case 'spa.logout':
                    caller(() => {
                        return auth.logout()
                    });
                    break;

                case 'spa.getUser':
                    caller(() => {
                        return auth.getUser()
                    });
                    break;
            }
    }
    
    invokeCallbacks.push(invokeAuth0SpaClient);
})()
