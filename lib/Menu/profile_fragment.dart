import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileFragment extends StatefulWidget {
  @override
  _ProfileFragmentState createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  // Variabel untuk menyimpan data pengguna
  late String fullName;
  late String email;
  late String phoneNumber;
  late String address;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserData(); // Ambil data pengguna saat halaman pertama kali di-load
  }

  // Fungsi untuk mengambil data pengguna berdasarkan UID
  void _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Ambil data pengguna berdasarkan UID
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users') // Koleksi pengguna
            .doc(user.uid) // ID dokumen berdasarkan UID pengguna
            .get();

        if (userDoc.exists) {
          // Jika dokumen ditemukan, ambil data dari dokumen
          setState(() {
            fullName = userDoc['username'] ?? 'No name available';
            email = userDoc['email'] ?? 'No email available';

            isLoading = false;
          });
        } else {
          // Jika dokumen tidak ditemukan
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        // Tangani error jika terjadi masalah saat mengambil data
        print('Error getting user data: $e');
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'username: $fullName',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Email: $email',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
    );
  }
}
