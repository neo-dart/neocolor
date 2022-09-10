# neocolor

Color definition, manipulation, conversion, and comparison in fluent Dart.

[![On pub.dev][pub_img]][pub_url]
[![Code coverage][cov_img]][cov_url]
[![Github action status][gha_img]][gha_url]
[![Dartdocs][doc_img]][doc_url]
[![Style guide][sty_img]][sty_url]

[pub_url]: https://pub.dartlang.org/packages/neocolor
[pub_img]: https://img.shields.io/pub/v/neocolor.svg
[gha_url]: https://github.com/neo-dart/neocolor/actions
[gha_img]: https://github.com/neo-dart/neocolor/workflows/Dart/badge.svg
[cov_url]: https://codecov.io/gh/neo-dart/neocolor
[cov_img]: https://codecov.io/gh/neo-dart/neocolor/branch/main/graph/badge.svg
[doc_url]: https://www.dartdocs.org/documentation/neocolor/latest
[doc_img]: https://img.shields.io/badge/Documentation-neocolor-blue.svg
[sty_url]: https://pub.dev/packages/neodart
[sty_img]: https://img.shields.io/badge/style-neodart-9cf.svg

## Purpose

Provides platform-agnostic (i.e. CLI, Flutter, Web) classes and conventions for
_defining_ (creating or parsing from popular formats), _manipulating_ (changing
elements like brightness, hue, saturation, etc), _conversion_ (from/to popular
formats), and _comparison_ (sometimes called "distance") `Color` elements.

## Usage

If you've used Flutter's [`Color`][dart-ui-color] class, you'll feel at home:

```dart
import 'package:neocolor/neocolor.dart';

void main() {
  const c1 = Color(0xFF42A5F5);
  const c2 = Color.fromARGB(0xFF, 0x42, 0xA5, 0xF5);
  print('$c1 == $c2: ${c1 == c2}');

  const c3 = Color.fromARGB(255, 66, 165, 245);
  const c4 = Color.fromRGBO(66, 165, 245, 1.0);
  print('$c3 == $c4: ${c3 == c4}');

  // NEW: Use HSB (sometimes called HSV) and HSL to create colors too!
  final c5 = Color.fromHSB(206.8, 0.7306, 0.9608);
  final c6 = Color.fromHSL(206.8, 0.8990, 0.6100);
  print('$c5 == $c6: ${c5 == c6}');
}
```

[dart-ui-color]: https://api.flutter.dev/flutter/dart-ui/Color-class.html

## Contributing

**This package welcomes [new issues][issues] and [pull requests][fork].**

[issues]: https://github.com/neo-dart/neocolor/issues/new
[fork]: https://github.com/neo-dart/neocolor/fork

Changes or requests that do not match the following criteria will be rejected:

1. Common decency as described by the [Contributor Covenant][code-of-conduct].
2. Making this library brittle/extensible by other libraries.
3. Adding platform-specific functionality.
4. A somewhat arbitrary bar of "complexity", everything should be _easy to use_.

[code-of-conduct]: https://www.contributor-covenant.org/version/1/4/code-of-conduct/

## Inspiration

Packages already exist that tackle this problem, often in similar ways:

- Flutter's [`dart:ui`][dart-ui-color]
- [`package:color`](https://pub.dev/packages/color)
- [`package:dynamic_color`](https://pub.dev/packages/dynamic_color)
- [`package:eo_color`](https://pub.dev/packages/eo_color)
- [`package:ansicolor`](https://pub.dev/packages/ansicolor)
- [`package:rainbow_color`](https://pub.dev/packages/rainbow_color)
- [`package:tinycolor2`](https://pub.dev/packages/tinycolor2)
- [`package:pigment`](https://pub.dev/packages/pigment)
- [`colord` (on NPM)](https://www.npmjs.com/package/colord)

If one of these packages suits your needs better, use it instead!
