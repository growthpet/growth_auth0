import 'package:flutter_test/flutter_test.dart';
import 'package:growth_auth0/growth_auth0.dart';
import 'package:growth_auth0/growth_auth0_platform_interface.dart';
import 'package:growth_auth0/growth_auth0_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGrowthAuth0Platform
    with MockPlatformInterfaceMixin
    implements GrowthAuth0Platform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final GrowthAuth0Platform initialPlatform = GrowthAuth0Platform.instance;

  test('$MethodChannelGrowthAuth0 is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGrowthAuth0>());
  });

  test('getPlatformVersion', () async {
    GrowthAuth0 growthAuth0Plugin = GrowthAuth0();
    MockGrowthAuth0Platform fakePlatform = MockGrowthAuth0Platform();
    GrowthAuth0Platform.instance = fakePlatform;
  });
}
