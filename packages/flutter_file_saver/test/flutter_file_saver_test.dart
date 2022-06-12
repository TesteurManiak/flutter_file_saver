import 'package:flutter_file_saver/flutter_file_saver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'utils/mock_file_manager_platform.dart';

void main() {
  group('FlutterFileSaver', () {
    late FlutterFileSaver fileSaver;
    late MockFileManagerPlatform mockPlatform;

    setUp(() {
      fileSaver = FlutterFileSaver();
      mockPlatform = MockFileManagerPlatform();

      fileSaver.setFileSaverInstance(mockPlatform);
    });

    group('setFileSaverInstance', () {
      const tFileName = 'test.txt';
      const tData = 'test';
      const tPath = 'path/to/file/$tFileName';

      test('set platform to MockFileManagerPlatform', () async {
        // arrange
        when(
          () => mockPlatform.writeFileAsString(
            fileName: tFileName,
            data: tData,
          ),
        ).thenAnswer((_) async => tPath);

        // act
        await fileSaver.writeFileAsString(fileName: tFileName, data: tData);

        // assert
        verify(
          () =>
              mockPlatform.writeFileAsString(fileName: tFileName, data: tData),
        );
      });
    });
  });
}
