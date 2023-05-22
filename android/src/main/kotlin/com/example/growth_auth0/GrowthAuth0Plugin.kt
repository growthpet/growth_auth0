package com.example.growth_auth0

import Auth
import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.auth0.android.authentication.AuthenticationException
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

/** GrowthAuth0Plugin */
class GrowthAuth0Plugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private lateinit var context: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "growth_auth0")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
    Log.d("Auth0Plugin", call.method);
    if (call.method == "initAuth") {

      val authClientId: String = call.argument("authClientId") ?: ""
      val authDomain = call.argument("authDomain") ?: ""

      Auth.initAuth(context, authClientId, authDomain)
      result.success(null)

    } else if (call.method == "passwordLessWithEmail"){
      GlobalScope.launch { handlePasswordLessWithEmail(call, result) }

    } else if (call.method == "passwordLessWithSMS") {
      GlobalScope.launch { handlePasswordLessWithSMS(call, result) }

    } else if(call.method == "loginWithEmail") {
      GlobalScope.launch { handleLoginWithEmail(call, result) }

    } else if (call.method == "loginWithPhoneNumber") {
      GlobalScope.launch { handleLoginWithPhoneNumber(call, result) }

    } else if(call.method == "checkIsLogged") {
      result.success(Auth.checkIsLogged())

    } else if(call.method == "getAccessToken") {
      GlobalScope.launch { handleGetToken(call, result) }

    } else if(call.method == "logout") {
      handleLogout(result)

    } else {
      result.notImplemented()
    }
  }



  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private suspend fun handlePasswordLessWithEmail(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
    val email = call.argument("email") ?: ""

    try {
      val isSuccess = Auth.passwordLessWithEmailAsync(email).await()
      Log.d("Auth0Plugin", "success = $isSuccess email = $email")
      result.success(isSuccess)
    } catch (e: AuthenticationException) {
      result.error("Auth0Plugin AuthenticationException handle email = $email", e.getDescription(), null)
    } catch (e: Throwable) {
      result.error("Auth0Plugin Error handle email = $email", e.message, null)
    }
  }

  private suspend fun handlePasswordLessWithSMS(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
    val phoneNumber = call.argument("phoneNumber") ?: ""

    try {
      val isSuccess = Auth.passwordLessWithSMSAsync(phoneNumber).await()
      Log.d("Auth0Plugin", "success = $isSuccess phone number = $phoneNumber")
      result.success(isSuccess)
    } catch (e: AuthenticationException) {
      result.error("Auth0Plugin AuthenticationException handle phone number = $phoneNumber", e.getDescription(), null)
    } catch (e: Throwable) {
      result.error("Auth0Plugin Error handle phone number = $phoneNumber", e.message, null)
    }

  }

  private suspend fun handleLoginWithEmail(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
    val email = call.argument("email") ?: ""
    val code = call.argument("code") ?: ""
    val audience = call.argument("audience") ?: ""
    val scope = call.argument("scope") ?: ""

    try {
      val isSuccess: Boolean = Auth.loginWithEmailAsync(email, code, audience, scope).await()
      Log.d("Auth0Plugin", "success email = $email; audience = $audience; scope = $scope")
      result.success(isSuccess)
    } catch (e: Throwable) {
      result.error("Auth0Plugin Error handle code email = $email", e.message, null)
    }

  }

  private suspend fun handleLoginWithPhoneNumber(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
    val phoneNumber = call.argument("phoneNumber") ?: ""
    val code = call.argument("code") ?: ""
    val audience = call.argument("audience") ?: ""
    val scope = call.argument("scope") ?: ""

    try {
      val isSuccess: Boolean = Auth.loginWithPhoneNumberAsync(phoneNumber, code, audience, scope).await()
      Log.d("Auth0Plugin", "success code number = $phoneNumber; audience = $audience; scope= $scope")
      result.success(isSuccess)
    } catch (e: Throwable) {
      result.error("Auth0Plugin Error handle code phone number = $phoneNumber", e.message, null)
    }

  }
  private suspend fun handleGetToken(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
    try {
      val accessToken: String = Auth.getAccessTokenAsync().await()
      Log.d("Auth0Plugin", "success get accessToken")
      result.success(accessToken)
    } catch (e: Throwable) {
      result.error("Auth0Plugin Error handle get accessToken", e.message, null)
    }

  }

  private fun handleLogout( @NonNull result: MethodChannel.Result) {
    try {
      Auth.logout()
      result.success(true)
    } catch (e: Throwable) {
      result.error("Auth0Plugin Error logout", e.message, null)
    }
  }
}
