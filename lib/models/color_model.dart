import 'dart:convert';

class ColorModel {
  final String? color1;
  final String? color2;
  final String? color3;
  final String? color4;
  final String? color5;
  final String? color6;

  ColorModel({
    this.color1,
    this.color2,
    this.color3,
    this.color4,
    this.color5,
    this.color6,
  });

  factory ColorModel.fromColorList(List<String> colorCodes) {
    return ColorModel(
      color1: colorCodes.length > 0 ? colorCodes[0] : null,
      color2: colorCodes.length > 1 ? colorCodes[1] : null,
      color3: colorCodes.length > 2 ? colorCodes[2] : null,
      color4: colorCodes.length > 3 ? colorCodes[3] : null,
      color5: colorCodes.length > 4 ? colorCodes[4] : null,
      color6: colorCodes.length > 5 ? colorCodes[5] : null,
    );
  }
}
