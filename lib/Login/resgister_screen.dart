import 'package:flutter/material.dart';

class ResgisterScreen extends StatefulWidget {
  const ResgisterScreen({super.key});

  @override
  State<ResgisterScreen> createState() => _ResgisterScreenState();
}

class _ResgisterScreenState extends State<ResgisterScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Menyesuaikan dengan ukuran layar ketika keyboard muncul
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
                        ),
                        SizedBox(height: 8.0),
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
                          obscureText: true,
                        ),
                        SizedBox(height: 8.0),
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
