// ignore_for_file: prefer_const_constructors

import 'package:neocolor/neocolor.dart';
import 'package:test/test.dart';

void main() {
  test('should extract alpha|red|green|blue from a 32-bit integer', () {
    final color = Color(0xAABBCCDD);

    expect(color.alpha, 0xAA);
    expect(color.red, 0xBB);
    expect(color.green, 0xCC);
    expect(color.blue, 0xDD);
  });

  test('should ignore bits > 32', () {
    final color = Color(0xFFAABBCCDD);

    expect(color, Color(0xAABBCCDD));
  });

  test('should create a color from RGB values', () {
    final color = Color.fromRGB(0xAA, 0xBB, 0xCC);

    expect(color, Color(0xFFAABBCC));
  });

  test('should align out of range RGB values', () {
    final color = Color.fromRGB(0xAAA, 0xBBB, 0xCCC);

    expect(color, Color(0xFFAABBCC));
  });

  test('should create a color from ARGB values', () {
    final color = Color.fromARGB(0xAA, 0xBB, 0xCC, 0xDD);

    expect(color, Color(0xAABBCCDD));
  });

  test('should align out of range ARGB values', () {
    final color = Color.fromARGB(0xAAA, 0xBBB, 0xCCC, 0xDDD);

    expect(color, Color(0xAABBCCDD));
  });

  test('should create a color from RGBO values', () {
    final color = Color.fromRGBO(0xBB, 0xCC, 0xDD, 1.0);

    expect(color, Color(0xFFBBCCDD));
  });

  test('should align out of range RGBO values', () {
    final color = Color.fromRGBO(0xBBB, 0xCCC, 0xDDD, 1.5);

    expect(color, Color(0x7EBBCCDD));
  });

  test('should create RGBA values from HSB', () {
    final color = Color.fromHSB(165, 0.50, 0.75, opacity: 0.5);

    expect(color, Color(0x7F60BFA7));
  });

  test('should create RGBA values from HSL', () {
    final color = Color.fromHSL(165, 0.50, 0.75, opacity: 0.5);

    expect(color, Color(0x7F9FDFCF));
  });

  group('should replace values withARGB', () {
    final start = Color(0xAABBCCDD);

    test('alpha', () {
      final color = start.withARGB(alpha: 0x99);

      expect(color, Color(0x99BBCCDD));
    });

    test('red', () {
      final color = start.withARGB(red: 0x99);

      expect(color, Color(0xAA99CCDD));
    });

    test('green', () {
      final color = start.withARGB(green: 0x99);

      expect(color, Color(0xAABB99DD));
    });

    test('blue', () {
      final color = start.withARGB(blue: 0x99);

      expect(color, Color(0xAABBCC99));
    });
  });

  group('should replace vaues withRGBO', () {
    final start = Color(0xAABBCCDD);

    test('opacity', () {
      final color = start.withRGBO(opacity: 1.0);

      expect(color, Color(0xFFBBCCDD));
    });

    test('red', () {
      final color = start.withRGBO(red: 0xFF);

      expect(color, Color(0xAAFFCCDD));
    });

    test('green', () {
      final color = start.withRGBO(green: 0xFF);

      expect(color, Color(0xAABBFFDD));
    });

    test('blue', () {
      final color = start.withRGBO(blue: 0xFF);

      expect(color, Color(0xAABBCCFF));
    });
  });

  test('should provide is{Opaque,Transparent,Visible} for alpha', () {
    final opaque = Color(0xFF000000);
    final transparent = opaque.withARGB(alpha: 0xCC);
    final hidden = opaque.withARGB(alpha: 0x00);

    expect(opaque.isOpaque, isTrue);
    expect(opaque.isTransparent, isFalse);
    expect(opaque.isVisible, isTrue);

    expect(transparent.isOpaque, isFalse);
    expect(transparent.isTransparent, isTrue);
    expect(transparent.isVisible, isTrue);

    expect(hidden.isVisible, isFalse);
  });

  test('should compute HSB/HSV', () {
    final hsb = Color(0x7F60BFA7).computeHSB();

    expect(hsb.hue, closeTo(164.8, 0.05));
    expect(hsb.saturation, closeTo(0.4974, 0.00005));
    expect(hsb.brightness, closeTo(0.7490, 0.00005));
    expect(hsb.opacity, 0x7F / 0xFF);
  });

  test('should compute HSL', () {
    final hsl = Color(0xFF42A5F5).computeHSL();

    expect(hsl.hue, closeTo(206.8, 0.05));
    expect(hsl.saturation, closeTo(0.899, 0.0005));
    expect(hsl.lightness, closeTo(0.6100, 0.0005));
    expect(hsl.opacity, 1.0);
  });
}
