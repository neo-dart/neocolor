import 'dart:math' as math;

import 'package:meta/meta.dart';

/// An immutable 32-bit color value in ARGB format.
///
/// This class is intended to be semantically similar to [`dart:ui`]'s `Color`,
/// but includes additional functionality, and is platform independent (i.e.
/// is suitable for non-Flutter environments, such as CLIs or non-Flutter web
/// applications).
///
/// [`dart:ui`]: https://api.flutter.dev/flutter/dart-ui/Color-class.html
///
/// **NOTE**: Unlike `dart:ui`, custom implementations are **not supported**.
/// Prefer [composition over inheritance][composition-over-inheritance].
///
/// [composition-over-inheritance]: https://en.wikipedia.org/wiki/Composition_over_inheritance
@immutable
@sealed
class Color {
  /// A 32-bit value representing this color.
  ///
  /// The bits are assigned as follows:
  /// - Bits 24-31 are the [alpha] value.
  /// - Bits 16-23 are the [red] value.
  /// - Bits 08-15 are the [green] value.
  /// - Bits 00-07 are the [blue] value.
  final int value;

  /// Constructs a color from the lower 32-bits of an [int].
  ///
  /// The bits are interpreted as follows:
  /// - Bits 24-31 are the [alpha] value.
  /// - Bits 16-23 are the [red] value.
  /// - Bits 08-15 are the [green] value.
  /// - Bits 00-07 are the [blue] value.
  ///
  /// In other words, if:
  /// - `AA` is the [alpha] value (in hex)
  /// - `RR` is the [red] value (in hex)
  /// - `GG` is the [green] value (in hex)
  /// - `BB` is the [blue] vlaue (in hex)
  ///
  /// ... the color can be expressed as `const Color(0xAARRGGBB`).
  ///
  /// For example, to get a fully opaque orange, you would use:
  /// ```
  /// //              red blue
  /// //              vv  vv
  /// const Color(0xFFFF9000)
  /// //            ^^  ^^
  ///               alpha^
  ///                   ^^
  ///                    green
  /// ```
  const Color(int value) : value = value & 0xFFFFFFFF;

  /// Constructs a _fully opaque_ color from the lower 8-bits of 3 integers.
  ///
  /// - [r] is [red], from `0` to `255`.
  /// - [g] is [green], from `0` to `255`.
  /// - [b] is [blue], from `0` to `255`.
  ///
  /// Out of range values are brought into range using modulo (`%`) `255.
  ///
  /// This constructor is semantically identical to [Color.fromARGB] where
  /// [alpha] is predefined as `255` (`0xFF`), suitable for fully opaque colors
  /// (i.e. where transparency is not intended or supported).
  const Color.fromRGB(
    int r,
    int g,
    int b,
  ) : value = ((0xFF << 24) |
                ((r & 0xFF) << 16) |
                ((g & 0xFF) << 8) |
                ((b & 0xFF) << 0)) &
            0xFFFFFFFF;

  /// Construct a color from the lower 8-bits of 4 integers.
  ///
  ///
  /// - [a] is [alpha], with `0` being transparent and `255` being fully opaque.
  /// - [r] is [red], from `0` to `255`.
  /// - [g] is [green], from `0` to `255`.
  /// - [b] is [blue], from `0` to `255`.
  ///
  /// Out of range values are brought into range using modulo (`%`) `255`.
  ///
  /// See also [Color.fromRGBO], which takes [alpha] as a floating point value.
  const Color.fromARGB(
    int a,
    int r,
    int g,
    int b,
  ) : value = (((a & 0xFF) << 24) |
                ((r & 0xFF) << 16) |
                ((g & 0xFF) << 8) |
                ((b & 0xFF) << 0)) &
            0xFFFFFFFF;

  /// Construct a color from the lower 8-bits of 3 integers and a [double].
  ///
  /// - [r] is [red], from `0` to `255`.
  /// - [g] is [green], from `0` to `255`.
  /// - [b] is [blue], from `0` to `255`.
  /// - [o] is [opacity], with `0.0` being transparent and `1.0` being fully
  ///   opaque.
  ///
  /// Out of range values are brought into range using modulo (`%`) `255`.
  ///
  /// See also [Color.fromARGB], which takes [opacity] as an integer value.
  const Color.fromRGBO(
    int r,
    int g,
    int b,
    double o,
  ) : value = ((((o * 0xff ~/ 1) & 0xff) << 24) |
                ((r & 0xff) << 16) |
                ((g & 0xff) << 8) |
                ((b & 0xff) << 0)) &
            0xFFFFFFFF;

  /// Constructs a color from _**H**ue-**S**aturation-**L**ightness_, an RGB
  /// alternative.
  ///
  /// HSL has a [cylindrical geometry][wiki-basic].
  ///
  /// - [h] is hue, or the perceived color in degrees (`0` to `360`).
  /// - [s] is saturation, or how "colorful" the color is (`0.0` to `1.0`).
  /// - [l] is lightness, or brightness of the color (`0.0` to `1.0`).
  ///
  /// Out of range values are brought into range using modulo (`%`).
  ///
  /// Unlike the other constructors (i.e. [Color.new] or [Color.fromRGB]) this
  /// constructor is computationally expensive and cannot be canonicalized
  /// (`const`). Where necessary, _consider_ storing the result, particularly
  /// for recurring values:
  ///
  /// ```
  /// while (true) {
  ///   // Performs a computation every loop.
  ///   drawColor(Color.fromHSL(0, 0.5, 0.5));
  /// }
  ///
  /// final color = Color.fromHSL(0, 0.5, 0.5);
  /// while (true) {
  ///   // Computation was already performed.
  ///   drawColor(color);
  /// }
  /// ```
  ///
  /// Optionally, provide [opacity] (defaults to fully opaque, or `1.0`).
  ///
  /// [wiki-basic]: https://en.wikipedia.org/wiki/HSL_and_HSV#Basic_principle
  factory Color.fromHSL(
    double h,
    double s,
    double l, {
    double opacity = 1.0,
  }) {
    // Converts to HSL->HSB which in turn is easier to convert to RGB.
    return HSLResult._(h, s, l, opacity).toColor();
  }

  /// Constructs a color from _**H**ue-**S**aturation-**B**rightness, an RGB
  /// alternative.
  ///
  /// HSV has a [cylindrical geometry][wiki-basic].
  ///
  /// - [h] is hue, or the perceived color in degrees (`0` to `360`).
  /// - [s] is saturation, or how "colorful" the color is (`0.0` to `1.0`).
  /// - [v] is brightness of the color (`0.0` to `1.0`).
  ///
  /// Out of range values are brought into range using modulo (`%`).
  ///
  /// Unlike the other constructors (i.e. [Color.new] or [Color.fromRGB]) this
  /// constructor is computationally expensive and cannot be canonicalized
  /// (`const`). Where necessary, _consider_ storing the result, particularly
  /// for recurring values:
  ///
  /// ```
  /// while (true) {
  ///   // Performs a computation every loop.
  ///   drawColor(Color.fromHSV(0, 0.5, 0.5));
  /// }
  ///
  /// final color = Color.fromHSV(0, 0.5, 0.5);
  /// while (true) {
  ///   // Computation was already performed.
  ///   drawColor(color);
  /// }
  /// ```
  ///
  /// Optionally, provide [opacity] (defaults to fully opaque, or `1.0`).
  ///
  /// [wiki-basic]: https://en.wikipedia.org/wiki/HSL_and_HSV#Basic_principle
  factory Color.fromHSB(
    double h,
    double s,
    double v, {
    double opacity = 1.0,
  }) {
    h = (h / 360) * 6;
    final hh = h.floor();
    final b = v * (1 - s);
    final c = v * (1 - (h - hh) * s);
    final d = v * (1 - (1 - h + hh) * s);
    final m = hh % 6;
    return Color._fromHSBToRGB(v, c, b, d, m, opacity);
  }

  factory Color._fromHSBToRGB(
    double v,
    double c,
    double b,
    double d,
    int m,
    double opacity,
  ) {
    final double red;
    final double green;
    final double blue;
    switch (m) {
      case 0:
        red = v;
        green = d;
        blue = b;
        break;
      case 1:
        red = c;
        green = v;
        blue = b;
        break;
      case 2:
        red = b;
        green = v;
        blue = d;
        break;
      case 3:
        red = b;
        green = c;
        blue = v;
        break;
      case 4:
        red = d;
        green = b;
        blue = v;
        break;
      case 5:
        red = v;
        green = b;
        blue = c;
        break;
      // coverage:ignore-start
      default:
        throw Error(/* I can't "prove" this, but this can never occur! */);
      // coverage:ignore-end
    }
    return Color.fromRGBO(
      _angleToColor(red),
      _angleToColor(green),
      _angleToColor(blue),
      opacity,
    );
  }

  static int _angleToColor(double c) => (c * 255).round();

  /// Returns a copy of color element, with non-null values replaced.
  ///
  /// - [alpha] is from `0` to `255`.
  /// - [red] is from `0` to `255`.
  /// - [green] is from `0` to `255`.
  /// - [blue] is from `0` to `255`.
  ///
  /// Out of range values are brought into range using modulo (`%`) `255`.
  ///
  /// This method is semantically identical to using [Color.fromARGB], i.e.:
  /// ```
  /// void example(Color a) {
  ///   final b = a.withARGB(red: 255);
  ///   final c = Color.fromARGB(a.alpha, 255, a.green, a.blue);
  ///
  ///   // true
  ///   print(b == c);
  /// }
  /// ```
  @useResult
  Color withARGB({int? alpha, int? red, int? green, int? blue}) {
    return Color.fromARGB(
      alpha ?? this.alpha,
      red ?? this.red,
      green ?? this.green,
      blue ?? this.blue,
    );
  }

  /// Returns a copy of color element, with non-null values replaced.
  ///
  /// - [opacity] is from `0.0` to `1.0`.
  /// - [red] is from `0` to `255`.
  /// - [green] is from `0` to `255`.
  /// - [blue] is from `0` to `255`.
  ///
  /// Out of range values are brought into range using modulo (`%`) `255`.
  ///
  /// This method is semantically identical to using [Color.fromRGBO], i.e.:
  /// ```
  /// void example(Color a) {
  ///   final b = a.withRGBO(red: 255);
  ///   final c = Color.fromRGBO(255, a.green, a.blue, a.opacity);
  ///
  ///   // true
  ///   print(b == c);
  /// }
  /// ```
  @useResult
  Color withRGBO({int? red, int? green, int? blue, double? opacity}) {
    return Color.fromRGBO(
      red ?? this.red,
      green ?? this.green,
      blue ?? this.blue,
      opacity ?? this.opacity,
    );
  }

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) {
    assert(
      other is! Color || other.runtimeType == Color,
      'Subtypes of Color are not permitted',
    );
    return other is Color && value == other.value;
  }

  /// The alpha channel of this color as an 8-bit value.
  ///
  /// A value of `0` means this color is fully transparent.
  /// A value of `255` means this color is fully opaque.
  ///
  /// See also: [isTransparent], [isVisible] and [isOpaque].
  int get alpha => (0xFF000000 & value) >> 24;

  /// The alpha channel of this color as a [double].
  ///
  /// A value of `0.0` means this color is fully transparent.
  /// A value of `1.0` means this color is fully opaque.
  ///
  /// See also: [isTransparent], [isVisible], and [isOpaque].
  double get opacity => alpha / 0xFF;

  /// Whether the color is _fully_ opaque, i.e. `alpha == 0xFF`.
  bool get isOpaque => alpha == 0xFF;

  /// Whether the color is **not** _fully_ opaque, i.e. `alpha < 0xFF`.
  bool get isTransparent => alpha < 0xFF;

  /// Whether the color is **not** _fully_ transparent, i.e. `alpha > 0x00`.
  bool get isVisible => alpha > 0x00;

  /// The red channel of this color as an 8-bit value.
  int get red => (0x00FF0000 & value) >> 16;

  /// The green channel of this color as an 8-bit value.
  int get green => (0x0000FF00 & value) >> 8;

  /// The blue channel of this color as an 8-bit value.
  int get blue => (0x000000FF & value) >> 0;

  /// Computes and returns as hue, saturation, and brightness.
  ///
  /// This method is computationally expensive, and should be used sparingly.
  ///
  /// See also: [computeHSL].
  @useResult
  HSBResult computeHSB() {
    final r = red / 255;
    final g = green / 255;
    final b = blue / 255;

    final min = math.min(math.min(r, g), b);
    final max = math.max(math.max(r, g), b);

    // Black-Gray-White
    if (min == max) {
      return HSBResult._(0, 0, min, opacity);
    }

    // Colors other than Black-Gray-White.
    final double d;
    final double h;

    if (min == r) {
      d = g - b;
      h = 3;
    } else if (min == b) {
      d = r - g;
      h = 1;
    } else {
      d = b - r;
      h = 5;
    }

    return HSBResult._(
      60.0 * (h - d / (max - min)),
      (max - min) / max,
      max,
      opacity,
    );
  }

  /// Computes and returns as hue, saturation, and lightness.
  ///
  /// This method is computationally expensive, and should be used sparingly.
  ///
  /// See also: [computeHSB].
  @useResult
  HSLResult computeHSL() => computeHSB().toHSL();

  @override
  String toString() {
    return 'Color <0x${value.toRadixString(16).toUpperCase().padLeft(8, '0')}>';
  }
}

/// Computational result of converting an RGBA [Color] to HSB.
@immutable
@sealed
class HSBResult {
  /// Perceived color in degrees (`0` to `360`).
  final double hue;

  /// How "colorful" the color is (`0.0` to `1.0`).
  final double saturation;

  /// Brightness of the color (`0.0` to `1.0`).
  final double brightness;

  /// The alpha channel of this color as a [double].
  ///
  /// A value of `0.0` means this color is fully transparent.
  /// A value of `1.0` means this color is fully opaque.
  final double opacity;

  /// All instances should be created within `package:neocolor` _only_.
  ///
  /// While it would be possible to make this class' constructor public, keeping
  /// it private and denoting the contract of this class as _sealed_ means we
  /// avoid having to bounds-check any of the values. In other words, values
  /// are guaranteed to be valid in a well-behaving application.
  ///
  /// It's also trivial to create instances of this class (i.e. for testing):
  /// ```
  /// // A bit wordy, but does the job alright.
  /// Color.fromHSB(h, s, b).toHSB();
  /// ```
  const HSBResult._(
    this.hue,
    this.saturation,
    this.brightness,
    this.opacity,
  );

  /// Converts back to an RGBA [Color].
  ///
  /// This is semantically identical to [Color.fromHSB], i.e.:
  /// ```
  /// void example(HSBResult hsb) {
  ///   final a = Color.fromHSB(hsl.hue, hsl.saturation, hsl.brightness);
  ///   final b = result.toColor();
  ///
  ///   // true
  ///   print(a == b);
  /// }
  /// ```
  @useResult
  Color toColor() {
    return Color.fromHSB(
      hue,
      saturation,
      brightness,
      opacity: opacity,
    );
  }

  /// Converts to _**H**ue-**S**aturation-**L**ightness_.
  ///
  /// See [HSLResult] and [Color.fromHSL] for details.
  @useResult
  HSLResult toHSL() {
    final h = hue;
    final s = saturation;
    final v = brightness;
    final l = (2.0 - s) * v;
    return HSLResult._(
      h,
      l == 0 || l == 2.0 ? 0 : s * v / (l <= 1.0 ? l : 2 - l),
      l * 5 / 10,
      opacity,
    );
  }
}

/// Computational result of converting an RGBA [Color] to HSL.
@immutable
@sealed
class HSLResult {
  /// Perceived color in degrees (`0` to `360`).
  final double hue;

  /// How "colorful" the color is (`0.0` to `1.0`).
  final double saturation;

  /// Brightness of the color (`0.0` to `1.0`).
  final double lightness;

  /// The alpha channel of this color as a [double].
  ///
  /// A value of `0.0` means this color is fully transparent.
  /// A value of `1.0` means this color is fully opaque.
  final double opacity;

  /// All instances should be created within `package:neocolor` _only_.
  ///
  /// While it would be possible to make this class' constructor public, keeping
  /// it private and denoting the contract of this class as _sealed_ means we
  /// avoid having to bounds-check any of the values. In other words, values
  /// are guaranteed to be valid in a well-behaving application.
  ///
  /// It's also trivial to create instances of this class (i.e. for testing):
  /// ```
  /// // A bit wordy, but does the job alright.
  /// Color.fromHSL(h, s, l).toHSL();
  /// ```
  const HSLResult._(
    this.hue,
    this.saturation,
    this.lightness,
    this.opacity,
  );

  /// Converts back to an RGBA [Color].
  ///
  /// This is semantically identical to [Color.fromHSL], i.e.:
  /// ```
  /// void example(HSLResult hsl) {
  ///   final a = Color.fromHSL(hsl.hue, hsl.saturation, hsl.lightness);
  ///   final b = result.toColor();
  ///
  ///   // true
  ///   print(a == b);
  /// }
  /// ```
  @useResult
  Color toColor() => toHSB().toColor();

  /// Converts to _**H**ue-**S**aturation-**B**rightness_.
  ///
  /// See [HSBResult] and [Color.fromHSB] for details.
  @useResult
  HSBResult toHSB() {
    final h = hue;
    final l = lightness;
    final s = saturation * (l < 0.5 ? l : 1 - l);
    final o = opacity;
    return HSBResult._(
      h,
      s > 0 ? ((2 * s) / (l + s)) : 0,
      l + s,
      o,
    );
  }
}
