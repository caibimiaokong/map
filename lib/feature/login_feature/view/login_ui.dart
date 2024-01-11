import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('Login UI'),
          ElevatedButton(
            onPressed: () {
              context.go('/home');
            },
            child: const Text('Map Screen'),
          ),
        ]),
      ),
    );
  }
}
