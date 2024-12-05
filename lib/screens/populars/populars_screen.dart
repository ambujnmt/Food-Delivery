import 'package:flutter/material.dart';

class PopularsScreen extends StatefulWidget {
  const PopularsScreen({super.key});

  @override
  State<PopularsScreen> createState() => _PopularsScreenState();
}

class _PopularsScreenState extends State<PopularsScreen> {

  dynamic size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return const Scaffold(
      body: Center(
        child: Text("Populars screen"),
      ),
    );
  }

}
