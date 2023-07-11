import android.content.Context
import android.util.Log
import com.auth0.android.Auth0
import com.auth0.android.authentication.AuthenticationAPIClient
import com.auth0.android.authentication.AuthenticationException
import com.auth0.android.authentication.PasswordlessType
import com.auth0.android.authentication.storage.CredentialsManagerException
import com.auth0.android.authentication.storage.SecureCredentialsManager
import com.auth0.android.authentication.storage.SharedPreferencesStorage
import com.auth0.android.callback.Callback
import com.auth0.android.request.AuthenticationRequest
import com.auth0.android.request.DefaultClient
import com.auth0.android.result.Credentials
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.Deferred

object Auth {
    private lateinit var auth0: Auth0
    private lateinit var authentication: AuthenticationAPIClient
    private lateinit var manager: SecureCredentialsManager

    fun initAuth(context: Context, clientId: String, domain: String) {

        auth0 = Auth0(clientId, domain, "sms")
        authentication = AuthenticationAPIClient(auth0)

        manager = SecureCredentialsManager(context, authentication, SharedPreferencesStorage(context))

        val netClient = DefaultClient(
                connectTimeout = 30,
                readTimeout = 30,
                enableLogging = true
        )

        auth0.networkingClient = netClient
    }

    fun loginAsync(email: String, password: String, realmOrConnection: String, audience: String?,
                   scope: String?): Deferred<Boolean> {
        val deferred = CompletableDeferred<Boolean>()

        Log.d("Auth0Plugin", "loginAsync")


        val request: AuthenticationRequest = authentication
                .login(email, password, realmOrConnection)

        if (audience != null) {
            request.setAudience(audience)
        }

        if (scope != null) {
            request.setScope(scope)
        }

        request.start(object : Callback<Credentials, AuthenticationException> {
            override fun onSuccess(credentials: Credentials) {
                Log.d("Auth0Plugin", "loginAsync success")

                manager.saveCredentials(credentials)

                deferred.complete(true);
            }

            override fun onFailure(error: AuthenticationException) {
                Log.e("Auth0Plugin", "loginAsync error = ${error.message}")
                deferred.completeExceptionally(error)
            }
        })

        return deferred
    }

    fun passwordLessWithEmailAsync(email: String): Deferred<Boolean> {
        val deferred = CompletableDeferred<Boolean>()

        Log.d("Auth0Plugin", "passwordLessWithEmailAsync")

        authentication.passwordlessWithEmail(email, PasswordlessType.CODE)
                .start(object : Callback<Void?, AuthenticationException> {
                    override fun onSuccess(result: Void?) {
                        Log.d("Auth0Plugin", "passwordLessWithSMSAsync success")
                        deferred.complete(true);
                    }

                    override fun onFailure(error: AuthenticationException) {
                        Log.e("Auth0Plugin", "passwordLessWithSMSAsync error = ${error.message}")
                        deferred.completeExceptionally(error)
                    }
                })

        return deferred
    }

    fun passwordLessWithSMSAsync(phoneNumber: String): Deferred<Boolean> {
        val deferred = CompletableDeferred<Boolean>()

        Log.d("Auth0Plugin", "passwordLessWithSMSAsync")

        authentication.passwordlessWithSMS(phoneNumber, PasswordlessType.CODE)
                .start(object : Callback<Void?, AuthenticationException> {
                    override fun onSuccess(result: Void?) {
                        Log.d("Auth0Plugin", "passwordLessWithSMSAsync success")
                        deferred.complete(true);
                    }

                    override fun onFailure(error: AuthenticationException) {
                        Log.e("Auth0Plugin", "passwordLessWithSMSAsync error = ${error.message}")
                        deferred.completeExceptionally(error)
                    }
                })

        return deferred
    }

    fun loginWithEmailAsync(
            email: String,
            code: String,
            audience: String?,
            scope: String?
    ): Deferred<Boolean> {
        val deferred = CompletableDeferred<Boolean>();

        Log.d("Auth0Plugin", "loginWithEmailAsync")

        val request: AuthenticationRequest = authentication.loginWithEmail(email, code)

        if (audience != null) {
            request.setAudience(audience)
        }

        if (scope != null) {
            request.setScope(scope)
        }

        request.start(object : Callback<Credentials, AuthenticationException> {
            override fun onSuccess(credentials: Credentials) {
                Log.d("Auth0Plugin", "loginWithEmailAsync")
                manager.saveCredentials(credentials)
                deferred.complete(true);
            }

            override fun onFailure(error: AuthenticationException) {
                Log.e("Auth0Plugin", "loginWithEmailAsync error ${error.getDescription()}")
                deferred.completeExceptionally(error)
            }
        })

        return deferred
    }

    fun loginWithPhoneNumberAsync(
            phoneNumber: String,
            code: String,
            audience: String?,
            scope: String?
    ): Deferred<Boolean> {
        val deferred = CompletableDeferred<Boolean>();

        Log.d("Auth0Plugin", "loginWithPhoneNumberAsync phoneNumber")

        val request: AuthenticationRequest = authentication.loginWithPhoneNumber(phoneNumber, code, "sms")

        if (audience != null) {
            request.setAudience(audience)
        }

        if (scope != null) {
            request.setScope(scope)
        }


        request.start(object : Callback<Credentials, AuthenticationException> {
            override fun onSuccess(credentials: Credentials) {
                Log.d("Auth0Plugin", "loginWithPhoneNumberAsync success")
                manager.saveCredentials(credentials)
                deferred.complete(true);
            }

            override fun onFailure(error: AuthenticationException) {
                Log.e(
                        "Auth0Plugin",
                        "loginWithPhoneNumberAsync error ${error.getDescription()}"
                )
                deferred.completeExceptionally(error)
            }
        })

        return deferred
    }

    fun checkIsLogged(): Boolean {
        val isExistValidCredentials = manager.hasValidCredentials()
        Log.d("Auth0Plugin", "isExistValidCredentials $isExistValidCredentials")
        return isExistValidCredentials
    }

    fun getAccessTokenAsync(): Deferred<String> {
        val deferred = CompletableDeferred<String>();

        Log.d("Auth0Plugin", "getAccessToken")

        manager.getCredentials(object : Callback<Credentials, CredentialsManagerException> {
            override fun onSuccess(credentials: Credentials) {
                Log.d("Auth0Plugin", "getAccessToken success")

                deferred.complete(credentials.accessToken);
            }

            override fun onFailure(error: CredentialsManagerException) {
                Log.d("Auth0Plugin", "getAccessToken error")

                deferred.completeExceptionally(error)
            }
        })

        return deferred
    }

    fun logout() {
        manager.clearCredentials()
    }
}