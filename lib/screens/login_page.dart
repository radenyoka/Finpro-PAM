import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_app/screens/homepage.dart';

class MyLoginPage extends StatefulWidget {
  MyLoginPage({Key? key}) : super(key: key);

  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  late bool obsecureText = true;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  late SharedPreferences sharedPreferences;
  late bool newUser;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    newUser = (sharedPreferences.getBool('login') ?? true); // Add "?"
    print(newUser);
    if (newUser == false) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    }
  }

  String calculateMD5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  void printHashForAdminPassword() {
    String hashedPassword = calculateMD5('finpro');
    print('Hashed Password : $hashedPassword');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF3F51B5),
                const Color(0xFF607D8B),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
                    Expanded(
                      flex: 6,
                      child: Lottie.network(
                          'https://lottie.host/03258d70-58f6-4e4b-9b34-29334f665198/MGO7ptYFYj.json'),
                    ),
                    const Spacer(),
                  ],
                ),
                SizedBox(height: 20),
                _usernameField(),
                _passwordField(),
                _loginButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconApp() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: const Icon(
        Icons.dashboard,
        size: 100,
      ),
    );
  }

  Widget _usernameField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        controller: _usernameController,
        enabled: true,
        onChanged: (value) {},
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.person, color: Colors.blueAccent),

          hintText: "Username", // Warna teks hint
          filled: true,
          fillColor: Colors.white, // Warna latar belakang field
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50), // Border radius
            borderSide: BorderSide.none, // Menghilangkan border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50), // Border radius
            borderSide: BorderSide(
              color: Colors.deepPurple, // Warna border ketika dalam fokus
              width: 2.0, // Lebar border ketika dalam fokus
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        controller: _passwordController,
        enabled: true,
        onChanged: (value) {
          setState(() {});
        },
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock, color: Colors.blueAccent),
          hintText: "Password",
          filled: true,
          fillColor: Colors.white, // Warna latar belakang field
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50), // Border radius
            borderSide: BorderSide.none, // Menghilangkan border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50), // Border radius
            borderSide: BorderSide(
              color: Colors.deepPurple, // Warna border ketika dalam fokus
              width: 2.0, // Lebar border ketika dalam fokus
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: MediaQuery.of(context).size.width,
      height: 70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          backgroundColor: Colors.blueAccent,
        ),
        onPressed: () {
          if (_usernameController.text == 'finproPAM' &&
              _passwordController.text == 'finpro') {
            printHashForAdminPassword();
            sharedPreferences.setBool('login', false);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MyHomePage()));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Login Berhasil'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Login Gagal"),
                    content: const Text("Username atau Password Invalid!"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("OK"))
                    ],
                  );
                });
          }
        },
        child: const Text(
          "SIGN IN",
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
