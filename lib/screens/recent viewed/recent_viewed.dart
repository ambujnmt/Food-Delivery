import 'package:flutter/material.dart';

class RecentViewed extends StatefulWidget {
  const RecentViewed({super.key});

  @override
  State<RecentViewed> createState() => _RecentViewedState();
}

class _RecentViewedState extends State<RecentViewed> {

  dynamic size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return const Scaffold(
      body: Center(
        child: Text("Recent viewed screen"),
      ),
    );
  }

}
