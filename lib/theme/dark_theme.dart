import 'package:flutter/material.dart';

MaterialColor myCustomColor = MaterialColor(
  0xFFE60F0C, // Define the color with 0xFF prefix for hex value
  <int, Color>{
    50: Color.fromARGB(255, 246, 95, 85),
    100: Color.fromARGB(255, 239, 80, 71),
    // ... Define other color swatches as needed
    900: Color.fromARGB(255, 154, 0, 0),
  },
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.black,
    primary: myCustomColor,
    secondary: Colors.white,
  ),
);
