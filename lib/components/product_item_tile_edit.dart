// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ProductItemTileEdit extends StatelessWidget {
  final String itemName;
  final String itemPrice;
  final String imagePath;
  
  final Color color;
  void Function()? onPressed;

  ProductItemTileEdit({
    super.key,
    required this.itemName,
    required this.itemPrice,
    required this.imagePath,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // item image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Image.asset(
                imagePath,
                height: 64,
              ),
            ),

            // item name
            Text(
              itemName,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white
              ),
            ),

            MaterialButton(
              onPressed: onPressed,
              color: Colors.white, //color
              child: Text(
                'Edit',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
