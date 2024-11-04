// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bug/main.dart';

void main() {
  testWidgets('Thumbnail', (WidgetTester tester) async {
      var thumbnailPage = Scaffold(
        appBar: AppBar(title: const Text('Thumbnail')),
        body: Thumbnail(
              thumbnail: thumbnail,
              mainImage: Image(//thumbnail_package.ImagePage(
                  //'MainImage',
                  image: MemoryImage(thumbnail)
              )
          ));
      await tester.pumpWidget(
          MaterialApp(home: thumbnailPage)
      );

      expect(find.byType(Thumbnail), findsOneWidget);

      expect(find.byType(Image), findsOneWidget);

      // uncomment to get an infinite cycle
      // while (!find
      //     .byType(IconButton)
      //     .hasFound) {
      //   await tester.pump();
      // }

      await tester.pumpAndSettle();
      await tester.tap(find.byType(IconButton));
  });
}
