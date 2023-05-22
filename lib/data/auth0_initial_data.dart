/// Данные для авторизации
class Auth0InitialData {
  final String clientId;
  final String domain;
  final String audience;
  final String scope;

  Auth0InitialData({
    required this.clientId,
    required this.domain,
    required this.audience,
    required this.scope,
  });

  @override
  String toString() {
    return ''
        'Auth0InitialData(\n'
        ' clientId = $clientId\n'
        ' domain = $domain\n'
        ' audience = $audience\n'
        ' scope = $scope\n'
        ')';
  }
}
