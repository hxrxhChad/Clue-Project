import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:clue/firebase_options.dart';
import 'package:clue/page/log-in-page.dart';
import 'package:clue/service/helper/active-tracker.dart';
import 'package:clue/service/style/color.dart';
import 'package:clue/service/style/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString("email");
  final savedTheme = await AdaptiveTheme.getThemeMode();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Set status bar color to transparent
    statusBarBrightness: Brightness.light, // Set status bar brightness
    systemNavigationBarColor:
        darkC, // Set system navigation bar color to transparent
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(
    ProviderScope(
      child: MainApp(
        savedThemeMode: savedTheme,
        email: email,
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  final String? email;

  final AdaptiveThemeMode? savedThemeMode;
  const MainApp({
    Key? key,
    this.email,
    this.savedThemeMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: darkTheme(context),
      dark: darkTheme(context),
      initial: savedThemeMode ?? AdaptiveThemeMode.dark,
      builder: (theme, dark) {
        return MaterialApp(
            theme: theme,
            darkTheme: dark,
            debugShowCheckedModeBanner: false,
            home: email == null
                ? const LoginPage() // login page
                : const ActiveTracker());
      },
    );
  }
}
