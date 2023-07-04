/// Базовое исключение Auth0
abstract class Auth0Exception implements Exception {
  final String? message;

  Auth0Exception([this.message]);
}

/// Исключение инициализации Auth0
class Auth0InitException extends Auth0Exception {
  Auth0InitException([String? message]) : super(message);
}

/// Исключение отправки почты для получения кода авторизации по email
class Auth0PasswordLessEmailException extends Auth0Exception {
  Auth0PasswordLessEmailException([String? message]) : super(message);
}

/// Исключение отправки телефона для получения кода авторизации по смс
class Auth0PasswordLessSMSException extends Auth0Exception {
  Auth0PasswordLessSMSException([String? message]) : super(message);
}

/// Исключение авторизаци по email
class Auth0LoginWithEmailException extends Auth0Exception {
  Auth0LoginWithEmailException([String? message]) : super(message);
}

/// Исключение авторизаци по смс
class Auth0LoginWithPhoneNumberException extends Auth0Exception {
  Auth0LoginWithPhoneNumberException([String? message]) : super(message);
}

/// Исключение получение токена
class Auth0GetAccessTokenException extends Auth0Exception {
  Auth0GetAccessTokenException([String? message]) : super(message);
}

/// Исключение получение при проверке авторизован ли пользователь
class Auth0CheckIsLoggedException extends Auth0Exception {
  Auth0CheckIsLoggedException([String? message]) : super(message);
}

/// Исключение выхода
class Auth0LogoutException extends Auth0Exception {
  Auth0LogoutException([String? message]) : super(message);
}

/// Исключение очистки токенов
class Auth0ClearCredentialsException extends Auth0Exception {
  Auth0ClearCredentialsException([String? message]) : super(message);
}
