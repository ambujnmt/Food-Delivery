import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class RestaurantProductsList extends StatefulWidget {
  const RestaurantProductsList({super.key});

  @override
  State<RestaurantProductsList> createState() => _RestaurantProductsListState();
}

class _RestaurantProductsListState extends State<RestaurantProductsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12)),
          height: 50,
          width: 200,
          child: const Center(
            child: Text("Work in Progress"),
          ),
        ),
      )),
    );
  }
}
