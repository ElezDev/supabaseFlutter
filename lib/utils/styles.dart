import 'package:flutter/material.dart';

const kTitleStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'CM Sans Serif',
  fontSize: 26.0,
  height: 1.5,
);

const kSubtitleStyle = TextStyle(
  color: Colors.white,
  fontSize: 18.0,
  height: 1.2,
);

TextStyle bigTitle(BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  return TextStyle(
    color: isDarkMode
        ? Colors.white
        : Colors.black, // Ajusta el color según el tema
    fontFamily: 'CM Sans Serif',
    fontSize: 26.0,
    height: 1.5,
  );
}

TextStyle big2Title(BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  return TextStyle(
    color: isDarkMode
        ? Colors.white
        : Colors.black, // Ajusta el color según el tema
    fontFamily: 'CM Sans Serif',
    fontSize: 20.0,
    height: 1.5,
  );
}




TextStyle smallitle(BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  return TextStyle(
    color: isDarkMode
        ? Colors.white
        : Colors.black, 
    fontFamily: 'CM Sans Serif',
    fontSize: 15.0,
    height: 1.5,
  );
}

TextStyle smallitlefecha(BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  return TextStyle(
    color: isDarkMode
        ? Colors.black
        : Colors.white, // Ajusta el color según el tema
    fontFamily: 'CM Sans Serif',
    fontSize: 12.0,
    height: 1.5,
  );
}



const LinearGradient activeGradient = LinearGradient(
   colors: [
    Color(0xFF3594DD),
    Color(0xFF4563DB),
    Color(0xFF5036D5),
    Color(0xFF5B16D0),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient inProgressGradient = LinearGradient(
  colors: [Colors.orange, Colors.deepOrange],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient completedGradient = LinearGradient(
  colors: [Color.fromARGB(255, 30, 173, 149), Colors.tealAccent],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient defaultGradient = LinearGradient(
  colors: [Colors.grey, Colors.blueGrey],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
