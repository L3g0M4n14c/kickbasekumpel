import 'dart:io';
import 'package:image/image.dart';

void main() {
  final files = [
    'assets/images/logo/icon-1024.png',
    'assets/images/logo/icon-1024-dark.png',
    'assets/images/logo/icon-1024-tinted.png',
  ];

  final backupDir = Directory('assets/images/logo/originals');
  if (!backupDir.existsSync()) backupDir.createSync(recursive: true);

  for (final path in files) {
    final file = File(path);
    if (!file.existsSync()) {
      print('⚠️ Datei nicht gefunden: $path');
      continue;
    }

    final bytes = file.readAsBytesSync();
    final img = decodeImage(bytes);
    if (img == null) {
      print('⚠️ Konnte $path nicht dekodieren');
      continue;
    }

    // Backup
    final backup = File('${backupDir.path}/${path.split('/').last}');
    if (!backup.existsSync()) backup.writeAsBytesSync(bytes);

    // Convert near-white pixels to transparent by compositing onto an RGBA canvas
    final threshold = 250; // >= threshold => transparent
    final rgba = Image.from(img).convert(numChannels: 4);

    int convertedCount = 0;
    for (var y = 0; y < img.height; y++) {
      for (var x = 0; x < img.width; x++) {
        final p = img.getPixel(x, y);
        final r = p.r;
        final g = p.g;
        final b = p.b;
        if (r >= threshold && g >= threshold && b >= threshold) {
          rgba.setPixelRgba(x, y, r, g, b, 0);
          convertedCount++;
        } else {
          rgba.setPixelRgba(x, y, r, g, b, 255);
        }
      }
    }

    print(
      '  -> Transparente Pixel: $convertedCount, numChannels: ${rgba.numChannels}, hasPalette: ${rgba.hasPalette}',
    );

    // Encode PNG (with alpha) using explicit encoder
    final encoded = PngEncoder().encode(rgba);
    file.writeAsBytesSync(encoded);

    // Verify by decoding written file to check if any pixel has alpha < 255
    final decodedAfter = decodeImage(File(path).readAsBytesSync());
    final hasTransparent =
        decodedAfter != null && _hasTransparentPixel(decodedAfter);
    print(
      '✅ Konvertiert: $path (Backup: ${backup.path}) - hatTransparent: $hasTransparent',
    );
  }

  print(
    '\nFertig. Bitte neu bauen, damit die geänderten Assets geladen werden.',
  );
}

bool _hasTransparentPixel(Image img) {
  for (var y = 0; y < img.height; y++) {
    for (var x = 0; x < img.width; x++) {
      final p = img.getPixel(x, y);
      if (p.a < 255) return true;
    }
  }
  return false;
}
