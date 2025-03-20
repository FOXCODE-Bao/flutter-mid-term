import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mid_term/models/product.dart';
import 'package:mid_term/ui/core/item_product.dart';
import 'package:mid_term/ui/edit/edit_screen.dart';
import 'package:mid_term/ui/profile/profile_screen.dart';
import 'package:mid_term/ui/search/search_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: "Profile",
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) => HomeScreen());
          case 1:
            return CupertinoTabView(builder: (context) => SearchScreen());
          case 2:
            return CupertinoTabView(builder: (context) => ProfileScreen());
          default:
            return CupertinoTabView(builder: (context) => HomeScreen());
        }
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sanphamCollection = FirebaseFirestore.instance.collection("sanpham");
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => EditScreen()),
            );
          },
          child: Icon(CupertinoIcons.add),
        ),
      ),
      child: StreamBuilder(
        stream: sanphamCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CupertinoActivityIndicator()); // Show loading
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No products found"));
          }

          var products =
              snapshot.data!.docs
                  .map((doc) => Product.fromFirestore(doc.data(), doc.id))
                  .toList();

          return SafeArea(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                var product = products[index];
                return ProductItem(product: product);
              },
            ),
          );
        },
      ),
    );
  }
}
