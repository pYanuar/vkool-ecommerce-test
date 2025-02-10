import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final double totalAmount; // Menambahkan parameter totalAmount

  // Konstruktor untuk menerima totalAmount dari halaman sebelumnya
  const PaymentScreen({super.key, required this.totalAmount});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // Fungsi untuk mengirimkan data ke Firestore
  void _submitPaymentDetails() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;

      // Ambil data dari input fields
      String fullName = _nameController.text;
      String email = _emailController.text;
      String phoneNumber = _phoneController.text;
      String bankName = _bankController.text;
      String accountNumber = _accountNumberController.text;
      String address = _addressController.text;

      try {
        // Menyimpan data pembayaran dan informasi pengguna di Firebase
        await FirebaseFirestore.instance
            .collection('users') // Koleksi utama pengguna
            .doc(uid) // ID dokumen berdasarkan UID pengguna
            .collection('order_items') // Subkoleksi untuk item pesanan
            .add({
          'full_name': fullName, // Nama lengkap pengguna
          'email': email, // Email pengguna
          'phone_number': phoneNumber, // Nomor telepon
          'bank_name': bankName, // Nama bank
          'account_number': accountNumber, // Nomor rekening
          'address': address, // Alamat pengiriman
          'total_amount': widget.totalAmount, // Jumlah total pembayaran
          'created_at': Timestamp.now(), // Waktu pembuatan transaksi
        });

        // Tampilkan pesan sukses atau navigasi ke layar lain setelah berhasil
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Payment details submitted successfully!')),
        );

        // Optional: Navigasi ke halaman lain setelah pembayaran sukses (misalnya halaman konfirmasi)
        // Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
      } catch (e) {
        // Tangani error jika terjadi masalah saat menyimpan
        print("Error saving payment details: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error submitting payment details.')),
        );
      }
    } else {
      // Jika pengguna belum login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please log in to submit payment details.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const Text(
                'Personal Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Bank Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _bankController,
                decoration: const InputDecoration(
                  labelText: 'Bank Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _accountNumberController,
                decoration: const InputDecoration(
                  labelText: 'Account Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Shipping Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _addressController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Full Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Menampilkan Total Amount
              Text(
                'Total Amount: \$${widget.totalAmount.toStringAsFixed(2)}', // Menampilkan nilai totalAmount yang diterima
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitPaymentDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Submit Payment Details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
