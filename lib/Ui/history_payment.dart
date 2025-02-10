import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ActivityPayment extends StatefulWidget {
  @override
  _ActivityPaymentState createState() => _ActivityPaymentState();
}

class _ActivityPaymentState extends State<ActivityPayment> {
  late Stream<List<Map<String, dynamic>>> orderItemsStream;

  @override
  void initState() {
    super.initState();
    // Ambil data pesanan berdasarkan UID pengguna
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      orderItemsStream = FirebaseFirestore.instance
          .collection('orders')
          .doc(user.uid) // Menggunakan UID pengguna
          .collection('order_items')
          .orderBy('created_at', descending: true) // Urutkan berdasarkan waktu
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => {
                    'name': doc['product_name'],
                    'price': doc['price'],
                    'quantity': doc['quantity'],
                    'color': doc['color'],
                    'created_at': doc['created_at'].toDate(),
                  })
              .toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Payment'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: orderItemsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No orders found.'));
            }

            var orderItems = snapshot.data!;

            return ListView.builder(
              itemCount: orderItems.length,
              itemBuilder: (context, index) {
                var item = orderItems[index];
                return Card(
                  elevation: 4.0,
                  child: ListTile(
                    title: Text(item['name'] ?? 'Product Name'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Color: ${item['color']}"),
                        Text("Quantity: ${item['quantity']}"),
                        Text("Price: Rp ${item['price']}"),
                        Text("Ordered on: ${item['created_at']}"),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
