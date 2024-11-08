// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bug/main.dart';

class DummyImageProvider extends ImageProvider<DummyImageProvider> {
  final int width;
  final int height;

  DummyImageProvider({this.width = 100, this.height = 100});

  @override
  Future<DummyImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<DummyImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadImage(DummyImageProvider key, ImageDecoderCallback decode) {
    return OneFrameImageStreamCompleter(_loadAsync());
  }

  Future<ImageInfo> _loadAsync() async {
    // Create a 1x1 pixel image with a transparent color
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.transparent;
    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()), paint);
    final ui.Image image = await pictureRecorder.endRecording().toImage(width, height);

    return ImageInfo(image: image, scale: 1.0);
  }
}

void main() {
  testWidgets('Thumbnail', (WidgetTester tester) async {
    await tester.runAsync(() async {
      var imageProvider = MemoryImage(
          thumbnail); // DummyImageProvider(width: 64, height: 64);
      var thumbnailPage = Scaffold(
          appBar: AppBar(title: const Text('Thumbnail')),
          body: Thumbnail(
              thumbnail: thumbnail,
              mainImage: Image( //thumbnail_package.ImagePage(
                //'MainImage',
                  image: imageProvider // MemoryImage(thumbnail)
              )
          ));
      await tester.pumpWidget(
          MaterialApp(home: thumbnailPage)
      );

      final thumbnailFinder = find.byType(Thumbnail);
      expect(thumbnailFinder, findsOneWidget);
      await (tester.state(thumbnailFinder) as ThumbnailState).completer!.future;

      final image = find.byType(Image);
      expect(image, findsOneWidget);

      await tester.pumpAndSettle();
      final iconButton = find.byType(IconButton);
      expect(iconButton, findsOneWidget);
      await tester.tap(iconButton);
    });
  });
}
