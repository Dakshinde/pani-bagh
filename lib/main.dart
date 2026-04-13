import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dashboard.dart'; // <--- Check if this line is exactly like this
void main() {
  runApp(const PaniBaghApp());
}

class PaniBaghApp extends StatelessWidget {
  const PaniBaghApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pani Bagh',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        primarySwatch: Colors.blue,
      ),
      home: const Dashboard(),
    );
  }
}