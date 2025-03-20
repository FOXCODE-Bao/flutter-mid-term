import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mid_term/models/product.dart';
import 'package:mid_term/utils/currency.dart';

class DetailScreen extends StatelessWidget {
  final Product product;

  const DetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('Detail')),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Images
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    File(product.hinhanh),
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Product Name
              Text(
                product.ten,
                style: CupertinoTheme.of(context)
                    .textTheme
                    .navLargeTitleTextStyle
                    .copyWith(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              // Product Type
              Text(
                'Type: ${product.loaisp}',
                style: TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.systemGrey,
                ),
              ),
              SizedBox(height: 8),
              // Product Price
              Text(
                "${formatPrice(product.gia)} VNĐ",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.activeBlue,
                ),
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              // Owner Name
              Text(
                'Owner: ${FirebaseAuth.instance.currentUser!.email}',
                style: TextStyle(fontSize: 16),
              ),
              Spacer(),
              // Quantity Selector and Buy Button
              Row(
                children: [
                  Row(
                    children: [
                      Text('Quantity: ', style: TextStyle(fontSize: 16)),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Icon(CupertinoIcons.minus_circle),
                        onPressed: () {},
                      ),
                      Text('1', style: TextStyle(fontSize: 16)),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Icon(CupertinoIcons.add_circled),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: CupertinoButton.filled(
                      onPressed: () {},
                      child: Text('Buy Now'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
