//flutter library
import 'dart:async';
import 'package:flutter/material.dart';

//pubdev library
import 'package:go_router/go_router.dart';

//local library

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final bool _isSignedIn = false;
  // init state
  @override
  void initState() {
    super.initState();
    // create a timer of 2 seconds
    Timer(const Duration(seconds: 2), () {
      _isSignedIn == false ? context.go('/LoginScreen') : context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Center(
          child: Text('Splash UI'),
        ),
      ),
    );
  }
}
