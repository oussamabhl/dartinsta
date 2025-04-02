import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'utils/theme.dart';

class InstaApp extends StatelessWidget {
  const InstaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Clone',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const LoginScreen(),
    );
  }
}