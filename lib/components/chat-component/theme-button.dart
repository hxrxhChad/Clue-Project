// ignore_for_file: file_names

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeButton extends StatefulWidget {
  const ThemeButton({Key? key}) : super(key: key);

  @override
  State<ThemeButton> createState() => _ThemeButtonState();
}

class _ThemeButtonState extends State<ThemeButton> {
  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          clicked = !clicked;
        });
        AdaptiveTheme.of(context).toggleThemeMode();
      },
      child: Icon(
        clicked ? CupertinoIcons.brightness_solid : CupertinoIcons.brightness,
        color: Colors.white,
      ),
    );
  }
}
