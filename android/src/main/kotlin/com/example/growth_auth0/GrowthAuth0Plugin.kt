package com.example.growth_auth0

import Auth
import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.auth0.android.authentication.AuthenticationException
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

/** GrowthAuth0Plugin */
class GrowthAuth0Plugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private lateinit var context: Context

    private var activity: Activity? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "growth_auth0")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        Log.d("Auth0Plugin", call.method);
        if (call.method == "initAuth") {

            val authClientId: String = call.argument("authClientId") ?: ""
            val authDomain = call.argument("authDomain") ?: ""

            Auth.initAuth(context, authClientId, authDomain)
            result.success(null)

        } else if (call.method == "loginWithUniversal") {
            if (activity == null) {
                result.error("ACTIVITY_NOT_AVAILABLE", "Activity is not available.", null)
                return
            }

            GlobalScope.launch { handleLoginWithUniversalAsync(call, result, activity!!) }
        } else if (call.method == "login") {
            GlobalScope.launch { handleLogin(call, result) }
        } else if (call.method == "passwordLessWithEmail") {
            GlobalScope.launch { handlePasswordLessWithEmail(call, result) }

        } else if (call.method == "passwordLessWithSMS") {
            GlobalScope.launch { handlePasswordLessWithSMS(call, result) }

        } else if (call.method == "loginWithEmail") {
            GlobalScope.launch { handleLoginWithEmail(call, result) }

        } else if (call.method == "loginWithPhoneNumber") {
            GlobalScope.launch { handleLoginWithPhoneNumber(call, result) }

        } else if (call.method == "checkIsLogged") {
            result.success(Auth.checkIsLogged())

        } else if (call.method == "getAccessToken") {
            GlobalScope.launch { handleGetToken(call, result) }

        } else if (call.method == "getUserInfo") {
            GlobalScope.launch { handleGetUserInfo(call, result) }

        } else if (call.method == "logout") {
            handleLogout(result)

        } else {
            result.notImplemented()
        }
    }


    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private suspend fun handleLoginWithUniversalAsync(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result, @NonNull context: Context) {
        val audience = call.argument("audience") ?: ""
        val scope = call.argument("scope") ?: ""
        val scheme = call.argument("scheme") ?: ""

        try {
            result.success(Auth.loginWithUniversalAsync(context, audience, scope, scheme).await())
        } catch (e: AuthenticationException) {
            result.error("Auth0Plugin AuthenticationException handle loginWith universal async", e.getDescription(), null)
        } catch (e: Throwable) {
            result.error("Auth0Plugin Error handle loginWith universal async", e.message, null)
        }
    }

    private suspend fun handleLogin(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        val email = call.argument("email") ?: ""
        val password = call.argument("password") ?: ""
        val realmOrConnection = call.argument("realmOrConnection") ?: ""
        val audience = call.argument("audience") ?: ""
        val scope = call.argument("scope") ?: ""

        try {
            result.success(Auth.loginAsync(email, password, realmOrConnection, audience, scope).await())
        } catch (e: AuthenticationException) {
            result.error("Auth0Plugin AuthenticationException handle login", e.getDescription(), null)
        } catch (e: Throwable) {
            result.error("Auth0Plugin Error handle login", e.message, null)
        }
    }

    private suspend fun handlePasswordLessWithEmail(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        val email = call.argument("email") ?: ""

        try {
            result.success(Auth.passwordLessWithEmailAsync(email).await())
        } catch (e: AuthenticationException) {
            result.error("Auth0Plugin AuthenticationException handle email code", e.getDescription(), null)
        } catch (e: Throwable) {
            result.error("Auth0Plugin Error handle email code", e.message, null)
        }
    }

    private suspend fun handlePasswordLessWithSMS(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        val phoneNumber = call.argument("phoneNumber") ?: ""

        try {
            result.success(Auth.passwordLessWithSMSAsync(phoneNumber).await())
        } catch (e: AuthenticationException) {
            result.error("Auth0Plugin AuthenticationException handle phone number", e.getDescription(), null)
        } catch (e: Throwable) {
            result.error("Auth0Plugin Error handle phone number", e.message, null)
        }

    }

    private suspend fun handleLoginWithEmail(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        val email = call.argument("email") ?: ""
        val code = call.argument("code") ?: ""
        val audience = call.argument("audience") ?: ""
        val scope = call.argument("scope") ?: ""

        try {
            result.success(Auth.loginWithEmailAsync(email, code, audience, scope).await())
        } catch (e: Throwable) {
            result.error("Auth0Plugin Error handle code", e.message, null)
        }

    }

    private suspend fun handleLoginWithPhoneNumber(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        val phoneNumber = call.argument("phoneNumber") ?: ""
        val code = call.argument("code") ?: ""
        val audience = call.argument("audience") ?: ""
        val scope = call.argument("scope") ?: ""

        try {
            result.success(Auth.loginWithPhoneNumberAsync(phoneNumber, code, audience, scope).await())
        } catch (e: Throwable) {
            result.error("Auth0Plugin Error handle code phone", e.message, null)
        }

    }

    private suspend fun handleGetToken(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        try {
            result.success(Auth.getAccessTokenAsync().await())
        } catch (e: Throwable) {
            result.error("Auth0Plugin Error handle get accessToken", e.message, null)
        }

    }

    private suspend fun handleGetUserInfo(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        try {

            val accessToken = call.argument("accessToken") ?: ""

            result.success(Auth.getUserInfoAsync(accessToken).await())
        } catch (e: Throwable) {
            result.error("Auth0Plugin Error handle get user ifno", e.message, null)
        }

    }

    private fun handleLogout(@NonNull result: MethodChannel.Result) {
        try {
            Auth.logout()
            result.success(true)
        } catch (e: Throwable) {
            result.error("Auth0Plugin Error logout", e.message, null)
        }
    }
}
