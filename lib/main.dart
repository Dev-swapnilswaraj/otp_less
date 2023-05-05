import 'package:flutter/material.dart';
import 'package:otp_less/loadingscreen.dart';
import 'package:otp_less/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTPLESS Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoadinScreen(),
    );
  }
}
