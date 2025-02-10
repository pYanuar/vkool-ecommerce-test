import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vkool_ecommerce_test/Menu/chekout_fragment.dart'; // Import CheckoutFragment

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  // List untuk menyimpan produk yang ditambahkan ke keranjang
  List<Map<String, dynamic>> cartItems = [];

  // Menarik data produk dari Firestore
  Future<List<Map<String, dynamic>>> _fetchProducts() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('products').get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  // Fungsi untuk menambahkan produk ke keranjang
  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      cartItems.add(product); // Menambahkan produk ke list cartItems
    });
    // Menavigasi ke halaman CheckoutFragment dan mengirimkan cartItems
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutFragment(
            cartItems: cartItems), // Kirim data keranjang ke CheckoutFragment
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).viewInsets.bottom + 60.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('List Product'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: bottomPadding,
          ), // Menambahkan padding bawah untuk memberi ruang bagi BottomNavigationBar
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _fetchProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No products found'));
              }

              var products = snapshot.data!;

              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Menampilkan 2 item per baris
                  crossAxisSpacing: 8.0, // Jarak antar item
                  mainAxisSpacing: 8.0, // Jarak antar baris
                  childAspectRatio:
                      0.75, // Menyesuaikan rasio tinggi dan lebar item
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  var product = products[index];
                  return Card(
                    elevation: 4.0,
                    child: Column(
                      children: [
                        // Menampilkan gambar produk dari assets
                        Image.asset(
                          'assets/images/image.png', // Gambar produk di folder assets
                          height: 100.0,
                          fit: BoxFit.cover,
                        ),
                        Spacer(), // Menambahkan Spacer agar bagian bawah berada di bawah
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Menampilkan nama produk
                              Text(
                                product['name'] ?? 'Product Name',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // Menampilkan harga produk
                              Text(
                                "Rp ${product['price'] ?? 0}",
                                style: const TextStyle(color: Colors.green),
                              ),
                              // Tombol "Add to Cart"
                              ElevatedButton.icon(
                                onPressed: () => _addToCart(product),
                                icon: const Icon(Icons.add_shopping_cart),
                                label: const Text('Add to Cart'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.blueAccent, // Warna tombol
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
