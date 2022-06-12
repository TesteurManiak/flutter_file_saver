// ignore_for_file: prefer_mixin

import 'package:flutter_file_saver/flutter_file_saver.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFileManagerPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements FileManagerPlatform {}
