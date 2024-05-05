import 'package:flutter/material.dart';

IconButton rockIconButton(VoidCallback onPressed) {
  return IconButton(
    onPressed: onPressed,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    icon: Image.asset(
      'images/Rock_Card.png',
      width: 125,
      height: 225,
    ),
  );
}

IconButton paperIconButton(VoidCallback onPressed) {
  return IconButton(
    onPressed: onPressed,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    icon: Image.asset(
      'images/Paper_Card.png',
      width: 125,
      height: 225,
    ),
  );
}

IconButton scissorsIconButton(VoidCallback onPressed) {
  return IconButton(
    onPressed: onPressed,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    icon: Image.asset(
      'images/Scissors_Card.png',
      width: 125,
      height: 225,
    ),
  );
}
