import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:otp_less/loadingscreen.dart';
import 'package:otp_less/userModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  late UserData user;

  @override
  void initState() {
    // TODO: implement initState
    checkForUserData();
    super.initState();
  }

  Future<void> checkForUserData() async {
    isLoading = true;
    FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.read(key: "userData").then((value) {
      user = UserData.fromJson(jsonDecode(value!));
    });
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff73c8a9),
                  Color(0xffffffff),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome ${user.waName}\n${user.waNumber}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () async {
                      FlutterSecureStorage storage =
                          const FlutterSecureStorage();
                      await storage.delete(key: "userData");
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (ctx) => const LoadinScreen()),
                          (route) => false);
                    },
                    child: const Text("LOGOUT"))
              ],
            ),
          );
  }
}
