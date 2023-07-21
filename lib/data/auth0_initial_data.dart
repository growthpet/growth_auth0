/// Данные для авторизации
class Auth0InitialData {
  final String clientId;
  final String domain;
  final String audience;
  final Set<String> scopes;
  final String? scheme;
  final String? redirectUri;

  String get scope => scopes.join(' ');

  Auth0InitialData({
    required this.clientId,
    required this.domain,
    required this.audience,
    required this.scopes,
    this.scheme,
    this.redirectUri,
  });

  @override
  String toString() {
    return ''
        'Auth0InitialData(\n'
        ' clientId = $clientId\n'
        ' domain = $domain\n'
        ' audience = $audience\n'
        ' scopes = $scopes\n'
        ' scheme = $scheme\n'
        ' redirectUri = $redirectUri\n'
        ')';
  }
}
