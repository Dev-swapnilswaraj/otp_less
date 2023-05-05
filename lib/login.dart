import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:otp_less/homescreen.dart';
import 'package:otp_less/userModel.dart';
import 'package:otpless_flutter/otpless_flutter.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _otplessFlutterPlugin = Otpless();
  bool switchToHome = false;

  // ** Function to initiate the login process
  void initiateWhatsappLogin(String intentUrl) async {
    var result =
        await _otplessFlutterPlugin.loginUsingWhatsapp(intentUrl: intentUrl);
    switch (result['code']) {
      case "581":
        print(result['message']);
        //TODO: handle whatsapp not found
        break;
      default:
    }
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // ** Function that is called when page is loaded
  // ** We can check the auth state in this function
  Future<void> initPlatformState() async {
    _otplessFlutterPlugin.authStream.listen((token) async {
      FlutterSecureStorage storage = const FlutterSecureStorage();
      // await storage.write(key: "waId", value: token.toString());
      http.Response data =
          await http.post(Uri.parse("https://muncho.authlink.me"),
              headers: {
                'Content-Type': 'application/json',
                'Charset': 'utf-8',
                'clientId': '4ancmj4m',
                'clientSecret': 'po9a3l50fejcuxnv'
              },
              body: jsonEncode({"waId": token.toString()}));
      var val = jsonDecode(data.body);
      UserData user = UserData.fromJson(val['user']);
      await storage.write(key: "userData", value: jsonEncode(user.toJson()));
      switchToHome = true;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return switchToHome
        ? const HomeScreen()
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      initiateWhatsappLogin(
                          "https://muncho.authlink.me?redirectUri=munchootpless://otpless");
                    },
                    child: Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          "Login via WhatsApp",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
  }
}
