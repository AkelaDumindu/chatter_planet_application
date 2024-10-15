import 'package:chatter_planet_application/firebase_options.dart';
import 'package:chatter_planet_application/router/router.dart';
import 'package:chatter_planet_application/utilz/colors.dart';
import 'package:chatter_planet_application/views/responsive/mobile_layout.dart';
import 'package:chatter_planet_application/views/responsive/responsive_layout.dart';
import 'package:chatter_planet_application/views/responsive/web_layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
          fontFamily: GoogleFonts.poppins().fontFamily,
          brightness: Brightness.dark,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.transparent,
              selectedItemColor: mainOrangeColor,
              unselectedItemColor: mainWhiteColor),
          snackBarTheme: SnackBarThemeData(
              backgroundColor: mainOrangeColor,
              contentTextStyle: TextStyle(
                color: mainWhiteColor,
                fontSize: 16,
              ))),
      routerConfig: RouterClass().router,
    );
  }
}
