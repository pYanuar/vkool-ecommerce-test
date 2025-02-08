import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart'; // import your login screen

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isFirebaseInitialized = false;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isPasswordVisible = false; // Add this variable for password visibility

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _register() async {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Validasi input
    if (username.isEmpty) {
      _showDialog("Peringatan", "Username kolom harus diisi");
      return;
    } else if (email.isEmpty) {
      _showDialog("Peringatan", "Email kolom harus diisi");
      return;
    } else if (password.isEmpty) {
      _showDialog("Peringatan", "Password kolom harus diisi");
      return;
    }

    // Menetapkan status loading menjadi true
    setState(() {
      _isLoading = true;
    });

    try {
      // Mendaftar akun menggunakan Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Menyimpan data username di Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'username': username,
        'email': email,
        'createdAt': Timestamp.now(),
      });

      // Dialog sukses pendaftaran
      _showDialog("Pendaftaran Berhasil", "Akun Anda telah berhasil dibuat.");
    } catch (e) {
      // Menampilkan pesan kesalahan jika terjadi error
      _showDialog("Kesalahan", "Terjadi kesalahan saat mendaftar: $e");
    } finally {
      // Mengubah status loading menjadi false setelah proses selesai
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Menampilkan dialog peringatan atau kesalahan
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
                if (title == "Pendaftaran Berhasil") {
                  // Navigate to the Login screen after successful registration
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                }
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        isFirebaseInitialized = true;
      });
    } catch (e) {
      print("Error initializing Firebase: $e");
      setState(() {
        isFirebaseInitialized = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: _isLoading
                ? Container() // Placeholder for when loading is active
                : Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 300,
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
                            Text("Username",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 3.0),
                            TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                filled: true,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.account_circle_sharp,
                                      color: Colors.black),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 8.0),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Username tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 8.0),
                            Text("Email",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 3.0),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                filled: true,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.email_sharp,
                                      color: Colors.black),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 8.0),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email tidak boleh kosong';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
                                  return 'Email tidak valid';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 8.0),
                            Text("Password",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 3.0),
                            TextFormField(
                              controller: _passwordController,
                              obscureText:
                                  !_isPasswordVisible, // Update this line
                              decoration: InputDecoration(
                                filled: true,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      Icon(Icons.password, color: Colors.black),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 8.0),
                                suffixIcon: IconButton(
                                  // Change to IconButton
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible =
                                          !_isPasswordVisible; // Toggle visibility
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password tidak boleh kosong';
                                }
                                if (value.length < 6) {
                                  return 'Password harus lebih dari 6 karakter';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            if (_errorMessage.isNotEmpty)
                              Text(_errorMessage,
                                  style: TextStyle(color: Colors.red)),
                            SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                elevation: 2,
                                padding: EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 24.0),
                              ),
                              child: _isLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white)
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(width: 10),
                                        Text(
                                          'Register',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
          if (_isLoading)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    backgroundColor: Colors.orange,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Please wait...',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
