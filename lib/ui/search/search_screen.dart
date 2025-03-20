import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mid_term/models/product.dart';
import 'package:mid_term/ui/core/item_product.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<Product> products = [];
  List<Product> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("sanpham").get();
    
    List<Product> loadedProducts = snapshot.docs.map((doc) {
      return Product(
        documentId: doc.id,
        idsp: doc["idsp"],
        ten: doc["ten"],
        loaisp: doc["loaisp"],
        gia: doc["gia"],
        hinhanh: doc["hinhanh"],
      );
    }).toList();

    setState(() {
      products = loadedProducts;
      filteredProducts = products; // Initially show all products
    });
  }

  void searchProducts(String query) {
    setState(() {
      filteredProducts = products.where((product) {
        final nameMatch = product.ten.toLowerCase().contains(query.toLowerCase());
        final categoryMatch = product.loaisp.toLowerCase().contains(query.toLowerCase());
        final priceMatch = product.gia.toString().contains(query); // Convert price to string for search
        
        return nameMatch || categoryMatch || priceMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Search Products"),
      ),
      child: SafeArea(child:  
       Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CupertinoSearchTextField(
              controller: searchController,
              onChanged: searchProducts,
              placeholder: "Search by name, category, or price",
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return ProductItem(product: filteredProducts[index]);
              },
            ),
          ),
        ],
      ),)
    );
  }
}
