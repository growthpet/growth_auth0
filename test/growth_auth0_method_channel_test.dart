import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:growth_auth0/growth_auth0_method_channel.dart';

void main() {
  MethodChannelGrowthAuth0 platform = MethodChannelGrowthAuth0();
  const MethodChannel channel = MethodChannel('growth_auth0');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {});
}
