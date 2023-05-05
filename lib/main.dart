import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:otp_less/loadingscreen.dart';

import 'package:otpless_flutter/otpless_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initPlatformState();
  runApp(const MyApp());
}

Future<void> initPlatformState() async {
  final _otplessFlutterPlugin = Otpless();

  _otplessFlutterPlugin.authStream.listen((token) async {
    if (token != null) {
      FlutterSecureStorage storage = const FlutterSecureStorage();
      await storage.write(key: "waId", value: token.toString());
    }
  });
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
