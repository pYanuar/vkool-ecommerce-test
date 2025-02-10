import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vkool_ecommerce_test/Ui/face_detector.dart'; // Ganti dengan halaman utama Anda
import 'package:vkool_ecommerce_test/Login/resgister_screen.dart';
import 'package:vkool_ecommerce_test/Ui/home_screen.dart'; // Untuk registrasi

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Fungsi untuk login dengan Google
  Future<void> _signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Memulai proses Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() {
          isLoading = false;
        });
        return; // Pengguna membatalkan login
      }

      // Mendapatkan autentikasi Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Membuat kredensial Firebase menggunakan token akses
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Masuk ke Firebase dengan kredensial yang didapatkan
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Menyimpan email dan UID pengguna di shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userEmail', userCredential.user!.email!);
      prefs.setString('userUID', userCredential.user!.uid); // Menyimpan UID

      // Navigasi ke halaman berikutnya setelah login sukses
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomeScreen()), // Ganti dengan halaman utama Anda
      );
    } catch (e) {
      _showDialog("Login Failed", "Failed to sign in with Google: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Login dengan email dan password
  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showDialog("Error", "Please enter both email and password.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Sign in using Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Menyimpan email dan UID pengguna di shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userEmail', email);
      prefs.setString('userUID', userCredential.user!.uid); // Menyimpan UID

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomeScreen()), // Ganti dengan halaman utama Anda
      );
    } catch (e) {
      _showDialog("Login Failed", "Invalid email or password.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Tampilkan dialog kesalahan
  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Fungsi reset password
  Future<void> _resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showDialog(
          "Password Reset", "A password reset email has been sent to $email.");
    } catch (e) {
      _showDialog("Error", "Failed to send password reset email.");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Main content scrollable
          SingleChildScrollView(
            child: Column(
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
                        controller: _emailController,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Username or Email',
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
                        controller: _passwordController,
                        obscureText: _obscurePassword,
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
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      // Forgot Password button
                      TextButton(
                        onPressed: () {
                          _showResetPasswordDialog();
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _login,
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
                        onPressed: _signInWithGoogle,
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
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()));
                        },
                        child: Text(
                          "Don't have an account? Register",
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
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const CircularProgressIndicator(),
                      SizedBox(height: size.height * 0.03),
                      Text('Loading...'),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showResetPasswordDialog() {
    TextEditingController resetEmailController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Reset Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: resetEmailController,
                decoration: InputDecoration(
                  hintText: "Enter your email address",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                String email = resetEmailController.text.trim();
                if (email.isNotEmpty) {
                  _resetPassword(email);
                  Navigator.of(context).pop();
                } else {
                  _showDialog("Error", "Please enter a valid email address.");
                }
              },
              child: Text("Reset Password"),
            ),
          ],
        );
      },
    );
  }
}
