import 'package:app_api/app/config/const.dart';
import 'package:app_api/app/data/api.dart';
import '../register.dart';
import 'package:app_api/mainpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../../data/sharepre.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  login() async {
    // Get token (save to SharedPreferences)
    String token = await APIRepository()
        .login(accountController.text, passwordController.text);
    var user = await APIRepository().current(token);
    // Save user
    saveUser(user);
    //
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Mainpage()));
    return token;
  }

  @override
  void initState() {
    super.initState();
    // autoLogin();
  }

  autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Mainpage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  Image.asset(
                    urlLogo,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image),
                  ),
                  const Text(
                    "Xin chào, hãy đăng nhập ngay!",
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  TextFormField(
                    controller: accountController,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      labelText: "Tài khoản",
                      labelStyle: TextStyle(color: Colors.black),
                      icon: Icon(Icons.person, color: Colors.black),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    style: const TextStyle(color: Colors.black),
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Mật khẩu",
                      labelStyle: TextStyle(color: Colors.black),
                      icon: Icon(Icons.lock, color: Colors.black),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Handle forgot password
                      },
                      child: const Text(
                        "Quên mật khẩu?",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white, // Button text color
                      side: const BorderSide(color: Colors.black), // Button border color
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text("Đăng nhập"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Register()));
                    },
                    child: const Text(
                      "Người mới, đăng ký ngay?",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.facebook, color: Colors.blue),
                        iconSize: 40,
                        onPressed: () {
                          // Handle Facebook login
                        },
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Hoặc",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.email, color: Colors.red),
                        iconSize: 40,
                        onPressed: () {
                          // Handle Google login
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
