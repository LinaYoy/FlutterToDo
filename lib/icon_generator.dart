import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final icon = await _generateIcon();
  final iconForeground = await _generateIconForeground();

  await _saveImage(icon, 'assets/icon.png');
  await _saveImage(iconForeground, 'assets/icon_foreground.png');
}

Future<ui.Image> _generateIcon() async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  const size = Size(1024, 1024);

  final paint = Paint()
    ..color = const Color(0xFF7D5A50)
    ..style = PaintingStyle.fill;
  canvas.drawRect(Offset.zero & size, paint);

  final textPainter = TextPainter(
    text: const TextSpan(
      text: '和',
      style: TextStyle(
        color: Colors.white,
        fontSize: 600,
        fontFamily: 'Noto Serif JP',
      ),
    ),
    textDirection: TextDirection.ltr,
  );
  textPainter.layout();
  textPainter.paint(
    canvas,
    Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    ),
  );

  final picture = recorder.endRecording();
  return picture.toImage(size.width.toInt(), size.height.toInt());
}

Future<ui.Image> _generateIconForeground() async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  const size = Size(1024, 1024);

  final textPainter = TextPainter(
    text: const TextSpan(
      text: '和',
      style: TextStyle(
        color: Color(0xFF7D5A50),
        fontSize: 600,
        fontFamily: 'Noto Serif JP',
      ),
    ),
    textDirection: TextDirection.ltr,
  );
  textPainter.layout();
  textPainter.paint(
    canvas,
    Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    ),
  );

  final picture = recorder.endRecording();
  return picture.toImage(size.width.toInt(), size.height.toInt());
}

Future<void> _saveImage(ui.Image image, String path) async {
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final buffer = byteData!.buffer;
  final file = File(path);
  if (!await file.parent.exists()) {
    await file.parent.create(recursive: true);
  }
  await file.writeAsBytes(
    buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
  );
}
