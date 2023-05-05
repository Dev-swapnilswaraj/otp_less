import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:otp_less/homescreen.dart';
import 'package:otp_less/login.dart';
import 'package:http/http.dart' as http;
import 'package:otp_less/userModel.dart';

class LoadinScreen extends StatefulWidget {
  const LoadinScreen({super.key});

  @override
  State<LoadinScreen> createState() => _LoadinScreenState();
}

class _LoadinScreenState extends State<LoadinScreen> {
  bool isLoggedIn = false;
  bool isLoading = true;
  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      checkForUserData();
    });
    super.initState();
  }

  Future<void> checkForUserData() async {
    isLoading = true;
    FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.read(key: "waId").then((value) async {
      if (value != null) {
        http.Response data =
            await http.post(Uri.parse("https://muncho.authlink.me"),
                headers: {
                  'Content-Type': 'application/json',
                  'Charset': 'utf-8',
                  'clientId': '4ancmj4m',
                  'clientSecret': 'po9a3l50fejcuxnv'
                },
                body: jsonEncode({"waId": value.toString()}));
        var val = jsonDecode(data.body);
        UserData user = UserData.fromJson(val['user']);
        await storage.write(key: "userData", value: jsonEncode(user.toJson()));
        isLoggedIn = true;
        _timer.cancel();
      }
    });
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : isLoggedIn
              ? const HomeScreen()
              : const LoginScreen(),
    );
  }
}
