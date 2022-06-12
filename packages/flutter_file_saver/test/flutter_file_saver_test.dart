import 'dart:typed_data';

import 'package:flutter_file_saver/flutter_file_saver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'utils/mock_file_manager_platform.dart';

void main() {
  group('FlutterFileSaver', () {
    const tFileName = 'test.txt';
    const tPath = 'path/to/file/$tFileName';

    late FlutterFileSaver fileSaver;
    late MockFileManagerPlatform mockPlatform;

    setUp(() {
      fileSaver = FlutterFileSaver();
      mockPlatform = MockFileManagerPlatform();

      fileSaver.setFileSaverInstance(mockPlatform);
    });

    group('writeFileAsString', () {
      const tData = 'test';

      test(
        'should call writeFileAsString from the platform implementation',
        () async {
          // arrange
          when(
            () => mockPlatform.writeFileAsString(
              fileName: tFileName,
              data: tData,
            ),
          ).thenAnswer((_) async => tPath);

          // act
          final path = await fileSaver.writeFileAsString(
            fileName: tFileName,
            data: tData,
          );

          // assert
          expect(path, tPath);
          verify(
            () => mockPlatform.writeFileAsString(
              fileName: tFileName,
              data: tData,
            ),
          );
        },
      );
    });

    group('writeFileAsBytes', () {
      final tBytes = Uint8List.fromList([1, 2, 3, 4, 5]);

      test('should call writeFile from platform implementation', () async {
        // arrange
        when(() => mockPlatform.writeFile(fileName: tFileName, bytes: tBytes))
            .thenAnswer((_) async => tPath);

        // act
        final path = await fileSaver.writeFileAsBytes(
          fileName: tFileName,
          bytes: tBytes,
        );

        // assert
        expect(path, tPath);
        verify(
          () => mockPlatform.writeFile(
            fileName: tFileName,
            bytes: tBytes,
          ),
        );
      });
    });
  });
}
