import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  late SharedPreferences loginData;
  String username = "";

  void initial() async {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      username = loginData.getString('username') ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    initial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            children: [
              const Text('Welcome to Home'),
              const SizedBox(height: 20),
              Text(username),
              ElevatedButton(
                onPressed: () async {
                  // Check if Remember Me is active
                  bool rememberMe = loginData.getBool('rememberMe') ?? false;
                  
                  loginData.setBool('login', true);
                  loginData.remove('username');
                  
                  // Only remove savedUsername if Remember Me is not active
                  if (!rememberMe) {
                    loginData.remove('savedUsername');
                    loginData.remove('rememberMe');
                  }
                  
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
