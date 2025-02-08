import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ResgisterScreen extends StatefulWidget {
  const ResgisterScreen({super.key});

  @override
  State<ResgisterScreen> createState() => _ResgisterScreenState();
}

class _ResgisterScreenState extends State<ResgisterScreen> {
  bool isFirebaseInitialized = false;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _errorMessage = '';

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
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Semua kolom harus diisi")),
      );
      return;
    }

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

      // Berhasil mendaftar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Akun berhasil dibuat: ${userCredential.user?.email}")),
      );
    } on FirebaseAuthException catch (e) {
      // Menangani error saat pendaftaran
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pendaftaran gagal: ${e.message}")),
      );
    }
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
      resizeToAvoidBottomInset:
          true, // Menyesuaikan dengan ukuran layar ketika keyboard muncul
      body: SingleChildScrollView(
        child: _isLoading
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

                        // Username Field
                        Text(
                          "Username",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black, // Text color
                            fontWeight: FontWeight.bold, // Font size
                          ),
                        ),
                        SizedBox(height: 3.0),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            filled: true,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.account_circle_sharp,
                                color: Colors.black,
                              ),
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

                        // Email Field
                        Text(
                          "Email",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black, // Text color
                            fontWeight: FontWeight.bold, // Font size
                          ),
                        ),
                        SizedBox(height: 3.0),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            filled: true,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.email_sharp,
                                color: Colors.black,
                              ),
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

                        // Password Field
                        Text(
                          "Password",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black, // Text color
                            fontWeight: FontWeight.bold, // Font size
                          ),
                        ),
                        SizedBox(height: 3.0),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            filled: true,
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

                        // Error Message
                        if (_errorMessage.isNotEmpty)
                          Text(
                            _errorMessage,
                            style: TextStyle(color: Colors.red),
                          ),
                        SizedBox(height: 16.0),

                        // Submit Button
                        ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            elevation: 2,
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 24.0),
                          ),
                          child: _isLoading
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 10),
                                    Text(
                                      'Register',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
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
    );
  }
}
