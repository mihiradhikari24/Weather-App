import 'package:flutter/material.dart';
import 'package:acm_app_project/pages/home_page.dart';
import 'package:acm_app_project/pages/settings.dart';


void main(){
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: isDarkMode ? MyAppThemes.darkTheme :MyAppThemes.lightTheme,

      home: homePage(
        isDarkMode: isDarkMode,
        toggleTheme: toggleTheme,
      ),
      debugShowCheckedModeBanner: false,
    );
    // theme: ThemeData(
    //   scaffoldBackgroundColor: Colors.grey[300]
    // ),
  }
}

class MyAppThemes {
  static final lightTheme = ThemeData(
    primaryColor: Colors.grey[300],
    brightness: Brightness.light,
  );

  static final darkTheme = ThemeData(
    primaryColor: Colors.grey[800],
    brightness: Brightness.dark,
  );
}