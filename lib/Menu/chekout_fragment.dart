import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vkool_ecommerce_test/Ui/payment_screen.dart'; // Import the PaymentScreen class

class CheckoutFragment extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  CheckoutFragment({super.key, required this.cartItems});

  @override
  _CheckoutFragmentState createState() => _CheckoutFragmentState();
}

class _CheckoutFragmentState extends State<CheckoutFragment> {
  late List<Map<String, dynamic>> cartItems;

  @override
  void initState() {
    super.initState();
    cartItems = widget.cartItems;
  }

  // Fungsi untuk menghapus item dari daftar
  void _deleteItem(int index) {
    setState(() {
      cartItems.removeAt(index); // Menghapus item berdasarkan index
    });
  }

  @override
  Widget build(BuildContext context) {
    double total = 0.0;

    // Menghitung total harga semua item dalam keranjang
    for (var item in cartItems) {
      total += (item['price'] ?? 0.0) *
          (item['quantity'] ?? 1); // Mengalikan harga dengan jumlah kuantitas
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  var product = cartItems[index];
                  return Card(
                    elevation: 4.0,
                    child: ListTile(
                      leading: Image.asset(
                        'assets/images/image.png', // Gambar produk
                        width: 50.0,
                        fit: BoxFit.cover,
                      ),
                      title: Text(product['name'] ?? 'Product Name'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Dropdown untuk memilih warna produk
                          DropdownButton<String>(
                            isExpanded: true,
                            value: product['color'] ??
                                'Red', // Default Red jika belum ada warna yang dipilih
                            hint: const Text("Select Color"),
                            onChanged: (newValue) {
                              setState(() {
                                product['color'] = newValue;
                              });
                            },
                            items:
                                ['Red', 'Blue', 'Green', 'Yellow'].map((color) {
                              return DropdownMenuItem<String>(
                                value: color,
                                child: Text(color),
                              );
                            }).toList(),
                          ),
                          // Dropdown untuk memilih kuantitas produk
                          Row(
                            children: [
                              const Text("Quantity: "),
                              DropdownButton<int>(
                                value: product['quantity'],
                                onChanged: (newQuantity) {
                                  setState(() {
                                    if (newQuantity != null) {
                                      product['quantity'] = newQuantity;
                                    }
                                  });
                                },
                                items: List.generate(10, (index) {
                                  return DropdownMenuItem<int>(
                                    value: index + 1,
                                    child: Text("${index + 1}"),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          // Menampilkan harga produk per item
                          Text("Price: Rp ${product['price']}"),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteItem(
                            index), // Menghapus item saat tombol delete ditekan
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Menampilkan total harga keseluruhan
                  Text(
                    "Total: Rp $total",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Ambil UID pengguna yang sedang login
                      User? user = FirebaseAuth.instance.currentUser;

                      if (user != null) {
                        // Ambil UID pengguna
                        String uid = user.uid;

                        // Kirim cartItems ke Firebase, dengan menyimpannya di bawah UID pengguna
                        for (var item in cartItems) {
                          try {
                            // Menyimpan data setiap item ke koleksi "orders" di bawah UID pengguna
                            await FirebaseFirestore.instance
                                .collection(
                                    'orders') // Koleksi utama untuk semua pesanan
                                .doc(uid) // ID dokumen berdasarkan UID pengguna
                                .collection(
                                    'order_items') // Subkoleksi untuk item pesanan
                                .add({
                              'product_name': item['name'], // Nama produk
                              'price': item['price'], // Harga produk
                              'quantity': item['quantity'], // Kuantitas produk
                              'color': item['color'], // Warna produk
                              'created_at': Timestamp.now(), // Waktu pembuatan
                            });
                          } catch (e) {
                            // Tangani error jika terjadi masalah saat menyimpan
                            print("Error saving order item: $e");
                          }
                        }

                        // Setelah berhasil menyimpan, arahkan ke halaman PaymentScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(
                                totalAmount:
                                    total), // Anda bisa menambahkan cartItems ke PaymentScreen jika perlu
                          ),
                        );
                      } else {
                        // Jika pengguna tidak login, tampilkan pesan error
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please log in to proceed.')),
                        );
                      }
                    },
                    child: const Text('Proceed to Payment'),
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
