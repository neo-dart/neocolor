import 'package:neocolor/neocolor.dart';

/// All of these constructors semantically create the same [Color] object!
void main() {
  const c1 = Color(0xFF42A5F5);
  const c2 = Color.fromARGB(0xFF, 0x42, 0xA5, 0xF5);
  print('$c1 == $c2: ${c1 == c2}');

  const c3 = Color.fromARGB(255, 66, 165, 245);
  const c4 = Color.fromRGBO(66, 165, 245, 1.0);
  print('$c3 == $c4: ${c3 == c4}');

  // Use HSB (sometimes called HSV) and HSL to create colors too!
  final c5 = Color.fromHSB(206.8, 0.7306, 0.9608);
  final c6 = Color.fromHSL(206.8, 0.8990, 0.6100);
  print('$c5 == $c6: ${c5 == c6}');
}
