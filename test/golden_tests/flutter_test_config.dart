// flutter_test_config.dart

import 'dart:async';

import 'package:alchemist/alchemist.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      platformGoldensConfig: PlatformGoldensConfig(
        platforms: {HostPlatform.linux},
      ),
      ciGoldensConfig: CiGoldensConfig(enabled: false),
    ),
    run: testMain,
  );
}
