import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart' ; import 'package:test/test.dart';

void main() {
  takeScreenshot(FlutterDriver driver, String path) async {
    final List<int> pixels = await driver.screenshot();
    final File file = new File(path);
    await file.writeAsBytes(pixels);
    print(path);
  }
  
  group('Flutter Driver demo', () {
    FlutterDriver driver;

    setUpAll(() async {
      new Directory('screenshots').create();
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    test('Flutter drive methods demo', () async {
      await takeScreenshot(driver, 'screenshots/entered_text.png');
    });
  });
}