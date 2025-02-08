import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: isLoading
            ? Container(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Text('loading'),
                ],
              ))
            : Column(
                children: [
                  // Background image with logo in the center
                  Container(
                    width: double.infinity,
                    height: 400,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/background_login.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 150,
                          height: 150,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 16.0),
                        // Email field with logo inside
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Username',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.email_outlined,
                                color: Colors.black,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 8.0),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        // Password field with logo inside
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Password',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.password,
                                color: Colors.black,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 8.0),
                            suffixIcon: Icon(Icons.visibility),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          "Forget Password ?",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.black, // Text color
                            fontWeight: FontWeight.bold, // Font size
                          ),
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            // Tindakan saat tombol ditekan
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            elevation: 2,
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 24.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 10),
                              Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Or',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        ElevatedButton(
                          onPressed: () {
                            // Tindakan saat tombol ditekan
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            elevation: 2,
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 24.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/icons8-google-50.png',
                                width: 20,
                                height: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Sign in with Google',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Menambahkan teks "Don't have an account? Sign up" di bawah tombol
                        SizedBox(
                            height:
                                20), // Memberikan jarak antara tombol dan teks
                        GestureDetector(
                          onTap: () {
                            // Tindakan saat teks di-tap, misalnya navigasi ke halaman daftar
                            print("Navigating to Sign Up Page");
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                          },
                          child: Text(
                            "Don't have an account? Sign up",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
