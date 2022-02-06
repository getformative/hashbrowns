/// Hashbrowns allows consistent color generation based on hashcodes.
/// Simply create a `Hashbrowns` instance, and pass a hashcode to `generateColor`,
/// and you will get the same color every time for the same hashcode.
///`This works especially well for string constants whose hashcodes are consistent
/// across instances.
library hashbrowns;

import 'package:flutter/material.dart';

/// A [ColorGenerator] generates a colorset based on a seed integer. Given equal seed integers, the ColorSet should also be the same.
typedef ColorGenerator = ColorSet Function(int);

ColorSet _pastelGenerator(int hash) {
  final lightness = (85 + (10 * (hash >> 24) & 0xFF) / 255) / 100;
  final saturation = (25 + (75 * ((hash >> 16) & 0xFF) / 255)) / 100;
  final hue = 360 * ((hash & 0xFF) / 255);
  final surfaceColor =
      HSLColor.fromAHSL(1, hue, saturation, lightness).toColor();
  final textColor = _textColor(surfaceColor);
  return ColorSet(surfaceColor, textColor);
}

ColorSet _boldGenerator(int hash) {
  final lightness = (45 + (10 * ((hash >> 24) & 0xFF)) / 255) / 100;
  final saturation = (85 + (15 * ((hash >> 16) & 0xFF) / 255)) / 100;
  final hue = 360 * ((hash & 0xFF) / 255);
  final surfaceColor =
      HSLColor.fromAHSL(1, hue, saturation, lightness).toColor();
  final textColor = _textColor(surfaceColor, luminanceThreshold: 0.5);
  return ColorSet(surfaceColor, textColor);
}

Color _textColor(Color surfaceColor, {double luminanceThreshold = 0.5}) {
  if (surfaceColor.computeLuminance() > luminanceThreshold) {
    final hsl = HSLColor.fromColor(surfaceColor);
    final lightnessSubtractor = (hsl.lightness * 0.4).clamp(0.35, 0.6);
    final color = hsl
        .withLightness((hsl.lightness - lightnessSubtractor).clamp(0.0, 1.0))
        .toColor();
    return color;
  }
  return const Color.fromRGBO(255, 255, 255, 1);
}

/// A combination of a surface color and onSurface color.
/// The surface color can appropriately be used as a background color,
/// and the onSurface color can be used as a text color.
class ColorSet {
  ColorSet(this.surfaceColor, this.onSurfaceColor);
  Color surfaceColor;
  Color onSurfaceColor;
  @override
  String toString() =>
      'surfaceColor: $surfaceColor; onSurfaceColor: $onSurfaceColor';

  @override
  int get hashCode =>
      surfaceColor.value.hashCode ^ onSurfaceColor.value.hashCode;

  @override
  operator ==(covariant other) =>
      other is ColorSet &&
      other.surfaceColor.value == surfaceColor.value &&
      other.onSurfaceColor.value == surfaceColor.value;
}

/// The Hashbrown class provides a generateColor method.
/// The Hashbrown accepts as a constructor parameter a [ColorGenerator], which can be used to customize the color generation behavior of the library.
/// By default, Hashbrown includes two color generation strategies, `pastels` and `bold`.
/// The hashbrown class provides factories to access these generators: `Hashbrown.pastels()` and `Hashbrown.bold()`
class Hashbrowns {
  ColorGenerator _colorGenerator;

  /// `Hashbrowns.bold()` creates an instance of [Hashbrowns] that produces vibrant surface colors and a contrasting text color
  factory Hashbrowns.bold() {
    return Hashbrowns(_boldGenerator);
  }

  /// `Hashbrowns.pastels()` factory instantiates a [Hashbrowns] class with a pastel color generator.
  /// This will create a background color with a high luminance, and a darker shade foreground color.
  factory Hashbrowns.pastels() {
    return Hashbrowns(_pastelGenerator);
  }

  /// `generateColor` takes a hashcode (or any other integer) as a parameter and generates a [ColorSet].
  ColorSet generateColor(int hashcode) {
    return _colorGenerator(hashCode);
  }

  Hashbrowns(this._colorGenerator);
}
